import XCTest
@testable import PrimeTime
import ComposableArchitecture
@testable import Counter
@testable import ComposableArchitectureTestSupport
import WolframAlpha

class PrimeTimeTests: XCTestCase {

  func testCounterAndFavoritePrimesIntegration() {
    assert(
      initialValue: CounterViewState(
        count: 1,
        favoritePrimes: []
      ),
      reducer: appReducer,
      environment: AppEnvironment(
        counter: <#T##CounterEnvironment#>,
        favoritePrimes: <#T##FavoritePrimesEnvironment#>,
        offlineNthPrime: <#T##(Int) -> Effect<Int?>#>
      ),
      steps:
      Step(.send, .counterView(.counter(.incrTapped))) {
        $0.count = 2
      }
//      Step(.send, .counter(.nthPrimeButtonTapped)) {
//        $0.isNthPrimeButtonDisabled = true
//      },
//      Step(.receive, .counter(.nthPrimeResponse(n: 2, prime: 17))) {
//        $0.alertNthPrime = PrimeAlert(n: 2, prime: 17)
//        $0.isNthPrimeButtonDisabled = false
//      },
//      Step(.send, .counter(.alertDismissButtonTapped)) {
//        $0.alertNthPrime = nil
//      },
//      Step(.send, .primeModal(.saveFavoritePrimeTapped)) {
//        $0.favoritePrimes = [2]
//      },
//      Step(.send, AppAction.favoritePrimes(.primeButtonTapped(2)))
//      Step(.receive, .favoritePrimes(.nthPrimeResponse(n: 2, prime: 17))) {
//        _ in
//      }
    )
  }
}
