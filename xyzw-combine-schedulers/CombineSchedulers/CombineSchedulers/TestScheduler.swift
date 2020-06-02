import Combine
import Dispatch

final class TestScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler where SchedulerTimeType: Strideable, SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
  
  var minimumTolerance: SchedulerTimeType.Stride = 0
  var now: SchedulerTimeType
  private var scheduled: [() -> Void] = []
  
  init(now: SchedulerTimeType) {
    self.now = now
  }
  
  func advance() {
    for action in self.scheduled {
      action()
    }
    self.scheduled.removeAll()
  }
  
  func schedule(
    options _: SchedulerOptions?,
    _ action: @escaping () -> Void
  ) {
    self.scheduled.append(action)
  }
  
  func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
    
  }

  func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
    return AnyCancellable {}
  }

}

extension DispatchQueue {
  static var testScheduler: TestScheduler<SchedulerTimeType, SchedulerOptions> {
    TestScheduler(now: .init(.init(uptimeNanoseconds: 1)))
  }
}
