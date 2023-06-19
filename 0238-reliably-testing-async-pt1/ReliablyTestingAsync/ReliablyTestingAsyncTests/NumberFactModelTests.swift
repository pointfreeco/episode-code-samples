import Dependencies
import XCTest
@testable import ReliablyTestingAsync

@MainActor
final class NumberFactModelTests: XCTestCase {
  func testIncrementDecrement() {
    let model = NumberFactModel()
    model.incrementButtonTapped()
    XCTAssertEqual(model.count, 1)
    model.decrementButtonTapped()
    XCTAssertEqual(model.count, 0)
  }

  func testGetFact() async {
    let model = withDependencies {
      $0.numberFact.fact = { "\($0) is a good number." }
    } operation: {
      NumberFactModel()
    }
    await model.getFactButtonTapped()
    XCTAssertEqual(model.fact, "0 is a good number.")

    model.incrementButtonTapped()
    XCTAssertEqual(model.fact, nil)

    await model.getFactButtonTapped()
    XCTAssertEqual(model.fact, "1 is a good number.")
  }

  func testFactClearsOut() async {
    let fact = AsyncStream.makeStream(of: String.self)

    let model = withDependencies {
      $0.numberFact.fact = { _ in
        await fact.stream.first(where: { _ in true })!
      }
    } operation: {
      NumberFactModel()
    }
    model.fact = "An old fact about 0."

    let task = Task { await model.getFactButtonTapped() }
    await Task.yield()
    XCTAssertEqual(model.fact, nil)
    fact.continuation.yield("0 is a good number.")
    await task.value
    XCTAssertEqual(model.fact, "0 is a good number.")
  }

  func testFactIsLoading() async {
    let fact = AsyncStream.makeStream(of: String.self)

    let model = withDependencies {
      $0.numberFact.fact = { _ in
        await fact.stream.first(where: { _ in true })!
      }
    } operation: {
      NumberFactModel()
    }
    model.fact = "An old fact about 0."

    let task = Task { await model.getFactButtonTapped() }
    await Task.yield()
    XCTAssertEqual(model.isLoading, true)
    fact.continuation.yield("0 is a good number.")
    await task.value
    XCTAssertEqual(model.fact, "0 is a good number.")
    XCTAssertEqual(model.isLoading, false)
  }
}
