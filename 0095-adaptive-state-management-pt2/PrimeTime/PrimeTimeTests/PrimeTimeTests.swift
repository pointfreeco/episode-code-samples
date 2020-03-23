import ComposableArchitecture
import ComposableArchitectureTestSupport
@testable import Counter
@testable import FavoritePrimes
import PrimeAlert
@testable import PrimeModal
@testable import PrimeTime
import XCTest

class PrimeTimeTests: XCTestCase {
  func testIntegration() {
    var fileClient = FileClient.mock
    fileClient.load = { _ in .sync { try! JSONEncoder().encode([2, 31, 7]) } }

    assert(
      initialValue: AppState(count: 4),
      reducer: appReducer,
      environment: (
        fileClient: fileClient,
        nthPrime: { _ in .sync { 17 } },
        offlineNthPrime: { _ in .sync { 17 } }
      ),
      steps:
      Step(.send, .counterView(.counter(.nthPrimeButtonTapped))) {
        $0.isNthPrimeRequestInFlight = true
      },
      Step(.receive, .counterView(.counter(.nthPrimeResponse(n: 4, prime: 17)))) {
        $0.isNthPrimeRequestInFlight = false
        $0.alertNthPrime = PrimeAlert(n: 4, prime: 17)
      },
      Step(.send, .favoritePrimes(.loadButtonTapped)),
      Step(.receive, .favoritePrimes(.loadedFavoritePrimes([2, 31, 7]))) {
        $0.favoritePrimes = [2, 31, 7]
      }
    )
  }
}
