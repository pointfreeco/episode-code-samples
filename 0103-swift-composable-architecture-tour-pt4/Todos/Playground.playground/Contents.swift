import Combine
import Foundation

/// A type-erasing scheduler that defines when and how to execute a closure.
public struct AnyScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler
where
  SchedulerTimeType: Strideable,
  SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible
{

  private let _minimumTolerance: () -> SchedulerTimeType.Stride
  private let _now: () -> SchedulerTimeType
  private let _scheduleAfterIntervalToleranceSchedulerOptionsAction:
    (
      SchedulerTimeType,
      SchedulerTimeType.Stride,
      SchedulerTimeType.Stride,
      SchedulerOptions?,
      @escaping () -> Void
    ) -> Cancellable
  private let _scheduleAfterToleranceSchedulerOptionsAction:
    (
      SchedulerTimeType,
      SchedulerTimeType.Stride,
      SchedulerOptions?,
      @escaping () -> Void
    ) -> Void
  private let _scheduleSchedulerOptionsAction: (SchedulerOptions?, @escaping () -> Void) -> Void

  /// The minimum tolerance allowed by the scheduler.
  public var minimumTolerance: SchedulerTimeType.Stride { self._minimumTolerance() }

  /// This scheduler’s definition of the current moment in time.
  public var now: SchedulerTimeType { self._now() }

  let scheduler: Any

  /// Creates a type-erasing scheduler to wrap the provided scheduler.
  ///
  /// - Parameters:
  ///   - scheduler: A scheduler to wrap with a type-eraser.
  public init<S>(
    _ scheduler: S
  )
  where
    S: Scheduler, S.SchedulerTimeType == SchedulerTimeType, S.SchedulerOptions == SchedulerOptions
  {
    self.scheduler = scheduler
    self._now = { scheduler.now }
    self._minimumTolerance = { scheduler.minimumTolerance }
    self._scheduleAfterToleranceSchedulerOptionsAction = scheduler.schedule
    self._scheduleAfterIntervalToleranceSchedulerOptionsAction = scheduler.schedule
    self._scheduleSchedulerOptionsAction = scheduler.schedule
  }

  /// Performs the action at some time after the specified date.
  public func schedule(
    after date: SchedulerTimeType,
    tolerance: SchedulerTimeType.Stride,
    options: SchedulerOptions?,
    _ action: @escaping () -> Void
  ) {
    self._scheduleAfterToleranceSchedulerOptionsAction(date, tolerance, options, action)
  }

  /// Performs the action at some time after the specified date, at the
  /// specified frequency, taking into account tolerance if possible.
  public func schedule(
    after date: SchedulerTimeType,
    interval: SchedulerTimeType.Stride,
    tolerance: SchedulerTimeType.Stride,
    options: SchedulerOptions?,
    _ action: @escaping () -> Void
  ) -> Cancellable {
    self._scheduleAfterIntervalToleranceSchedulerOptionsAction(
      date, interval, tolerance, options, action)
  }

  /// Performs the action at the next possible opportunity.
  public func schedule(
    options: SchedulerOptions?,
    _ action: @escaping () -> Void
  ) {
    self._scheduleSchedulerOptionsAction(options, action)
  }
}

/// A convenience type to specify an `AnyScheduler` by the scheduler it wraps rather than by the
/// time type and options type.
public typealias AnySchedulerOf<Scheduler> = AnyScheduler<
  Scheduler.SchedulerTimeType, Scheduler.SchedulerOptions
> where Scheduler: Combine.Scheduler

extension Scheduler {
  /// Wraps this scheduler with a type eraser.
  public func eraseToAnyScheduler() -> AnyScheduler<SchedulerTimeType, SchedulerOptions> {
    AnyScheduler(self)
  }
}

import Combine
import Foundation

/// A scheduler whose current time and execution can be controlled in a deterministic manner.
public final class TestScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler
where SchedulerTimeType: Strideable, SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {

  public let minimumTolerance: SchedulerTimeType.Stride = .zero
  public private(set) var now: SchedulerTimeType
  private var scheduled: [(id: UUID, date: SchedulerTimeType, action: () -> Void)] = []

  /// Creates a test scheduler with the given date.
  ///
  /// - Parameter now: The current date of the test scheduler.
  public init(now: SchedulerTimeType) {
    self.now = now
  }

  /// Advances the scheduler by the given stride.
  ///
  /// - Parameter stride: A stride.
  public func advance(by stride: SchedulerTimeType.Stride = .zero) {
    self.scheduled = self.scheduled
      // NB: Stabilizes sort via index.
      .enumerated()
      .sorted(by: { $0.element.date < $1.element.date || $0.offset < $1.offset })
      .map { $0.element }

    guard
      let nextDate = self.scheduled.first?.date,
      self.now.advanced(by: stride) >= nextDate
    else {
      self.now = self.now.advanced(by: stride)
      return
    }

    let delta = self.now.distance(to: nextDate)
    self.now = nextDate

    while let (_, date, action) = self.scheduled.first, date == nextDate {
      action()
      self.scheduled.removeFirst()
    }

    self.advance(by: stride - delta)
  }

  /// Runs the scheduler until it has no scheduled items left.
  public func run() {
    while let date = self.scheduled.first?.date {
      self.advance(by: self.now.distance(to: date))
    }
  }

  public func schedule(
    after date: SchedulerTimeType,
    interval: SchedulerTimeType.Stride,
    tolerance: SchedulerTimeType.Stride,
    options: SchedulerOptions?,
    _ action: @escaping () -> Void
  ) -> Cancellable {

    let id = UUID()

    func scheduleAction(_ date: SchedulerTimeType) -> () -> Void {
      return { [weak self] in
        action()
        self?.scheduled.append((id, date, scheduleAction(date.advanced(by: interval))))
      }
    }

    self.scheduled.append((id, date, scheduleAction(date.advanced(by: interval))))

    return AnyCancellable { [weak self] in
      self?.scheduled.removeAll(where: { $0.id == id })
    }
  }

  public func schedule(
    after date: SchedulerTimeType,
    tolerance: SchedulerTimeType.Stride,
    options: SchedulerOptions?,
    _ action: @escaping () -> Void
  ) {
    self.scheduled.append((UUID(), date, action))
  }

  public func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
    self.scheduled.append((UUID(), self.now, action))
  }
}

