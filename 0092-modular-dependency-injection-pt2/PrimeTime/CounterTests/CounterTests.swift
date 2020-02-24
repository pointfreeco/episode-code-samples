import XCTest
@testable import Counter
import ComposableArchitecture
import ComposableArchitectureTestSupport
import SnapshotTesting
import SwiftUI

class CounterTests: XCTestCase {
//  override func setUp() {
//    super.setUp()
//    Current = .mock
//  }

//  func testSnapshots() {
//    let store = Store(initialValue: CounterViewState(), reducer: counterViewReducer, environment: { _ in .sync { 17 } })
//    let view = CounterView(store: store)
//
//    let vc = UIHostingController(rootView: view)
//    vc.view.frame = UIScreen.main.bounds
//
//    assertSnapshot(matching: vc, as: .windowedImage)
//
//    store.send(.counter(.incrTapped))
//    assertSnapshot(matching: vc, as: .windowedImage)
//
//    store.send(.counter(.incrTapped))
//    assertSnapshot(matching: vc, as: .windowedImage)
//
//    store.send(.counter(.nthPrimeButtonTapped))
//    assertSnapshot(matching: vc, as: .windowedImage)
//
//    var expectation = self.expectation(description: "wait")
//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//      expectation.fulfill()
//    }
//    self.wait(for: [expectation], timeout: 0.5)
//    assertSnapshot(matching: vc, as: .windowedImage)
//
//    store.send(.counter(.alertDismissButtonTapped))
//    expectation = self.expectation(description: "wait")
//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//      expectation.fulfill()
//    }
//    self.wait(for: [expectation], timeout: 0.5)
//    assertSnapshot(matching: vc, as: .windowedImage)
//
//    store.send(.counter(.isPrimeButtonTapped))
//    assertSnapshot(matching: vc, as: .windowedImage)
//
//    store.send(.primeModal(.saveFavoritePrimeTapped))
//    assertSnapshot(matching: vc, as: .windowedImage)
//
//    store.send(.counter(.primeModalDismissed))
//    assertSnapshot(matching: vc, as: .windowedImage)
//  }

  func testIncrDecrButtonTapped() {
    assert(
      initialValue: CounterViewState(count: 2),
      reducer: counterViewReducer,
      environment: { _ in .sync { 17 } },
      steps:
      Step(.send, .counter(.incrTapped)) { $0.count = 3 },
      Step(.send, .counter(.incrTapped)) { $0.count = 4 },
      Step(.send, .counter(.decrTapped)) { $0.count = 3 }
    )
  }

  func testNthPrimeButtonHappyFlow() {
//    Current.nthPrime =

    assert(
      initialValue: CounterViewState(
        alertNthPrime: nil,
        count: 7,
        isNthPrimeButtonDisabled: false
      ),
      reducer: counterViewReducer,
      environment: { _ in .sync { 17 } },
      steps:
      Step(.send, .counter(.nthPrimeButtonTapped)) {
        $0.isNthPrimeButtonDisabled = true
      },
      Step(.receive, .counter(.nthPrimeResponse(n: 7, prime: 17))) {
        $0.alertNthPrime = PrimeAlert(n: $0.count, prime: 17)
        $0.isNthPrimeButtonDisabled = false
      },
      Step(.send, .counter(.alertDismissButtonTapped)) {
        $0.alertNthPrime = nil
      }
    )
  }

  func testNthPrimeButtonUnhappyFlow() {
//    Current.nthPrime =

    assert(
      initialValue: CounterViewState(
        alertNthPrime: nil,
        count: 7,
        isNthPrimeButtonDisabled: false
      ),
      reducer: counterViewReducer,
      environment: { _ in .sync { nil } },
      steps:
      Step(.send, .counter(.nthPrimeButtonTapped)) {
        $0.isNthPrimeButtonDisabled = true
      },
      Step(.receive, .counter(.nthPrimeResponse(n: 7, prime: nil))) {
        $0.isNthPrimeButtonDisabled = false
      }
    )
  }

  func testPrimeModal() {
//    Current = .mock
    
    assert(
      initialValue: CounterViewState(
        count: 1,
        favoritePrimes: [3, 5]
      ),
      reducer: counterViewReducer,
      environment: { _ in .sync { 17 } },
      steps:
      Step(.send, .counter(.incrTapped)) {
        $0.count = 2
      },
      Step(.send, .primeModal(.saveFavoritePrimeTapped)) {
        $0.favoritePrimes = [3, 5, 2]
      },
      Step(.send, .primeModal(.removeFavoritePrimeTapped)) {
        $0.favoritePrimes = [3, 5]
      }
    )
  }
}
