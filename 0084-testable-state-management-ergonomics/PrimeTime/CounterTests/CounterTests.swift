import XCTest
@testable import Counter

class CounterTests: XCTestCase {
  override class func setUp() {
    super.setUp()
  }

  func testIncrDecrButtonTapped() {
    assert(
      initialValue: CounterViewState(count: 2),
      reducer: counterViewReducer,
      environment: .mock,
      steps:
      Step(.send, .counter(.incrTapped)) { $0.count = 3 },
      Step(.send, .counter(.incrTapped)) { $0.count = 4 },
      Step(.send, .counter(.decrTapped)) { $0.count = 3 }
    )
  }

  func testNthPrimeButtonHappyFlow() {
    var env = CounterEnvironment.mock
    env.nthPrime = { _ in .sync { 17 } }

    assert(
      initialValue: CounterViewState(
        alertNthPrime: nil,
        isNthPrimeButtonDisabled: false
      ),
      reducer: counterViewReducer,
      environment: env,
      steps:
      Step(.send, .counter(.nthPrimeButtonTapped)) {
        $0.isNthPrimeButtonDisabled = true
      },
      Step(.receive, .counter(.nthPrimeResponse(17))) {
        $0.alertNthPrime = PrimeAlert(prime: 17)
        $0.isNthPrimeButtonDisabled = false
      },
      Step(.send, .counter(.alertDismissButtonTapped)) {
        $0.alertNthPrime = nil
      }
    )
  }

  func testNthPrimeButtonUnhappyFlow() {
    var env = CounterEnvironment.mock
    env.nthPrime = { _ in .sync { nil } }

    assert(
      initialValue: CounterViewState(
        alertNthPrime: nil,
        isNthPrimeButtonDisabled: false
      ),
      reducer: counterViewReducer,
      environment: env,
      steps:
      Step(.send, .counter(.nthPrimeButtonTapped)) {
        $0.isNthPrimeButtonDisabled = true
      },
      Step(.receive, .counter(.nthPrimeResponse(nil))) {
        $0.isNthPrimeButtonDisabled = false
      }
    )
  }

  func testPrimeModal() {
    assert(
      initialValue: CounterViewState(
        count: 2,
        favoritePrimes: [3, 5]
      ),
      reducer: counterViewReducer,
      environment: .mock,
      steps:
      Step(.send, .primeModal(.saveFavoritePrimeTapped)) {
        $0.favoritePrimes = [3, 5, 2]
      },
      Step(.send, .primeModal(.removeFavoritePrimeTapped)) {
        $0.favoritePrimes = [3, 5]
      }
    )
  }
}
