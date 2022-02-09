import Parsing
import XCTest

final class LazyTests: XCTestCase {
  func testBasics() {
    var input = "123 Hello"[...]

    var evaluated = 0
    let parser = Lazy<Always<Substring, Void>> {
      evaluated += 1
      return Always(())
    }

    XCTAssertEqual(0, evaluated, "has not evaluated")
    XCTAssertNotNil(parser.parse(&input))
    XCTAssertEqual(1, evaluated, "evaluated")
    XCTAssertNotNil(parser.parse(&input))
    XCTAssertEqual(1, evaluated, "did not re-evaluate")
  }
}
