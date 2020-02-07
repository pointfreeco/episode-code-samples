import XCTest
@testable import Counter
import SnapshotTesting
import ComposableArchitecture
import SwiftUI


extension Snapshotting where Value: UIViewController, Format == UIImage {
  static var windowedImage: Snapshotting {
    return Snapshotting<UIImage, UIImage>.image.asyncPullback { vc in
      Async<UIImage> { callback in
        UIView.setAnimationsEnabled(false)
        let window = UIApplication.shared.windows.first!
        window.rootViewController = vc
        DispatchQueue.main.async {
          let image = UIGraphicsImageRenderer(bounds: window.bounds).image { ctx in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
          }
          callback(image)
          UIView.setAnimationsEnabled(true)
        }
      }
    }
  }
}


class CounterTests: XCTestCase {
  override func setUp() {
    super.setUp()
    Current = .mock
  }

  func testSnapshots() {
    let store = Store(initialValue: CounterViewState(), reducer: counterViewReducer)
    let view = CounterView(store: store)

    let vc = UIHostingController(rootView: view)
    vc.view.frame = UIScreen.main.bounds

    diffTool = "ksdiff"
//    record=true
    assertSnapshot(matching: vc, as: .windowedImage)

    store.send(.counter(.incrTapped))
    assertSnapshot(matching: vc, as: .windowedImage)

    store.send(.counter(.incrTapped))
    assertSnapshot(matching: vc, as: .windowedImage)

    store.send(.counter(.nthPrimeButtonTapped))
    assertSnapshot(matching: vc, as: .windowedImage)

    var expectation = self.expectation(description: "wait")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 0.5)
    assertSnapshot(matching: vc, as: .windowedImage)

    store.send(.counter(.alertDismissButtonTapped))
    expectation = self.expectation(description: "wait")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 0.5)
    assertSnapshot(matching: vc, as: .windowedImage)

    store.send(.counter(.isPrimeButtonTapped))
    assertSnapshot(matching: vc, as: .windowedImage)

    store.send(.primeModal(.saveFavoritePrimeTapped))
    assertSnapshot(matching: vc, as: .windowedImage)

    store.send(.counter(.primeModalDismissed))
    assertSnapshot(matching: vc, as: .windowedImage)
  }

  func testIncrDecrButtonTapped() {
    assert(
      initialValue: CounterViewState(count: 2),
      reducer: counterViewReducer,
      steps:
      Step(.send, .counter(.incrTapped)) { $0.count = 3 },
      Step(.send, .counter(.incrTapped)) { $0.count = 4 },
      Step(.send, .counter(.decrTapped)) { $0.count = 3 }
    )
  }

  func testNthPrimeButtonHappyFlow() {
    Current.nthPrime = { _ in .sync { 17 } }

    assert(
      initialValue: CounterViewState(
        alertNthPrime: nil,
        isNthPrimeButtonDisabled: false
      ),
      reducer: counterViewReducer,
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
    Current.nthPrime = { _ in .sync { nil } }

    assert(
      initialValue: CounterViewState(
        alertNthPrime: nil,
        isNthPrimeButtonDisabled: false
      ),
      reducer: counterViewReducer,
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
