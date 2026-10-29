import Testing

@testable import Notifications

struct NotificationsTests {

  @MainActor
  @Test func increment() throws {
    let model = Model()

    model.incrementButtonTapped()
    #expect(model.count == 1)

    for _ in 1...1_000 {
      model.incrementButtonTapped()
    }
    #expect(model.count == 1_001)
  }

}
