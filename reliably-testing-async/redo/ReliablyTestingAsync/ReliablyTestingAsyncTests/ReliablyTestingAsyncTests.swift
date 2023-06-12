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
    }
    values.withValue { $0.append(2) }
    await task.value
    XCTAssertEqual(values.value, [2, 1])
  }

  @MainActor
  func testTaskStartOrder() async {
    let values = LockIsolated<[Int]>([])
    let task1 = Task { values.withValue { $0.append(1) } }
    let task2 = Task { values.withValue { $0.append(2) } }
    _ = await (task1.value, task2.value)
    XCTAssertEqual(values.value, [1, 2])
  }

  func testTaskGroupStartOrder() async {
    let values = await withTaskGroup(of: [Int].self) { group in
      for n in 1...100 {
        group.addTask { [n] }
      }
      return await group.reduce(into: [], +=)
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
    XCTAssertEqual(values.value, [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21])
  }
}
