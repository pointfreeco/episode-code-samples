import Parsing
import XCTest

final class PrefixThroughTests: XCTestCase {
  func testSuccess() {
    var input = "Hello,world, 42!"[...]
    XCTAssertEqual("Hello,world, ", PrefixThrough(", ").parse(&input))
    XCTAssertEqual("42!", input)
  }

  func testSuccessIsEmpty() {
    var input = "Hello, world!"[...]
    XCTAssertEqual("", PrefixThrough("").parse(&input))
    XCTAssertEqual("Hello, world!", input)
  }

  func testFailureIsEmpty() {
    var input = ""[...]
    XCTAssertEqual(nil, PrefixThrough(", ").parse(&input))
    XCTAssertEqual("", input)
  }

  func testFailureNoMatch() {
    var input = "Hello world!"[...]
    XCTAssertEqual(nil, PrefixThrough(", ").parse(&input))
    XCTAssertEqual("Hello world!", input)
  }

  func testUTF8() {
    var input = "Hello,world, 42!"[...].utf8
    XCTAssertEqual("Hello,world, ", PrefixThrough(", ".utf8).parse(&input).map(Substring.init))
    XCTAssertEqual("42!", Substring(input))
  }
}
