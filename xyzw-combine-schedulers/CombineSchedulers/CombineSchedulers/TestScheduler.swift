import Combine
import Dispatch

final class TestScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler where SchedulerTimeType: Strideable, SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
  
  var minimumTolerance: SchedulerTimeType.Stride = 0
  var now: SchedulerTimeType
  private var scheduled: [(action: () -> Void, date: SchedulerTimeType)] = []
  
  init(now: SchedulerTimeType) {
    self.now = now
  }
  
  func advance(by stride: SchedulerTimeType.Stride = .zero) {
    self.now = self.now.advanced(by: stride)

    for (action, date) in self.scheduled {
      if date <= self.now {
        action()
      }
    }

    self.scheduled.removeAll(where: { $0.date <= self.now })
  }
  
  func schedule(
    options _: SchedulerOptions?,
    _ action: @escaping () -> Void
  ) {
    self.scheduled.append((action, self.now))
  }
  
  func schedule(
    after date: SchedulerTimeType,
    tolerance _: SchedulerTimeType.Stride,
    options _: SchedulerOptions?,
    _ action: @escaping () -> Void
  ) {
    self.scheduled.append((action, date))
  }

  func schedule(
    after date: SchedulerTimeType,
    interval: SchedulerTimeType.Stride,
    tolerance _: SchedulerTimeType.Stride,
    options _: SchedulerOptions?,
    _ action: @escaping () -> Void
  ) -> Cancellable {

    func scheduleAction(for date: SchedulerTimeType) -> () -> Void {
      return { [weak self] in
        action()
        let nextDate = date.advanced(by: interval)
        self?.scheduled.append((scheduleAction(for: nextDate), nextDate))
      }
    }

    self.scheduled.append((scheduleAction(for: date), date))

    return AnyCancellable {}
  }
}

extension DispatchQueue {
  static var testScheduler: TestScheduler<SchedulerTimeType, SchedulerOptions> {
    TestScheduler(now: .init(.init(uptimeNanoseconds: 1)))
  }
}
