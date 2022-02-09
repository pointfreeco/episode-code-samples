import Parsing
import XCTest

final class EndTests: XCTestCase {
  func testSuccess() {
    var input = ""[...]
    XCTAssertNotNil(End().parse(&input))
    XCTAssertEqual("", input)
  }

  func testFailure() {
    var input = "Hello, world!"[...]
    XCTAssertNil(End().parse(&input))
    XCTAssertEqual("Hello, world!", input)
  }
}
