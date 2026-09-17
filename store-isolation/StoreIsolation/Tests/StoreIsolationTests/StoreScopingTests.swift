import Testing

@testable import StoreIsolation

@Suite
struct StoreScopingTests {
  @MainActor
  @Test
  func scoping() async throws {
    let store = Store(
      initialState: Counter.State(),
      feature: Counter()
    )

    let childStore = store.scope(\.count)
    childStore.send(.incrementButtonTapped)
    #expect(store.count == 1)
  }

  @Test
  func `store actor scoping`() async throws {
    let store = await StoreActor(
      initialState: Counter.State(),
      feature: Counter()
    )

    let childStore = await store.scope(\.count)
    await childStore.send(.incrementButtonTapped)
    await #expect(store.state.count == 1)
  }
}
