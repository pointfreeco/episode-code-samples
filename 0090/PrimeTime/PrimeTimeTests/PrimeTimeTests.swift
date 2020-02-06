import XCTest
@testable import PrimeTime
import ComposableArchitecture
@testable import Counter
import ComposableArchitectureTestSupport
@testable import FavoritePrimes

class PrimeTimeTests: XCTestCase {

  func testIntegration() {
    assert(
      initialValue: AppState(count: 2, favoritePrimes: []),
      reducer: appReducer,
      environment: (
        fileClient: .mock,
        nthPrime: { _ in .sync { 17 } }
      ),
      steps:
      Step(.send, .counterView(.counter(.nthPrimeButtonTapped))) {
        $0.isNthPrimeButtonDisabled = true
      },
      Step(.receive, .counterView(.counter(.nthPrimeResponse(17)))) {
        $0.isNthPrimeButtonDisabled = false
        $0.alertNthPrime = PrimeAlert(prime: 17)
      },
      Step(.send, .counterView(.counter(.alertDismissButtonTapped))) {
        $0.alertNthPrime = nil
      },
      Step(.send, .favoritePrimes(.loadButtonTapped)),
      Step(.receive, .favoritePrimes(.loadedFavoritePrimes([2, 31]))) {
        $0.favoritePrimes = [2, 31]
      }
    )
  }

}
