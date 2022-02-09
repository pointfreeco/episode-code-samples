import Parsing
import XCTest

final class UUIDTests: XCTestCase {
  func testUUID() {
    let parser = UUID.parser(of: Substring.UTF8View.self)

    var input = "deadbeef-dead-beef-dead-beefdeadbeef Hello"[...].utf8
    XCTAssertEqual(UUID(uuidString: "deadbeef-dead-beef-dead-beefdeadbeef"), parser.parse(&input))
    XCTAssertEqual(" Hello", String(input))

    input = "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF Hello"[...].utf8
    XCTAssertEqual(UUID(uuidString: "deadbeef-dead-beef-dead-beefdeadbeef"), parser.parse(&input))
    XCTAssertEqual(" Hello", String(input))

    input = "DADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF Hello"[...].utf8
    XCTAssertEqual(nil, parser.parse(&input))
    XCTAssertEqual("DADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF Hello", String(input))
  }
}
