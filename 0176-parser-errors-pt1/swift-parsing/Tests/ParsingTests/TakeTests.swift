import Parsing
import XCTest

final class TakeTests: XCTestCase {
  func testTake2Success() {
    var input = "12345"[...]
    XCTAssert(try ("1", "2") == XCTUnwrap(First().take(First()).parse(&input)))
    XCTAssertEqual("345", input)
  }

  func testTake3Success() {
    var input = "12345"[...]
    XCTAssert(try ("1", "2", "3") == XCTUnwrap(First().take(First()).take(First()).parse(&input)))
    XCTAssertEqual("45", input)
  }

  func testTake4Success() {
    var input = "12345"[...]
    XCTAssert(
      try ("1", "2", "3", "4")
        == XCTUnwrap(First().take(First()).take(First()).take(First()).parse(&input)))
    XCTAssertEqual("5", input)
  }

  func testTake5Success() {
    var input = "12345"[...]
    XCTAssert(
      try ("1", "2", "3", "4", "5")
        == XCTUnwrap(First().take(First()).take(First()).take(First()).take(First()).parse(&input)))
    XCTAssertEqual("", input)
  }

  func testTake6Success() {
    var input = "123456"[...]
    let first5 = First<Substring>().take(First()).take(First()).take(First()).take(First())
    let parser = first5.take(First())
    XCTAssert(
      try ("1", "2", "3", "4", "5", "6")
        == XCTUnwrap(parser.parse(&input)))
    XCTAssertEqual("", input)
  }

  func testTake7Success() {
    var input = "1234567"[...]
    let first5 = First<Substring>().take(First()).take(First()).take(First()).take(First())
    let parser = first5.take(First()).take(First())
    XCTAssert(
      try ("1", "2", "3", "4", "5", "6", "7")
        == XCTUnwrap(parser.parse(&input)))
    XCTAssertEqual("", input)
  }

  func testTake8Success() {
    var input = "12345678"[...]
    let first5 = First<Substring>().take(First()).take(First()).take(First()).take(First())
    let parser = first5.take(First()).take(First()).take(First())
    XCTAssert(
      try ("1", "2", "3", "4", "5", "6", "7", "8")
        == XCTUnwrap(parser.parse(&input)))
    XCTAssertEqual("", input)
  }

  func testTake9Success() {
    var input = "123456789"[...]
    let first5 = First<Substring>().take(First()).take(First()).take(First()).take(First())
    let parser = first5.take(First()).take(First()).take(First()).take(First())
    XCTAssert(
      try ("1", "2", "3", "4", "5", "6", "7", "8", "9")
        == XCTUnwrap(parser.parse(&input)))
    XCTAssertEqual("", input)
  }

  func testTake10Success() {
    var input = "1234567890"[...]
    let first5 = First<Substring>().take(First()).take(First()).take(First()).take(First())
    let parser = first5.take(First()).take(First()).take(First()).take(First()).take(First())
    XCTAssert(
      try ("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
        == XCTUnwrap(parser.parse(&input)))
    XCTAssertEqual("", input)
  }

  func testTake11Success() {
    var input = "1234567890A"[...]
    let first5 = First<Substring>().take(First()).take(First()).take(First()).take(First())
    let first10 = first5.take(First()).take(First()).take(First()).take(First()).take(First())
    let parser = first10.take(First())
    XCTAssert(
      try ("1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "A")
        == XCTUnwrap(parser.parse(&input)))
    XCTAssertEqual("", input)
  }
}

// MARK: - Tuple Equatable Conformance

func == <A, B, C, D, E, F, G>(lhs: (A, B, C, D, E, F, G), rhs: (A, B, C, D, E, F, G)) -> Bool
where
  A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable, G: Equatable
{
  (lhs.0, lhs.1, lhs.2, lhs.3, lhs.4, lhs.5) == (rhs.0, rhs.1, rhs.2, rhs.3, rhs.4, rhs.5)
    && lhs.6 == rhs.6
}

func == <A, B, C, D, E, F, G, H>(lhs: (A, B, C, D, E, F, G, H), rhs: (A, B, C, D, E, F, G, H))
  -> Bool
where
  A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable, G: Equatable,
  H: Equatable
{
  (lhs.0, lhs.1, lhs.2, lhs.3, lhs.4, lhs.5) == (rhs.0, rhs.1, rhs.2, rhs.3, rhs.4, rhs.5)
    && (lhs.6, lhs.7) == (rhs.6, rhs.7)
}

func == <A, B, C, D, E, F, G, H, I>(
  lhs: (A, B, C, D, E, F, G, H, I), rhs: (A, B, C, D, E, F, G, H, I)
) -> Bool
where
  A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable, G: Equatable,
  H: Equatable, I: Equatable
{
  (lhs.0, lhs.1, lhs.2, lhs.3, lhs.4, lhs.5) == (rhs.0, rhs.1, rhs.2, rhs.3, rhs.4, rhs.5)
    && (lhs.6, lhs.7, lhs.8) == (rhs.6, rhs.7, rhs.8)
}

func == <A, B, C, D, E, F, G, H, I, J>(
  lhs: (A, B, C, D, E, F, G, H, I, J), rhs: (A, B, C, D, E, F, G, H, I, J)
) -> Bool
where
  A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable, G: Equatable,
  H: Equatable, I: Equatable, J: Equatable
{
  (lhs.0, lhs.1, lhs.2, lhs.3, lhs.4, lhs.5) == (rhs.0, rhs.1, rhs.2, rhs.3, rhs.4, rhs.5)
    && (lhs.6, lhs.7, lhs.8, lhs.9) == (rhs.6, rhs.7, rhs.8, rhs.9)
}

func == <A, B, C, D, E, F, G, H, I, J, K>(
  lhs: (A, B, C, D, E, F, G, H, I, J, K), rhs: (A, B, C, D, E, F, G, H, I, J, K)
) -> Bool
where
  A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable, G: Equatable,
  H: Equatable, I: Equatable, J: Equatable, K: Equatable
{
  (lhs.0, lhs.1, lhs.2, lhs.3, lhs.4, lhs.5) == (rhs.0, rhs.1, rhs.2, rhs.3, rhs.4, rhs.5)
    && (lhs.6, lhs.7, lhs.8, lhs.9, lhs.10) == (rhs.6, rhs.7, rhs.8, rhs.9, lhs.10)
}
