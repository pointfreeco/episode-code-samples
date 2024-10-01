import Testing

struct BackToBasicsEquatableTests {
  @Test
  func notifier() async throws {
    var timerTickCount = 0
    let cancellable = NotificationCenter.default
      .publisher(for: Notification.Name("TimerNotifier-main"))
      .sink { _ in timerTickCount += 1 }

    var notifiers = Set([TimerNotifier(name: "main")])

    do {
      let notifier = TimerNotifier(name: "main")
      notifier.startTimer()
      #expect(notifiers.insert(notifier).inserted)
    }

    try await Task.sleep(for: .seconds(1.1))
    #expect(timerTickCount == 1)

    _ = cancellable
  }
}

import Foundation

final class TimerNotifier: Hashable {
  static func == (lhs: TimerNotifier, rhs: TimerNotifier) -> Bool {
    lhs.name == rhs.name
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }

  let name: String
  var task: Task<Void, Error>?

  init(name: String) {
    self.name = name
  }

  deinit {
    task?.cancel()
  }

  func startTimer() {
    task = Task { [name] in
      while true {
        try await Task.sleep(for: .seconds(1))
        NotificationCenter.default.post(
          name: Notification.Name("TimerNotifier-\(name)"),
          object: nil
        )
      }
    }
  }

  func stopTimer() {
    task?.cancel()
    task = nil
  }
}
