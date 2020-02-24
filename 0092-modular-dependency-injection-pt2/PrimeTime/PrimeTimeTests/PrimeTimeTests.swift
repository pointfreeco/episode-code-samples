import XCTest
@testable import PrimeTime
import ComposableArchitecture
@testable import Counter
@testable import FavoritePrimes
@testable import PrimeModal
import ComposableArchitectureTestSupport

class PrimeTimeTests: XCTestCase {
  func testIntegration() {
//    Counter.Current = .mock
//    FavoritePrimes.Current = .mock

    var fileClient = FileClient.mock
    fileClient.load = { _ in Effect<Data?>.sync {
    try! JSONEncoder().encode([2, 31, 7])
    } }

    assert(
      initialValue: AppState(count: 4),
      reducer: appReducer,
      environment: (
        fileClient: fileClient,
        nthPrime: { _ in .sync { 17 } }
      ),
      steps:
      Step(.send, .counterView(.counter(.nthPrimeButtonTapped))) {
        $0.isNthPrimeButtonDisabled = true
      },
      Step(.receive, .counterView(.counter(.nthPrimeResponse(n: 4, prime: 17)))) {
        $0.isNthPrimeButtonDisabled = false
        $0.alertNthPrime = PrimeAlert(n: 4, prime: 17)
      },
      Step(.send, .favoritePrimes(.loadButtonTapped)),
      Step(.receive, .favoritePrimes(.loadedFavoritePrimes([2, 31, 7]))) {
        $0.favoritePrimes = [2, 31, 7]
      }
    )
  }
}
