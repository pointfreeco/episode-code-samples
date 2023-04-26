import ComposableArchitecture
import XCTest

@testable import Inventory

@MainActor
class StackExplorationTests: XCTestCase {
  func testBasics() async {
    let store = TestStore(
      initialState: RootFeature.State(),
      reducer: RootFeature()
    )

    await store.send(.path(.push(.counter()))) {
      $0.path.append(.counter())
    }
    await store.send(.path(.popFrom(id: store.state.path.ids[0]))) {
      $0.path = StackState()
    }
  }

  func testCounterFeature() async {
    let store = TestStore(
      initialState: RootFeature.State(
        path: StackState([
          .counter()
        ])
      ),
      reducer: RootFeature()
    )

    await store.send(.path(.element(id: store.state.path.ids[0], action: .counter(.incrementButtonTapped)))) {
      XCTModify(&$0.path[id: $0.path.ids[0]], case: /RootFeature.Path.State.counter) {
        $0.count = 1
      }
    }
    await store.send(.path(.popFrom(id: store.state.path.ids[0]))) {
      $0.path = StackState()
    }
  }
}














