//import Parsing
//import XCTest
//
//final class BoolTests: XCTestCase {
//  func testParsesTrue() {
//    var input = "true Hello, world!"[...].utf8
//    XCTAssertEqual(true, Bool.parser().parse(&input))
//    XCTAssertEqual(" Hello, world!", Substring(input))
//  }
//
//  func testParsesFalse() {
//    var input = "false Hello, world!"[...].utf8
//    XCTAssertEqual(false, Bool.parser().parse(&input))
//    XCTAssertEqual(" Hello, world!", Substring(input))
//  }
//
//  func testParseFailure() {
//    var input = "Hello, world!"[...].utf8
//    XCTAssertEqual(nil, Bool.parser().parse(&input))
//    XCTAssertEqual("Hello, world!", Substring(input))
//  }
//}
