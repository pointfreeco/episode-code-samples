import Parsing
import XCTest

final class FlatMapTests: XCTestCase {
  func testSuccess() {
    var input = "42 Hello, world!"[...].utf8
    XCTAssertEqual(43, Int.parser().flatMap { Always($0 + 1) }.parse(&input))
    XCTAssertEqual(" Hello, world!", Substring(input))

    input = "42 Hello, world!"[...].utf8
    XCTAssertEqual(43, Int.parser().flatMap { return Always($0 + 1) }.parse(&input))
    XCTAssertEqual(" Hello, world!", Substring(input))
  }

  func testFailure() {
    var input = "Hello, world!"[...].utf8
    XCTAssertEqual(nil, Int.parser().flatMap { Always($0 + 1) }.parse(&input))
    XCTAssertEqual("Hello, world!", Substring(input))
  }
}
