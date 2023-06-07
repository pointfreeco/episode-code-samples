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
  
  func testBackToBackGetFact() async throws {
    let fact0 = AsyncStream.makeStream(of: String.self)
    let fact1 = AsyncStream.makeStream(of: String.self)
    let callCount = LockIsolated(0)
    
    let model = withDependencies {
      $0.numberFact.fact = { number in
        callCount.withValue { $0 += 1 }
        if callCount.value == 1 {
          return await fact0.stream.first(where: { _ in true }) ?? ""
        } else if callCount.value == 2 {
          return await fact1.stream.first(where: { _ in true }) ?? ""
        } else {
          fatalError()
        }
      }
    } operation: {
      NumberFactModel()
    }
    
    let task0 = Task { await model.getFactButtonTapped() }
    let task1 = Task { await model.getFactButtonTapped() }
    await Task.yield()
    fact1.continuation.yield("0 is a great number.")
    try await Task.sleep(for: .milliseconds(100))
    fact0.continuation.yield("0 is a better number.")
    await task0.value
    await task1.value
    XCTAssertEqual(model.fact, "0 is a great number.")
  }

  func testCancel() async {
    let model = withDependencies {
      $0.numberFact.fact = { _ in try await Task.never() }
    } operation: {
      NumberFactModel()
    }
    let task = Task { await model.getFactButtonTapped() }
    await Task.megaYield()
    model.cancelButtonTapped()
    await task.value
    XCTAssertEqual(model.fact, nil)
  }
}

extension Task where Success == Never, Failure == Never {
  static func megaYield() async {
    for _ in 1...20 {
      await Task<Void, Never>.detached(priority: .background) {
        await Task<Never, Never>.yield()
      }.value
    }
  }
}