extension Scheduler
where
  SchedulerTimeType == DispatchQueue.SchedulerTimeType,
  SchedulerOptions == DispatchQueue.SchedulerOptions
{
  /// A test scheduler of dispatch queues.
  public static var testScheduler: TestSchedulerOf<Self> {
    // NB: `DispatchTime(uptimeNanoseconds: 0) == .now())`. Use `1` for consistency.
    TestScheduler(now: SchedulerTimeType(DispatchTime(uptimeNanoseconds: 1)))
  }
}

extension Scheduler
where
  SchedulerTimeType == RunLoop.SchedulerTimeType,
  SchedulerOptions == RunLoop.SchedulerOptions
{
  /// A test scheduler of run loops.
  public static var testScheduler: TestSchedulerOf<Self> {
    TestScheduler(now: SchedulerTimeType(Date(timeIntervalSince1970: 0)))
  }
}

extension Scheduler
where
  SchedulerTimeType == OperationQueue.SchedulerTimeType,
  SchedulerOptions == OperationQueue.SchedulerOptions
{
  /// A test scheduler of operation queues.
  public static var testScheduler: TestSchedulerOf<Self> {
    TestScheduler(now: SchedulerTimeType(Date(timeIntervalSince1970: 0)))
  }
}

/// A convenience type to specify a `TestScheduler` by the scheduler it wraps rather than by the
/// time type and options type.
public typealias TestSchedulerOf<Scheduler> = TestScheduler<
  Scheduler.SchedulerTimeType, Scheduler.SchedulerOptions
> where Scheduler: Combine.Scheduler


import Combine
import Dispatch
import Foundation

//Just(1)
//.debounce(for: <#T##SchedulerTimeIntervalConvertible & Comparable & SignedNumeric#>, scheduler: <#T##Scheduler#>)

var cancellables: Set<AnyCancellable> = []

//DispatchQueue.main.schedule {
//  print("DispatchQueue")
//}
//DispatchQueue.main.schedule(after: .init(.now() + 1)) {
//  print("DispatchQueue", "delayed")
//}
//DispatchQueue.main.schedule(after: .init(.now()), interval: 1) {
//  print("DispatchQueue", "timer")
//}.store(in: &cancellables)
//
//
//RunLoop.main.schedule {
//  print("RunLoop")
//}
//RunLoop.main.schedule(after: .init(Date() + 1)) {
//  print("RunLoop", "delayed")
//}
//RunLoop.main.schedule(after: .init(Date()), interval: 1) {
//  print("RunLoop", "timer")
//}.store(in: &cancellables)
//
//OperationQueue.main.schedule {
//  print("OperationQueue")
//}
//OperationQueue.main.schedule(after: .init(Date() + 1)) {
//  print("OperationQueue", "delayed")
//}
//OperationQueue.main.schedule(after: .init(Date()), interval: 1) {
//  print("OperationQueue", "timer")
//}.store(in: &cancellables)


let scheduler = DispatchQueue.testScheduler

scheduler.schedule {
  print("TestScheduler")
}

scheduler.advance()

scheduler.schedule(after: scheduler.now.advanced(by: 1)) {
  print("TestScheduler", "delayed")
}

scheduler.advance(by: 1)

scheduler.schedule(after: scheduler.now, interval: 1) {
  print("TestScheduler", "timer")
}

scheduler.advance()
scheduler.advance(by: 1000)


//Just(1)
//.receive(on: <#T##Scheduler#>)
//.subscribe(on: <#T##Scheduler#>)
//.timeout(<#T##interval: SchedulerTimeIntervalConvertible & Comparable & SignedNumeric##SchedulerTimeIntervalConvertible & Comparable & SignedNumeric#>, scheduler: <#T##Scheduler#>)
//.throttle(for: <#T##SchedulerTimeIntervalConvertible & Comparable & SignedNumeric#>, scheduler: <#T##Scheduler#>, latest: <#T##Bool#>)
//.debounce(for: <#T##SchedulerTimeIntervalConvertible & Comparable & SignedNumeric#>, scheduler: <#T##Scheduler#>)
//.delay(for: <#T##SchedulerTimeIntervalConvertible & Comparable & SignedNumeric#>, scheduler: <#T##Scheduler#>)
