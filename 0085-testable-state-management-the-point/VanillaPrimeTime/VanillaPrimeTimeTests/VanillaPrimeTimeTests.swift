import XCTest
@testable import VanillaPrimeTime
import SwiftUI


extension Binding {
  init(initialValue: Value) {
    var value = initialValue
    self.init(get: { value }, set: { value = $0 })
  }
}


class VanillaPrimeTimeTests: XCTestCase {

//  func testRemoveFavoritesPrimesTapped() {
//    var state = (count: 3, favoritePrimes: [3, 5])
//    let effects = primeModalReducer(state: &state, action: .removeFavoritePrimeTapped)
//
//    let (count, favoritePrimes) = state
//    XCTAssertEqual(count, 3)
//    XCTAssertEqual(favoritePrimes, [5])
//    XCTAssert(effects.isEmpty)
//  }

  func testIsPrimeModalView() {
    let view = IsPrimeModalView(
      activityFeed: Binding<[AppState.Activity]>(initialValue: []),
      count: 2,
      favoritePrimes: Binding<[Int]>(initialValue: [2, 3, 5])
    )

    view.removeFavoritePrime()

    XCTAssertEqual(view.favoritePrimes, [3, 5])

    view.saveFavoritePrime()

    XCTAssertEqual(view.favoritePrimes, [3, 5, 2])
  }

  func testCounterView() {
    let view = CounterView(state: AppState())

    view.incrementCount()

    XCTAssertEqual(view.state.count, 1)

    view.incrementCount()

    XCTAssertEqual(view.state.count, 2)

    view.decrementCount()

    XCTAssertEqual(view.state.count, 1)

    XCTAssertEqual(view.state.isNthPrimeButtonDisabled, false)

    view.nthPrimeButtonAction()

    XCTAssertEqual(view.state.isNthPrimeButtonDisabled, true)

//    view.primeMod
  }
}
