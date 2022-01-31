import Parsing
import XCTest

final class AlwaysTests: XCTestCase {
  func testAlways() {
    var input = "Hello, world!"[...]
    XCTAssertEqual(42, Always(42).parse(&input))
    XCTAssertEqual("Hello, world!", input)
  }

  func testMap() {
    var input = "Hello, world!"[...]
    XCTAssertEqual(43, Always(42).map { $0 + 1 }.parse(&input))
    XCTAssertEqual("Hello, world!", input)
  }
}
