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
      $0.path[id: 0] = .counter()
    }
    await store.send(.path(.popFrom(id: 0))) {
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

    await store.send(.path(.element(id: 0, action: .counter(.incrementButtonTapped)))) {
      XCTModify(&$0.path[id: 0], case: /RootFeature.Path.State.counter) {
        $0.count = 1
      }
    }
    await store.send(.path(.popFrom(id: 0))) {
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

    await store.send(.path(.element(id: 0, action: .counter(.toggleTimerButtonTapped)))) {
      XCTModify(&$0.path[id: 0], case: /RootFeature.Path.State.counter) {
        $0.isTimerOn = true
      }
    }
    await clock.advance(by: .seconds(1))
    await store.receive(.path(.element(id: 0, action: .counter(.timerTick)))) {
      XCTModify(&$0.path[id: 0], case: /RootFeature.Path.State.counter) {
        $0.count = 1
      }
    }
    await clock.advance(by: .seconds(1))
    await store.receive(.path(.element(id: 0, action: .counter(.timerTick)))) {
      XCTModify(&$0.path[id: 0], case: /RootFeature.Path.State.counter) {
        $0.count = 2
      }
    }
    await clock.advance(by: .seconds(1))
    await store.receive(.path(.element(id: 0, action: .counter(.timerTick)))) {
      XCTModify(&$0.path[id: 0], case: /RootFeature.Path.State.counter) {
        $0.count = 3
      }
    }
    await store.send(.path(.popFrom(id: 0))) {
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

    await store.send(.path(.element(id: 0, action: .numberFact(.factButtonTapped))))
    await store.send(.path(.popFrom(id: 0))) {
      $0.path = StackState()
    }
  }

  func testCounterFeature_LoadAndGoToCounter() async {
    let store = TestStore(
      initialState: RootFeature.State(
        path: StackState([
          .counter(CounterFeature.State(count: 42))
        ])
      ),
      reducer: RootFeature()
    ) {
      $0.continuousClock = ImmediateClock()
    }

    await store.send(.path(.element(id: 0, action: .counter(.loadAndGoToCounterButtonTapped)))) {
      XCTModify(&$0.path[id: 0], case: /RootFeature.Path.State.counter) {
        $0.isLoading = true
      }
    }
    await store.receive(.path(.element(id: 0, action: .counter(.loadResponse)))) {
      XCTModify(&$0.path[id: 0], case: /RootFeature.Path.State.counter) {
        $0.isLoading = false
      }
    }
    await store.receive(.path(.element(id: 0, action: .counter(.delegate(.goToCounter(42)))))) {
      $0.path[id: 1] = .counter(CounterFeature.State(count: 42))
    }
    await store.send(.path(.popFrom(id: 0))) {
      $0.path = StackState()
    }
  }

  func testCounterFeature_LoadAndGoToCounter_NonExhaustive() async {
    let store = TestStore(
      initialState: RootFeature.State(
        path: StackState([
          .counter(CounterFeature.State(count: 42))
        ])
      ),
      reducer: RootFeature()
    ) {
      $0.continuousClock = ImmediateClock()
    }
    store.exhaustivity = .off

    await store.send(.path(.element(id: 0, action: .counter(.loadAndGoToCounterButtonTapped))))
    await store.receive(.path(.element(id: 0, action: .counter(.delegate(.goToCounter(42)))))) {
      $0.path[id: 1] = .counter(CounterFeature.State(count: 42))
    }
  }

  func testSummary() async {
    let store = TestStore(
      initialState: RootFeature.State(),
      reducer: RootFeature()
    )

    XCTAssertEqual(store.state.sum, 0)
    await store.send(.path(.push(.counter(CounterFeature.State(count: 42))))) {
      $0.path[id: 0] = .counter(CounterFeature.State(count: 42))
    }
    XCTAssertEqual(store.state.sum, 42)
    await store.send(.path(.push(.counter(CounterFeature.State(count: 1729))))) {
      $0.path[id: 1] = .counter(CounterFeature.State(count: 1729))
    }
    XCTAssertEqual(store.state.sum, 1771)
    await store.send(.path(.push(.numberFact(NumberFactFeature.State(number: 1771))))) {
      $0.path[id: 2] = .numberFact(NumberFactFeature.State(number: 1771))
    }
    XCTAssertEqual(store.state.sum, 1771)
    await store.send(.path(.popFrom(id: 1))) {
      $0.path.pop(from: 1)
    }
    XCTAssertEqual(store.state.sum, 42)
    await store.send(.path(.popFrom(id: 0))) {
      $0.path.pop(from: 0)
    }
    XCTAssertEqual(store.state.sum, 0)
  }

  func testSummary_NonExhaustive() async {
    let clock = TestClock()
    let store = TestStore(
      initialState: RootFeature.State(),
      reducer: RootFeature()
    ) {
      $0.continuousClock = clock
    }
    store.exhaustivity = .off(showSkippedAssertions: true)

    XCTAssertEqual(store.state.sum, 0)
    await store.send(.path(.push(.counter(CounterFeature.State(count: 42)))))
    await store.send(.path(.element(id: 0, action: .counter(.toggleTimerButtonTapped))))
    XCTAssertEqual(store.state.sum, 42)
    await store.send(.path(.push(.counter(CounterFeature.State(count: 55)))))
    await store.send(.path(.element(id: 1, action: .counter(.toggleTimerButtonTapped))))
    XCTAssertEqual(store.state.sum, 97)
    await store.send(.path(.push(.numberFact(NumberFactFeature.State(number: 55)))))
    XCTAssertEqual(store.state.sum, 97)

    await clock.advance(by: .seconds(5))
    await store.skipReceivedActions()
    XCTAssertEqual(store.state.sum, 107)

    await store.send(.path(.popFrom(id: 1)))
    XCTAssertEqual(store.state.sum, 47)
    await store.send(.path(.popFrom(id: 0)))
    XCTAssertEqual(store.state.sum, 0)
  }

  func testCounterFeature_TimerDismissal() async {
    let store = TestStore(
      initialState: RootFeature.State(
        path: StackState([
          .counter(CounterFeature.State(count: 97))
        ])
      ),
      reducer: RootFeature()
    ) {
      $0.continuousClock = ImmediateClock()
    }

    await store.send(.path(.element(id: 0, action: .counter(.toggleTimerButtonTapped)))) {
      XCTModify(&$0.path[id: 0], case: /RootFeature.Path.State.counter) {
        $0.isTimerOn = true
      }
    }
    await store.receive(.path(.element(id: 0, action: .counter(.timerTick)))) {
      XCTModify(&$0.path[id: 0], case: /RootFeature.Path.State.counter) {
        $0.count = 98
      }
    }
    await store.receive(.path(.element(id: 0, action: .counter(.timerTick)))) {
      XCTModify(&$0.path[id: 0], case: /RootFeature.Path.State.counter) {
        $0.count = 99
      }
    }
    await store.receive(.path(.element(id: 0, action: .counter(.timerTick)))) {
      XCTModify(&$0.path[id: 0], case: /RootFeature.Path.State.counter) {
        $0.count = 100
      }
    }
    await store.receive(.path(.popFrom(id: 0))) {
      $0.path = StackState()
    }
  }

  func testCounterFeature_TimerDismissal_NonExhaustive() async {
    let store = TestStore(
      initialState: RootFeature.State(
        path: StackState([
          .counter(CounterFeature.State(count: 97))
        ])
      ),
      reducer: RootFeature()
    ) {
      $0.continuousClock = ImmediateClock()
    }
    store.exhaustivity = .off

    await store.send(.path(.element(id: 0, action: .counter(.toggleTimerButtonTapped))))
    await store.receive(.path(.popFrom(id: 0)))
  }

  func testGenerationalIDs() async {
    let store = TestStore(
      initialState: RootFeature.State(),
      reducer: RootFeature()
    )

    await store.send(.path(.push(.counter()))) {
      $0.path[id: 0] = .counter()
    }
    await store.send(.path(.popFrom(id: 0))) {
      $0.path = StackState()
    }
    await store.send(.path(.push(.counter()))) {
      $0.path[id: 1] = .counter()
    }
    await store.send(.path(.popFrom(id: 1))) {
      $0.path = StackState()
    }
    await store.send(.path(.push(.counter()))) {
      $0.path[id: 2] = .counter()
    }
    await store.send(.path(.popFrom(id: 2))) {
      $0.path = StackState()
    }
  }
}














