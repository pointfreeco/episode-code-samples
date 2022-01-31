import Parsing
import XCTest

final class CompactMapTests: XCTestCase {
  func testSuccess() {
    var input = "FF0000"[...]
    XCTAssertEqual(
      0xFF,
      Prefix(2).compactMap { Int(String($0), radix: 16) }.parse(&input)
    )
    XCTAssertEqual("0000", Substring(input))
  }

  func testFailure() {
    var input = "ERRORS"[...]
    XCTAssertEqual(
      nil,
      Prefix(2).compactMap { Int(String($0), radix: 16) }.parse(&input)
    )
    XCTAssertEqual("ERRORS", Substring(input))
  }

  func testOverloadArray() {
    let array = [1].compactMap { "\($0)" }
    XCTAssert(type(of: array) == Array<String>.self)
  }

  func testOverloadString() {
    let array = "abc".compactMap { "\($0)" }
    XCTAssert(type(of: array) == Array<String>.self)
  }

  func testOverloadUnicodeScalars() {
    let array = "abc".unicodeScalars.compactMap { "\($0)" }
    XCTAssert(type(of: array) == Array<String>.self)
  }

  func testOverloadUTF8View() {
    let array = "abc".utf8.compactMap { "\($0)" }
    XCTAssert(type(of: array) == Array<String>.self)
  }
}
