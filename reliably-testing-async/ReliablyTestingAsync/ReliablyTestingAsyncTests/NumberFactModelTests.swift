import Dependencies
import XCTest
@testable import ReliablyTestingAsync

@MainActor
final class NumberFactModelTests: XCTestCase {
  func testIncrementDecrement() {
    let model = NumberFactModel()
    model.incrementButtonTapped()
    XCTAssertEqual(model.count, 1)
    model.decrementButtonTapped()
    XCTAssertEqual(model.count, 0)
  }

  func testGetFact() async {
    let model = withDependencies {
      $0.numberFact.fact = { "\($0) is a good number." }
    } operation: {
      NumberFactModel()
    }
    await model.getFactButtonTapped()
    XCTAssertEqual(model.fact, "0 is a good number.")

    model.incrementButtonTapped()
    XCTAssertEqual(model.fact, nil)

    await model.getFactButtonTapped()
    XCTAssertEqual(model.fact, "1 is a good number.")
  }
}
