import Foundation
import Testing
@testable import StoreIsolation

@Suite struct StoreActorTests {
  @Test(arguments: 1...1000) func basics(_: Int) async throws {
    let store = await StoreActor(
      initialState: Counter.State(),
      feature: Counter()
    )

    await store.send(.incrementButtonTapped)
    await #expect(store.state.count == 1)
    _ = {Thread.sleep(forTimeInterval: 0.001)}()
  }

  @Test func `increment then decrement`() async throws {
    let store = await StoreActor(initialState: Counter.State(), feature: Counter())

    await store.send(.incrementThenDecrementButtonTapped)
    await #expect(store.state.count == 0)
  }

  @Test func fact() async throws {
    let store = await StoreActor(
      initialState: Counter.State(),
      feature: Counter(fact: { "\($0) is a good number!" })
    )

    await store.send(.factButtonTapped)
    await #expect(store.state.fact == "0 is a good number!")
  }

  @Test func race() async throws {
    let store = await StoreActor(initialState: Counter.State(), feature: Counter())

    for _ in 1...100 {
      await store.send(.incrementThenDecrementButtonTapped)
    }
    await #expect(store.state.count == 0)
  }

  @Test func async() async throws {
    let store = await StoreActor(initialState: Counter.State(), feature: Counter())

    for _ in 1...100 {
      await store.send(.asyncIncrementThenDecrementButtonTapped)
    }
    try await Task.sleep(for: .seconds(0.2))
    await #expect(store.state.count == 0)
  }


}
