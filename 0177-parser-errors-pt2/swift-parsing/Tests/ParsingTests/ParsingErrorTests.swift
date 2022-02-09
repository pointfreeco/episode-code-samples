import Parsing
import XCTest

class ParsingErrorTests: XCTestCase {
  func testBasics() throws {
    var input = "World"[...]
    try "Hello".parse(&input)
  }

  func testIntParser() throws {
    var input = "World"[...]
    _ = try Int.parser().parse(&input) as Int
  }

  func testIntParserOverflow() throws {
    var input = "256"[...]
    _ = try UInt8.parser().parse(&input) as UInt8
  }

  func testUserParser() throws {
    enum Role {
      case guest, member, admin
    }
    struct User {
      var id: Int
      var name: String
      var role: Role
    }
    let role = OneOf {
      "guest".map { Role.guest }
      "member".map { Role.member }
      "admin".map { Role.admin }
    }
    let user = Parse(User.init) {
      Int.parser()
      ","
      Prefix { $0 != "," }.map(String.init)
      ","
      role
      End()
    }

    var input = """
      1,Blob,true
      2,Blob Jr,false
      3,Blob Sr,true
      """[...]
    _ = try user.parse(&input) as User
  }

  func testUsersParser() throws {
    enum Role {
      case guest, member, admin
    }
    struct User {
      var id: Int
      var name: String
      var role: Role
    }
    let role = OneOf {
      "guest".map { Role.guest }
      "member".map { Role.member }
      "admin".map { Role.admin }
    }
    let user = Parse(User.init) {
      Int.parser()
      ","
      Prefix { $0 != "," }.map(String.init)
      ","
      role
    }
    let users = Many {
      user
    } separator: {
      "\n"
    } terminator: {
      End()
    }

    var input = """
      1,Blob,member
      2,Blob Jr,guest
      3,Blob Sr,admin
      """[...]
    let usersArray = try users.parse(&input) as [User]

    XCTAssertEqual(usersArray.count, 3)
    XCTAssertEqual(input, "")
  }
}
