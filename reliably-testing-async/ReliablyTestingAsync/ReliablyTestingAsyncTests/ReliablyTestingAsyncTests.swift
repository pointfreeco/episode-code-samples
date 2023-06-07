import XCTest
@testable import ReliablyTestingAsync

final class ReliablyTestingAsyncTests: XCTestCase {
  func testBasics() async throws {
    let start = Date()
    try await Task.sleep(for: .seconds(1))
    let end = Date()
    XCTAssertEqual(end.timeIntervalSince(start), 1, accuracy: 0.1)
  }

  @MainActor
  func testTaskStart() async {
    let values = LockIsolated([Int]())
    let task = Task {
      values.withValue { $0.append(1) }
      print(#line, { Thread.current }())
    }
    values.withValue { $0.append(2) }
    print(#line, { Thread.current }())
    await task.value
    XCTAssertEqual(values.value, [2, 1])
  }

  func testTaskStartOrder() async {
    let values = LockIsolated([Int]())
    let task1 = Task {
      values.withValue { $0.append(1) }
      print({ Thread.current }())
    }
    let task2 = Task {
      values.withValue { $0.append(2) }
      print({ Thread.current }())
    }
    _ = await (task1.value, task2.value)
    XCTAssertEqual(values.value, [1, 2])
  }

  func testTaskGroupStartOrder() async {
    let values = await withTaskGroup(of: [Int].self) { group in
      for index in 1...100 {
        group.addTask { [index] }
      }
      return await group.reduce(into: []) { $0 += $1 }
    }
    XCTAssertEqual(values, Array(1...100))
  }

  func testYieldScheduling() async {
    let count = 10
    let values = LockIsolated<[Int]>([])
    let tasks = (0...count).map { n in
      Task {
        values.withValue { $0.append(n * 2) }
        await Task.yield()
        values.withValue { $0.append(n * 2 + 1) }
      }
    }
    for task in tasks { await task.value }

    XCTAssertEqual(
      values.value,
      Array(0...count).map { $0 * 2 }        // evens less than or equal to max
      + Array(0...count).map { $0 * 2 + 1 }  // odds less than or equal to max
    )
  }
}
