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

  @MainActor
  @Test func newIncrement() async throws {
    let model = Model()

    model.newIncrementButtonTapped()
    try await Task.sleep(for: .seconds(0.01))
    #expect(model.count == 1)
  }

  @MainActor
  @Test func mainActorIncrement() async throws {
    let model = Model()

    model.mainActorIncrementButtonTapped()
    #expect(model.count == 1)
    model.mainActorIncrement1000ButtonTapped()
    #expect(model.count == 1_001)
  }
}
