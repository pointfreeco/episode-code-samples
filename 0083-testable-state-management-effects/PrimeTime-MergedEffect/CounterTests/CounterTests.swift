import XCTest
@testable import Counter

class CounterTests: XCTestCase {
  override func setUp() {
    super.setUp()
    Current = .mock
  }

  func testIncrButtonTapped() {
    var state = CounterViewState(
      alertNthPrime: nil,
      count: 2,
      favoritePrimes: [3, 5],
      isNthPrimeButtonDisabled: false
    )
    let effects = counterViewReducer(&state, .counter(.incrTapped))

    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 3,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: false
      )
    )
    effects.sink { _ in XCTFail() }
  }

  func testDecrButtonTapped() {
    var state = CounterViewState(
      alertNthPrime: nil,
      count: 2,
      favoritePrimes: [3, 5],
      isNthPrimeButtonDisabled: false
    )
    let effects = counterViewReducer(&state, .counter(.decrTapped))

    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 1,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: false
      )
    )
    effects.sink { _ in XCTFail() }
  }

  func testNthPrimeButtonHappyFlow() {
    Current.nthPrime = { _ in .sync { 17 } }

    var state = CounterViewState(
      alertNthPrime: nil,
      count: 2,
      favoritePrimes: [3, 5],
      isNthPrimeButtonDisabled: false
    )

    var effects = counterViewReducer(&state, .counter(.nthPrimeButtonTapped))

    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 2,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: true
      )
    )
//    XCTAssertEqual(effects.count, 1)

    var nextAction: CounterViewAction!
    let receivedCompletion = self.expectation(description: "receivedCompletion")
    effects.sink(
      receiveCompletion: { _ in
        receivedCompletion.fulfill()
    },
      receiveValue: { action in
        XCTAssertEqual(action, .counter(.nthPrimeResponse(17)))
        nextAction = action
    }
    )
    self.wait(for: [receivedCompletion], timeout: 0.01)

    effects = counterViewReducer(&state, nextAction)

    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: PrimeAlert(prime: 17),
        count: 2,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: false
      )
    )
    effects.sink { _ in XCTFail() }

    effects = counterViewReducer(&state, .counter(.alertDismissButtonTapped))

    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 2,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: false
      )
    )
    effects.sink { _ in XCTFail() }
  }

  func testNthPrimeButtonUnhappyFlow() {
    Current.nthPrime = { _ in .sync { nil } }

    var state = CounterViewState(
      alertNthPrime: nil,
      count: 2,
      favoritePrimes: [3, 5],
      isNthPrimeButtonDisabled: false
    )

    var effects = counterViewReducer(&state, .counter(.nthPrimeButtonTapped))

    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 2,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: true
      )
    )
//    XCTAssertEqual(effects.count, 1)


    var nextAction: CounterViewAction!
    let receivedCompletion = self.expectation(description: "receivedCompletion")
    effects.sink(
      receiveCompletion: { _ in
        receivedCompletion.fulfill()
    },
      receiveValue: { action in
        XCTAssertEqual(action, .counter(.nthPrimeResponse(nil)))
        nextAction = action
    }
    )
    self.wait(for: [receivedCompletion], timeout: 0.01)

    effects = counterViewReducer(&state, nextAction)

//    effects = counterViewReducer(&state, .counter(.nthPrimeResponse(nil)))

    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 2,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: false
      )
    )
    effects.sink { _ in XCTFail() }
  }

  func testPrimeModal() {
    var state = CounterViewState(
      alertNthPrime: nil,
      count: 2,
      favoritePrimes: [3, 5],
      isNthPrimeButtonDisabled: false
    )

    var effects = counterViewReducer(&state, .primeModal(.saveFavoritePrimeTapped))

    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 2,
        favoritePrimes: [3, 5, 2],
        isNthPrimeButtonDisabled: false
      )
    )
    effects.sink { _ in XCTFail() }

    effects = counterViewReducer(&state, .primeModal(.removeFavoritePrimeTapped))

    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 2,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: false
      )
    )
    effects.sink { _ in XCTFail() }
  }

}
