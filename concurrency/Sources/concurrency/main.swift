import Foundation

func threadBasics() {
  Thread.detachNewThread {
    print("1", Thread.current)
  }
  Thread.detachNewThread {
    print("2", Thread.current)
  }
  Thread.detachNewThread {
    print("3", Thread.current)
  }
  Thread.detachNewThread {
    print("4", Thread.current)
  }
  Thread.detachNewThread {
    print("5", Thread.current)
  }
}

func threadPriorityAndCancellation() {
  let thread = Thread {
    let start = Date()
    defer { print("Finished in", Date().timeIntervalSince(start)) }
    Thread.sleep(forTimeInterval: 1)
    guard !Thread.current.isCancelled
    else {
      print("Cancelled!")
      return
    }
    print(Thread.current)
  }
  thread.threadPriority = 0.75
  thread.start()
  Thread.sleep(forTimeInterval: 0.01)
  thread.cancel()
}

func makeDatabaseQuery() {
  let requestId = Thread.current.threadDictionary["requestId"] as! UUID
  print(requestId, "Making database query")
  Thread.sleep(forTimeInterval: 0.5)
  print(requestId, "Finished database query")
}
func makeNetworkRequest() {
  let requestId = Thread.current.threadDictionary["requestId"] as! UUID
  print(requestId, "Making network request")
  Thread.sleep(forTimeInterval: 0.5)
  print(requestId, "Finished network request")
}

func response(for request: URLRequest) -> HTTPURLResponse {
  let requestId = Thread.current.threadDictionary["requestId"] as! UUID

  let start = Date()
  defer { print(requestId, "Finished in", Date().timeIntervalSince(start)) }

  makeDatabaseQuery()
  makeNetworkRequest()

  return .init()
}

for _ in 0..<10 {
  let thread = Thread {
    response(for: .init(url: .init(string: "http://pointfree.co")!))
  }
  thread.threadDictionary["requestId"] = UUID()
  thread.start()
}


Thread.sleep(forTimeInterval: 1.1)
