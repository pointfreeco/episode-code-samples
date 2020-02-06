import XCTest
@testable import PrimeModal
import ComposableArchitectureTestSupport

class PrimeModalTests: XCTestCase {
  func testSaveFavoritesPrimesTapped() {
    assert(
      initialValue: PrimeModalState(count: 2, favoritePrimes: [3, 5]),
      reducer: primeModalReducer,
      steps: Step(.send, .saveFavoritePrimeTapped) {
        $0.favoritePrimes = [3, 5, 2]
      }
    )
  }

  func testRemoveFavoritesPrimesTapped() {
    assert(
      initialValue: PrimeModalState(count: 3, favoritePrimes: [3, 5]),
      reducer: primeModalReducer,
      steps: Step(.send, .removeFavoritePrimeTapped) {
        $0.favoritePrimes = [5, 2]
      }
    )
  }
}
