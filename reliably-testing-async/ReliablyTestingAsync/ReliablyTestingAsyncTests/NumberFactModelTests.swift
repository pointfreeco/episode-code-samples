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
  
  func testFactClearsOut_MainSerialExecutor() async {
    swift_task_enqueueGlobal_hook = { job, _ in
      MainActor.shared.enqueue(job)
    }
    
    let model = withDependencies {
      $0.numberFact.fact = { "\($0) is a good number." }
    } operation: {
      NumberFactModel()
    }
    model.fact = "An old fact about 0."
    
    let task = Task { await model.getFactButtonTapped() }
    await Task.yield()
    XCTAssertEqual(model.fact, nil)
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
  
  func testFactIsLoading_MainSerialExecutor() async {
    swift_task_enqueueGlobal_hook = { job, _ in
      MainActor.shared.enqueue(job)
    }
    
    let model = withDependencies {
      $0.numberFact.fact = { "\($0) is a good number." }
    } operation: {
      NumberFactModel()
    }
    model.fact = "An old fact about 0."
    
    let task = Task { await model.getFactButtonTapped() }
    await Task.yield()
    XCTAssertEqual(model.isLoading, true)
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
  
  func testBackToBackGetFact_MainSerialExecutor() async throws {
    swift_task_enqueueGlobal_hook = { job, _ in
      MainActor.shared.enqueue(job)
    }
    
    let callCount = LockIsolated(0)
    
    let model = withDependencies {
      $0.numberFact.fact = { number in
        callCount.withValue { $0 += 1 }
        if callCount.value == 1 {
          return "0 is a better number."
        } else if callCount.value == 2 {
          return "0 is a great number."
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
  
  func testCancel_MainSerialExecutor() async {
    swift_task_enqueueGlobal_hook = { job, _ in
      MainActor.shared.enqueue(job)
    }
    
    let model = withDependencies {
      $0.numberFact.fact = {
        await Task.yield()
        try Task.checkCancellation()
        return "\($0) is a good number."
      }
    } operation: {
      NumberFactModel()
    }
    let task = Task { await model.getFactButtonTapped() }
    await Task.yield()
    model.cancelButtonTapped()
    await task.value
    XCTAssertEqual(model.fact, nil)
  }
  
  
  func testScreenshots() async {
    let model = NumberFactModel()
    
    let task = Task { await model.onTask() }
    
    await Task.megaYield()
    NotificationCenter.default.post(name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    while model.count != 1 {
      await Task.yield()
    }
    XCTAssertEqual(model.count, 1)
    
    NotificationCenter.default.post(name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    while model.count != 2 {
      await Task.yield()
    }
    XCTAssertEqual(model.count, 2)
  }

  func testScreenshots_MainSerialExecutor() async {
    swift_task_enqueueGlobal_hook = { job, _ in
      MainActor.shared.enqueue(job)
    }

    let model = NumberFactModel()

    let task = Task { await model.onTask() }
    await Task.yield()
    NotificationCenter.default.post(name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    await Task.yield()
    XCTAssertEqual(model.count, 1)

    NotificationCenter.default.post(name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    await Task.yield()
    XCTAssertEqual(model.count, 2)
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
