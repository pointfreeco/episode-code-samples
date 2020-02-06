import XCTest
@testable import PrimeTime
import ComposableArchitecture
@testable import Counter
@testable import ComposableArchitectureTestSupport
import WolframAlpha
@testable import FavoritePrimes

class PrimeTimeTests: XCTestCase {

  func testCounterAndFavoritePrimesIntegration() {
    let mock = AppEnvironment(
      counter: CounterEnvironment(nthPrime: { _ in .sync { 17 } }),
      favoritePrimes: FavoritePrimesEnvironment(
        fileClient: FileClient(
          load: { _ in Effect<Data?>.sync {
            try! JSONEncoder().encode([2, 31])
            } },
          save: { _, _ in .fireAndForget {} }
        ),
        nthPrime: { _ in .sync { 17 } }
      ),
      offlineNthPrime: { _ in .sync { 17 } }
    )

    assert(
      initialValue: AppState(count: 1),
      reducer: appReducer,
      environment: mock,
      steps:
      Step(.send, .counterView(.counter(.incrTapped))) {
        $0.count = 2
      },
      Step(.send, .counterView(.counter(.nthPrimeButtonTapped))) {
        $0.isNthPrimeButtonDisabled = true
      },
      Step(.receive, .counterView(.counter(.nthPrimeResponse(n: 2, prime: 17)))) {
        $0.alertNthPrime = PrimeAlert(n: 2, prime: 17)
        $0.isNthPrimeButtonDisabled = false
      },
      Step(.send, .counterView(.counter(.alertDismissButtonTapped))) {
        $0.alertNthPrime = nil
      },
      Step(.send, .counterView(.primeModal(.saveFavoritePrimeTapped))) {
        $0.favoritePrimes = [2]
      },
      Step(.send, .favoritePrimes(.primeButtonTapped(2))),
      Step(.receive, .favoritePrimes(.nthPrimeResponse(n: 2, prime: 17))) {
        $0.alertNthPrime = PrimeAlert(n: 2, prime: 17)
      },
      Step(.send, .favoritePrimes(.alertDismissButtonTapped)) {
        $0.alertNthPrime = nil
      }
    )
  }
}
