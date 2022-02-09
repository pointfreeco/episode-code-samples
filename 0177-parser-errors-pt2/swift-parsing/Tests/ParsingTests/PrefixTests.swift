import Parsing
import XCTest

final class PrefixTests: XCTestCase {
  func testPrefixSuccess() {
    var input = "42 Hi!"[...]
    XCTAssertEqual("42", Prefix(2).parse(&input))
    XCTAssertEqual(" Hi!", input)
  }

  func testPrefixUnder() {
    var input = "42 Hi!"[...]
    XCTAssertEqual(nil, Prefix(8).parse(&input))
    XCTAssertEqual("42 Hi!", input)
  }

  func testPrefixOver() {
    var input = "42 Hi!"[...]
    XCTAssertEqual(nil, Prefix(10).parse(&input))
    XCTAssertEqual("42 Hi!", input)
  }

  func testPrefixWhile() {
    var input = "42 Hello, world!"[...]
    XCTAssertEqual("42", Prefix(while: { $0.isNumber }).parse(&input))
    XCTAssertEqual(" Hello, world!", input)
  }

  func testPrefixWhileAlwaysSucceeds() {
    var input = "Hello, world!"[...]
    XCTAssertEqual("", Prefix(while: { $0.isNumber }).parse(&input))
    XCTAssertEqual("Hello, world!", input)
  }

  func testPrefixRangeFromSuccess() {
    var input = "42 Hello, world!"[...]
    XCTAssertEqual("42 Hello, world!", Prefix(1...).parse(&input))
    XCTAssertEqual("", input)
  }

  func testPrefixRangeFromFailure() {
    var input = "42 Hello, world!"[...]
    XCTAssertEqual(nil, Prefix(100...).parse(&input))
    XCTAssertEqual("42 Hello, world!", input)
  }

  func testPrefixRangeFromWhileSuccess() {
    var input = "42 Hello, world!"[...]
    XCTAssertEqual("42", Prefix(1..., while: { $0.isNumber }).parse(&input))
    XCTAssertEqual(" Hello, world!", input)
  }

  func testPrefixRangeThroughSuccess() {
    var input = "42 Hello, world!"[...]
    XCTAssertEqual("42 Hello, ", Prefix(...10).parse(&input))
    XCTAssertEqual("world!", input)
  }

  func testPrefixRangeThroughWhileSuccess() {
    var input = "42 Hello, world!"[...]
    XCTAssertEqual("42", Prefix(...10, while: { $0.isNumber }).parse(&input))
    XCTAssertEqual(" Hello, world!", input)
  }

  func testPrefixLengthFromWhileSuccess() {
    var input = "42 Hello, world!"[...]
    XCTAssertEqual("4", Prefix(1, while: { $0.isNumber }).parse(&input))
    XCTAssertEqual("2 Hello, world!", input)
  }
}
