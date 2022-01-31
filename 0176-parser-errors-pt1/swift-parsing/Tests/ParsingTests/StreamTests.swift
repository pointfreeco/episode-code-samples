import Parsing
import XCTest

final class StreamTests: XCTestCase {
  func testBasics() throws {
    var stream = AnyIterator(
      sequence(state: 0) { state -> ArraySlice<UInt8>? in
        state += 1
        return state <= 20 ? ArraySlice("\(state)\n".utf8) : nil
      }
    )

    let output = try XCTUnwrap(
      Stream {
        Int.parser(of: ArraySlice<UInt8>.self)
        Array("\n".utf8)
      }
      .parse(&stream)
    )

    XCTAssertEqual(Array(output), Array(1...20))
  }
}
