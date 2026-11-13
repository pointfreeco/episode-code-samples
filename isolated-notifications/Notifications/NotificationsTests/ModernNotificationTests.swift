import Testing

@testable import Notifications

struct ModernNotificationsTests {
  @MainActor @Test func mainActor() {
    let model = Model()
    model.mainActorIncrementButtonTapped()
    #expect(model.count == 1)
  }

  @MainActor @Test func `observers are notified in order`() {
    let center = ModernNotificationCenter()
    var values: [Int] = []
    let tokens = (1...10).map { index in
      center.addObserver(for: MainActorIncrementMessage.self) { _ in
        values.append(index)
      }
    }
    center.post(MainActorIncrementMessage())
    #expect(values == Array(1...10))
    _ = tokens
  }
}

