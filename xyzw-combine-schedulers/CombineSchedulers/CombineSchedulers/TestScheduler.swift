import Combine
import Dispatch

final class TestScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler where SchedulerTimeType: Strideable, SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
  
  var minimumTolerance: SchedulerTimeType.Stride = 0
  var now: SchedulerTimeType
  private var lastId = 0
  
  private var scheduled: [(id: Int, action: () -> Void, date: SchedulerTimeType)] = []
  
  init(now: SchedulerTimeType) {
    self.now = now
  }
  
  func advance(by stride: SchedulerTimeType.Stride = .zero) {

    self.scheduled.sort { lhs, rhs in
      (lhs.date, lhs.id) < (rhs.date, rhs.id)
    }

    guard
      let nextDate = scheduled.first?.date,
      self.now.advanced(by: stride) >= nextDate
      else {
        self.now = self.now.advanced(by: stride)
        return
    }

    let nextStride = stride - self.now.distance(to: nextDate)
    self.now = nextDate

    while let (_, action, date) = self.scheduled.first, date == nextDate {
      self.scheduled.removeFirst()
      action()
    }

    self.advance(by: nextStride)


//    self.now = self.now.advanced(by: stride)
//
//    var index = 0
//    while index < self.scheduled.count {
//      let (id, action, date) = self.scheduled[index]
//      if date <= self.now {
//        action()
//        self.scheduled.remove(at: index)
//      } else {
//        index += 1
//      }
//    }
//    for (id, action, date) in self.scheduled {
//      if date <= self.now {
//        action()
//      }
//    }

    self.scheduled.removeAll(where: { $0.date <= self.now })
  }
  
  func schedule(
    options _: SchedulerOptions?,
    _ action: @escaping () -> Void
  ) {
    self.scheduled.append((self.nextId(), action, self.now))
  }
  
  func schedule(
    after date: SchedulerTimeType,
    tolerance _: SchedulerTimeType.Stride,
    options _: SchedulerOptions?,
    _ action: @escaping () -> Void
  ) {
    self.scheduled.append((self.nextId(), action, date))
  }

  func schedule(
    after date: SchedulerTimeType,
    interval: SchedulerTimeType.Stride,
    tolerance _: SchedulerTimeType.Stride,
    options _: SchedulerOptions?,
    _ action: @escaping () -> Void
  ) -> Cancellable {
    
    let id = self.nextId()

    func scheduleAction(for date: SchedulerTimeType) -> () -> Void {
      return { [weak self] in
        let nextDate = date.advanced(by: interval)
        self?.scheduled.append((id, scheduleAction(for: nextDate), nextDate))
        action()
      }
    }

    self.scheduled.append((id, scheduleAction(for: date), date))

    return AnyCancellable {
      self.scheduled.removeAll(where: { $0.id == id })
    }
  }
  
  private func nextId() -> Int {
    self.lastId += 1
    return self.lastId
  }
}

extension DispatchQueue {
  static var testScheduler: TestScheduler<SchedulerTimeType, SchedulerOptions> {
    TestScheduler(now: .init(.init(uptimeNanoseconds: 1)))
  }
}
