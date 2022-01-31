import Parsing
import XCTest

final class UTF8Tests: XCTestCase {
  func testSubstringNormalization() {
    var input = "\u{00E9}e\u{0301}e\u{0341} Hello, world"[...].utf8
    let parser = FromSubstring<Substring.UTF8View, String> { "é" }
    XCTAssertNotNil(parser.parse(&input))
    XCTAssertEqual("e\u{0301}e\u{0341} Hello, world", Substring(input))
    XCTAssertNotNil(parser.parse(&input))
    XCTAssertEqual("e\u{0341} Hello, world", Substring(input))
    XCTAssertNotNil(parser.parse(&input))
    XCTAssertEqual(" Hello, world", Substring(input))
    XCTAssertNil(parser.parse(&input))
    XCTAssertEqual(" Hello, world", Substring(input))
  }

  func testUnicodeScalars() {
    var input = "🇺🇸 Hello, world"[...].unicodeScalars
    let parser = StartsWith<Substring.UnicodeScalarView>("🇺".unicodeScalars)
    XCTAssertNotNil(parser.parse(&input))
    XCTAssertEqual("🇸 Hello, world", Substring(input))
    XCTAssertNil(parser.parse(&input))
    XCTAssertEqual("🇸 Hello, world", Substring(input))
  }
}
