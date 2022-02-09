import Parsing
import XCTest

final class NewlineTests: XCTestCase {
  func testSuccess() {
    var input = "\n\r\n\n\rHello, world!"[...].utf8
    XCTAssertNotNil(Newline().parse(&input))
    XCTAssertEqual("\r\n\n\rHello, world!", Substring(input))
    XCTAssertNotNil(Newline().parse(&input))
    XCTAssertEqual("\n\rHello, world!", Substring(input))
    XCTAssertNotNil(Newline().parse(&input))
    XCTAssertEqual("\rHello, world!", Substring(input))
    XCTAssertNil(Newline().parse(&input))
    XCTAssertEqual("\rHello, world!", Substring(input))
  }

  func testAlwaysSucceeds() {
    var input = "Hello, world!"[...].utf8
    XCTAssertNil(Newline().parse(&input))
    XCTAssertEqual("Hello, world!", Substring(input))
  }
}
