import Parsing
import XCTest

final class OneOfBuilderTests: XCTestCase {
  func testBuildArray() {
    enum Role: String, CaseIterable, Equatable {
      case admin
      case guest
      case member
    }

    let parser = OneOf {
      for role in Role.allCases {
        role.rawValue.map { role }
      }
    }

    for role in Role.allCases {
      XCTAssertEqual(role, parser.parse(role.rawValue))
    }
    XCTAssertNil(parser.parse("president"))
  }

  func testBuildIf() {
    enum Role {
      case admin
      case guest
      case member
    }

    var parseAdmins = false
    var parser = OneOf {
      if parseAdmins {
        "admin".map { Role.admin }
      }

      "guest".map { Role.guest }
      "member".map { Role.member }
    }

    XCTAssertEqual(.guest, parser.parse("guest"))
    XCTAssertEqual(nil, parser.parse("admin"))

    parseAdmins = true
    parser = OneOf {
      if parseAdmins {
        "admin".map { Role.admin }
      }

      "guest".map { Role.guest }
      "member".map { Role.member }
    }
    XCTAssertEqual(.guest, parser.parse("guest"))
    XCTAssertEqual(.admin, parser.parse("admin"))
  }
}
