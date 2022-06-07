import Foundation

func taskBasics() throws {
  let task = Task<Int, Error>.init {
    struct SomeError: Error {}
    throw SomeError()
    return 42
  }

  @Sendable func doSomethingAsync() async {}

  Task {
    await doSomethingAsync()
  }

  func doSomethingElseAsync() async {
    await doSomethingAsync()
  }

  func doSomethingThatCanFail() throws {}

  try doSomethingThatCanFail()

  func doSomething() /*throws*/ {
    do {
      try doSomethingThatCanFail()
    } catch let error {
  //    TODO: Handle error
    }
  }

  // (A) throws -> B
  // (A) -> Result<B, Error>

  // (inout A) -> B
  // (A) -> (B, A)

  // (A) async -> B
  // (A) -> Task<B, Never>
  // (A) -> ((B) -> Void) -> Void
  // (A, (B) -> Void) -> Void

  // dataTask: (URL, completionHandler: (Data?, Response?, Error?) -> Void) -> Void
  // start: ((MKLocalSearch.Response?, Error?) -> Void) -> Void



  for n in 0..<workCount {
    Task {
      let current = Thread.current
      try await Task.sleep(nanoseconds: NSEC_PER_SEC)
      if current != Thread.current {
        print(n, "Thread changed from", current, "to", Thread.current)
      }
    }
  }
}

func taskPriority() {
  Task(priority: .low) {
    print("low")
  }
  Task(priority: .high) {
    print("high")
  }
}

func doSomething() async throws {
  try await Task.sleep(nanoseconds: NSEC_PER_SEC)
}

let task = Task {
  let start = Date()
  defer { print("Task finished in", Date().timeIntervalSince(start)) }

  let (data, _) = try await URLSession.shared.data(from: .init(string: "http://ipv4.download.thinkbroadband.com/1MB.zip")!)
  print(Thread.current, "network request finished", data.count)
}

Thread.sleep(forTimeInterval: 0.5)
task.cancel()


Thread.sleep(forTimeInterval: 5)
