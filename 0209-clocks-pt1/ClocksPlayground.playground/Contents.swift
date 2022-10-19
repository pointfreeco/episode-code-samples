import Foundation

Task {
  let start = DispatchTime.now().uptimeNanoseconds
  try await Task.sleep(for: .seconds(1))
  print("Duration", DispatchTime.now().uptimeNanoseconds - start)
}

Task {
  let clock = SuspendingClock()
  let duration = try await clock.measure {
    try await clock.sleep(until: clock.now.advanced(by: .seconds(1)))
  }
  print("Suspending Duration", duration)
}

Task {
  let clock = ContinuousClock()
  let duration = try await clock.measure {
    try await clock.sleep(until: clock.now.advanced(by: .seconds(1)))
    // perform work
  }
  print("Continuous Duration", duration)
}

Task {
  let clock = ContinuousClock()
  let start = clock.now
  var count = 0
  while true {
    count += 1
    try await clock.sleep(until: clock.now.advanced(by: .milliseconds(count)))
    print("Timer tick", clock.now - start)
  }
}
