import Parsing
import XCTest

final class FirstTests: XCTestCase {
  func testSuccess() {
    var input = "Hello, world!"[...]
    XCTAssertEqual("H", First().parse(&input))
    XCTAssertEqual("ello, world!", input)
  }

  func testFailure() {
    var input = ""[...]
    XCTAssertEqual(nil, First().parse(&input))
    XCTAssertEqual("", input)
  }
}
