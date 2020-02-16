import XCTest
@testable import PrimeTime
import ComposableArchitecture
@testable import Counter
@testable import FavoritePrimes
@testable import PrimeModal

class PrimeTimeTests: XCTestCase {
  func testIntegration() {
    Counter.Current = .mock
    FavoritePrimes.Current = .mock
  }
}
