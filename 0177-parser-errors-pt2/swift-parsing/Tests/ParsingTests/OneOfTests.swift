import Parsing
import XCTest

final class OneOfTests: XCTestCase {
  func testOneOfFirstSuccess() {
    var input = "New York, Hello!"[...]
    XCTAssertNotNil(
      OneOf {
        "New York"
        "Berlin"
      }
      .parse(&input)
    )
    XCTAssertEqual(", Hello!", Substring(input))
  }

  func testOneOfSecondSuccess() {
    var input = "Berlin, Hello!"[...]
    XCTAssertNotNil(
      OneOf {
        "New York"
        "Berlin"
      }
      .parse(&input)
    )
    XCTAssertEqual(", Hello!", Substring(input))
  }

  func testOneOfFailure() {
    var input = "London, Hello!"[...]
    XCTAssertNil(
      OneOf {
        "New York"
        "Berlin"
      }
      .parse(&input))
    XCTAssertEqual("London, Hello!", Substring(input))
  }

  func testOneOfManyFirstSuccess() {
    var input = "New York, Hello!"[...]
    XCTAssertNotNil(
      OneOf {
        for city in ["New York", "Berlin"] {
          city
        }
      }
      .parse(&input)
    )
    XCTAssertEqual(", Hello!", Substring(input))
  }

  func testOneOfManyLastSuccess() {
    var input = "Berlin, Hello!"[...]
    XCTAssertNotNil(
      OneOf {
        for city in ["New York", "Berlin"] {
          city
        }
      }
      .parse(&input)
    )
    XCTAssertEqual(", Hello!", Substring(input))
  }

  func testOneOfManyFailure() {
    var input = "London, Hello!"[...]
    XCTAssertNil(
      OneOf {
        "New York"
        "Berlin"
      }
      .parse(&input)
    )
    XCTAssertEqual("London, Hello!", Substring(input))
  }
}
