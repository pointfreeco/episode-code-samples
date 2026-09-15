import Testing
@testable import StoreIsolation

@MainActor
@Suite struct StoreTests {
  @Test func basics() async throws {
    let store = Store(initialState: Counter.State(), feature: Counter())

    store.send(.incrementButtonTapped)
    #expect(store.count == 1)
  }

  @Test func `increment then decrement`() async throws {
    let store = Store(initialState: Counter.State(), feature: Counter())

    store.send(.incrementThenDecrementButtonTapped)
    try await Task.sleep(for: .seconds(0.01))
    #expect(store.count == 0)
  }

  @Test func fact() async throws {
    let store = Store(
      initialState: Counter.State(),
      feature: Counter(fact: { "\($0) is a good number!" })
    )

    store.send(.factButtonTapped)
    try await Task.sleep(for: .seconds(0.01))
    #expect(store.fact == "0 is a good number!")
  }
}
