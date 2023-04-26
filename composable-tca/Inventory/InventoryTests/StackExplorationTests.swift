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

  func testCounterFeature_Timer() async {
    let clock = TestClock()
    let store = TestStore(
      initialState: RootFeature.State(
        path: StackState([
          .counter()
        ])
      ),
      reducer: RootFeature()
    ) {
      $0.continuousClock = clock
    }

    await store.send(.path(.element(id: store.state.path.ids[0], action: .counter(.toggleTimerButtonTapped)))) {
      XCTModify(&$0.path[id: $0.path.ids[0]], case: /RootFeature.Path.State.counter) {
        $0.isTimerOn = true
      }
    }
    await clock.advance(by: .seconds(1))
    await store.receive(.path(.element(id: store.state.path.ids[0], action: .counter(.timerTick)))) {
      XCTModify(&$0.path[id: $0.path.ids[0]], case: /RootFeature.Path.State.counter) {
        $0.count = 1
      }
    }
    await clock.advance(by: .seconds(1))
    await store.receive(.path(.element(id: store.state.path.ids[0], action: .counter(.timerTick)))) {
      XCTModify(&$0.path[id: $0.path.ids[0]], case: /RootFeature.Path.State.counter) {
        $0.count = 2
      }
    }
    await clock.advance(by: .seconds(1))
    await store.receive(.path(.element(id: store.state.path.ids[0], action: .counter(.timerTick)))) {
      XCTModify(&$0.path[id: $0.path.ids[0]], case: /RootFeature.Path.State.counter) {
        $0.count = 3
      }
    }
    await store.send(.path(.popFrom(id: store.state.path.ids[0]))) {
      $0.path = StackState()
    }
  }

  func testCounterFeature_InvalidAction() async {
    let clock = TestClock()
    let store = TestStore(
      initialState: RootFeature.State(
        path: StackState([
          .counter()
        ])
      ),
      reducer: RootFeature()
    ) {
      $0.continuousClock = clock
    }

    XCTExpectFailure()

    await store.send(.path(.element(id: store.state.path.ids[0], action: .numberFact(.factButtonTapped))))
    await store.send(.path(.popFrom(id: store.state.path.ids[0]))) {
      $0.path = StackState()
    }
  }
}














