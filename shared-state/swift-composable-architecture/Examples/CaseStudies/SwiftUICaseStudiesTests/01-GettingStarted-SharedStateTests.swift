import ComposableArchitecture
import XCTest

@testable import SwiftUICaseStudies

@MainActor
final class SharedStateTests: XCTestCase {
  func testTabSelection() async {
    let store = TestStore(initialState: SharedState.State()) {
      SharedState()
    }

    await store.send(.selectTab(.profile)) {
      $0.currentTab = .profile
      //$0.stats.increment()
      $0.counter.stats.increment()
    }
    await store.send(.selectTab(.counter)) {
      $0.currentTab = .counter
      //$0.stats.increment()
      $0.profile.stats.increment()
    }
  }

  func testSharedCounts() async {
    let store = TestStore(initialState: SharedState.State()) {
      SharedState()
    }

    await store.send(.counter(.incrementButtonTapped))
    XCTAssertEqual(
      store.state.stats,
      Stats(count: 1, maxCount: 1, minCount: 0, numberOfCounts: 1)
    )
//    {
//      $0.counter.stats.increment()
//      $0.profile.stats.increment()
//    }
    await store.send(.counter(.decrementButtonTapped)) 
    XCTAssertEqual(
      store.state.stats,
      Stats(count: 0, maxCount: 1, minCount: 0, numberOfCounts: 2)
    )
//    {
//      $0.counter.stats.decrement()
//      $0.profile.stats.decrement()
//    }
    await store.send(.profile(.resetStatsButtonTapped)) 
//    {
//      $0.counter.stats = Stats()
//      $0.profile.stats = Stats()
//    }
    XCTAssertEqual(
      store.state.stats,
      Stats()
    )
  }

  func testAlert() async {
    let store = TestStore(initialState: SharedState.State()) {
      SharedState()
    }

    await store.send(.counter(.isPrimeButtonTapped)) {
      $0.counter.alert = AlertState {
        TextState("👎 The number 0 is not prime :(")
      }
    }
  }
}
