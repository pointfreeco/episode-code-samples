import XCTest
@testable import PrimeTime
@testable import Counter
@testable import FavoritePrimes

class PrimeTimeTests: XCTestCase {
  func testIntegration() {
    Counter.Current = .mock
    FavoritePrimes.Current = .mock
  }
}
