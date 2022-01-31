import Parsing
import XCTest

final class FromSubstringTests: XCTestCase {
  func testUTF8View() {
    let p = Parse {
      "caf".utf8
      FromSubstring { "é" }
    }

    var input = "caf\u{00E9}"[...].utf8
    XCTAssertNotNil(p.parse(&input))
    XCTAssert(input.isEmpty)

    input = "cafe\u{0301}"[...].utf8
    XCTAssertNotNil(p.parse(&input))
    XCTAssert(input.isEmpty)
  }

  func testUnicodeScalarView() {
    let p = Parse {
      "caf".unicodeScalars
      FromSubstring { "é" }
    }

    var input = "caf\u{00E9}"[...].unicodeScalars
    XCTAssertNotNil(p.parse(&input))
    XCTAssert(input.isEmpty)

    input = "cafe\u{0301}"[...].unicodeScalars
    XCTAssertNotNil(p.parse(&input))
    XCTAssert(input.isEmpty)
  }
}
