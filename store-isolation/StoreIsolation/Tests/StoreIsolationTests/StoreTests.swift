import Testing
@testable import StoreIsolation

@Suite struct StoreTests {
  @Test func basics() async throws {
    let store = Store(initialState: Counter.State(), feature: Counter())

    store.send(.incrementButtonTapped)
    #expect(store.count == 1)
  }
}
