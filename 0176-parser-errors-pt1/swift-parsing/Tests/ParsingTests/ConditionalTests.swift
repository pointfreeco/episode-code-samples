import Parsing
import XCTest

final class ConditionalTests: XCTestCase {
  let parser = Int.parser()
    .flatMap { n in
      if n.isMultiple(of: 2) {
        Always(true)
      } else {
        Fail<Substring, Bool>()
      }
    }

  func testFirst() {
    var input = "42 Hello, world!"[...]
    XCTAssertEqual(true, parser.parse(&input))
    XCTAssertEqual(" Hello, world!", input)
  }

  func testSecond() {
    var input = "43 Hello, world!"[...]
    XCTAssertEqual(nil, parser.parse(&input))
    XCTAssertEqual("43 Hello, world!", input)
  }
}
