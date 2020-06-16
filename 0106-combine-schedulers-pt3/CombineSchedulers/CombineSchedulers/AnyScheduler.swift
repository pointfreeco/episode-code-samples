import Combine

struct AnyScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler
  where SchedulerTimeType: Strideable, SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible
{
  func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
    self._schedulerWithInterval(date, interval, tolerance, options, action)
  }

  private let _schedulerWithInterval: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void) -> Cancellable

  func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
    self._scheduleAfterDelay(date, tolerance, options, action)
  }

  private let _scheduleAfterDelay: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void) -> Void

  func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
    self._schedule(options, action)
  }

  private let _schedule: (SchedulerOptions?, @escaping () -> Void) -> Void

  var now: SchedulerTimeType {
    self._now()
  }
  var minimumTolerance: SchedulerTimeType.Stride {
    self._minimumTolerance()
  }

  private let _now: () -> SchedulerTimeType
  private let _minimumTolerance: () -> SchedulerTimeType.Stride


  init<S: Scheduler>(
    _ scheduler: S
  ) where S.SchedulerTimeType == SchedulerTimeType, S.SchedulerOptions == SchedulerOptions {

    self._now = { scheduler.now }
    self._minimumTolerance = { scheduler.minimumTolerance }
    self._schedule = { scheduler.schedule(options: $0, $1) }
    self._scheduleAfterDelay = { scheduler.schedule(after: $0, tolerance: $1, options: $2, $3) }
    self._schedulerWithInterval = { scheduler.schedule(after: $0, interval: $1, tolerance: $2, options: $3, $4) }
  }
}

typealias AnySchedulerOf<S: Scheduler> = AnyScheduler<S.SchedulerTimeType, S.SchedulerOptions>
