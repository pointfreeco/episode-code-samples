import Testing
@testable import StoreIsolation

@Suite struct StoreTests {
  @Test func basics() async throws {
    let store = Store(initialState: Counter.State(), feature: Counter())

    store.send(.incrementButtonTapped)
    #expect(store.count == 1)
  }

  @Test func `increment then decrement`() async throws {
    let store = Store(initialState: Counter.State(), feature: Counter())

    store.send(.incrementThenDecrementButtonTapped)
    #expect(store.count == 0)
  }

  @Test func fact() async throws {
    let store = Store(
      initialState: Counter.State(),
      feature: Counter(fact: { "\($0) is a good number!" })
    )

    store.send(.factButtonTapped)
    #expect(store.fact == "0 is a good number!")
  }

  @Test func race() async throws {
    let store = Store(initialState: Counter.State(), feature: Counter())

    for _ in 1...100 {
      store.send(.incrementThenDecrementButtonTapped)
    }
    try await Task.sleep(for: .seconds(0.1))
    #expect(store.count == 0)
  }

  @Test func async() async throws {
    let store = Store(initialState: Counter.State(), feature: Counter())

    for _ in 1...100 {
      store.send(.asyncIncrementThenDecrementButtonTapped)
    }
    try await Task.sleep(for: .seconds(0.1))
    #expect(store.count == 0)
  }

}
