import XCTest
@testable import ReliablyTestingAsync

final class ReliablyTestingAsyncTests: XCTestCase {
  func testBasics() async throws {
    let start = Date()
    try await Task.sleep(for: .seconds(1))
    let end = Date()
    XCTAssertEqual(end.timeIntervalSince(start), 1, accuracy: 0.1)
  }

  //@MainActor
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

  func testTaskStart_MainSerialExecutor() async {
    swift_task_enqueueGlobal_hook = { job, _ in
      MainActor.shared.enqueue(job)
    }

    let values = LockIsolated([Int]())
    let task = Task {
      values.withValue { $0.append(1) }
    }
    values.withValue { $0.append(2) }
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

  func testTaskStartOrder_MainSerialExecutor() async {
    swift_task_enqueueGlobal_hook = { job, _ in
      MainActor.shared.enqueue(job)
    }

    let values = LockIsolated([Int]())
    let task1 = Task {
      values.withValue { $0.append(1) }
    }
    let task2 = Task {
      values.withValue { $0.append(2) }
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

  func testTaskGroupStartOrder_MainSerialExecutor() async {
    swift_task_enqueueGlobal_hook = { job, _ in
      MainActor.shared.enqueue(job)
    }

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

  func testYieldScheduling_MainSerialExecutor() async {
    swift_task_enqueueGlobal_hook = { job, _ in
      MainActor.shared.enqueue(job)
    }

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
  /*

   [task0, task1, task2]

   [{task0}, task1, task2]
   [0]

   [{task1}, task2, task0]
   [0, 2]

   [{task2}, task0, task1]
   [0, 2, 4]

   [{task0}, task1, task2]
   [0, 2, 4, 1]

   [{task1}, task2]
   [0, 2, 4, 1, 3]

   [{task2}]
   [0, 2, 4, 1, 3, 5]

   []
   [0, 2, 4, 1, 3, 5]
   */

  @MainActor
  func testEnqueueHook() async throws {
    swift_task_enqueueGlobal_hook = { job, _ in
      MainActor.shared.enqueue(job)
    }
    let (bytes, _) = try await URLSession.shared.bytes(from: URL(string: "https://www.google.com")!)
    for try await _ in bytes {}
  }

  func testSomething() async {
//    swift_task_enqueueGlobal_hook = { job, _ in
//      MainActor.shared.enqueue(job)
//    }
    let toggle = Toggle()
    await withTaskGroup(of: Void.self) { group in
      for _ in 1...1000 {
        group.addTask {
          toggle.isOn.toggle()
        }
      }
    }
    XCTAssertEqual(toggle.isOn, false)
  }
}

class Toggle: @unchecked Sendable {
  @ThreadSafe var isOn = false
}

@propertyWrapper
struct ThreadSafe<Value: Sendable>: Sendable {
  private let lock = NSRecursiveLock()
  private var _wrappedValue: Value

  var wrappedValue: Value {
    get { self.lock.withLock { self._wrappedValue } }
    set { self.lock.withLock { self._wrappedValue = newValue } }
  }

  init(wrappedValue: Value) {
    self._wrappedValue = wrappedValue
  }
}
