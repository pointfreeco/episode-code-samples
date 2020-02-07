import XCTest
@testable import PrimeTime
import ComposableArchitecture
@testable import Counter

class PrimeTimeTests: XCTestCase {

  func testExample() {
    let c = CounterView(store: Store(initialValue: CounterViewState(alertNthPrime: nil, count: 2, favoritePrimes: [2, 3, 5], isNthPrimeButtonDisabled: false), reducer: counterViewReducer))

    let cc = ContentView(store: Store(initialValue: AppState(), reducer: appReducer))

    print(c.body)
    let tmp = c.body
    print(type(of: tmp))

    print(cc.body)
    let tmp1 = cc.body
    print(type(of: tmp1))
  }

}
