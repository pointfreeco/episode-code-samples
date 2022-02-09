import Parsing
import XCTest

final class RestTests: XCTestCase {
  func testRest() {
    var input = "Hello, world!"[...]
    XCTAssertEqual("Hello, world!", Rest().parse(&input))
    XCTAssertEqual("", input)
  }

  func testRestAlwaysSucceeds() {
    var input = ""[...]
    XCTAssertEqual("", Rest().parse(&input))
    XCTAssertEqual("", input)
  }
}
