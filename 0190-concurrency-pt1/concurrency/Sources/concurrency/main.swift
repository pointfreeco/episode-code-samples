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
    Thread.detachNewThread {
      print("Inner thread cancelled?", Thread.current.isCancelled)
    }
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

func threadStorageAndCoordination() {
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

    let databaseQueryThread = Thread { makeDatabaseQuery() }
    databaseQueryThread.threadDictionary.addEntries(from: Thread.current.threadDictionary as! [AnyHashable: Any])
    databaseQueryThread.start()
    let networkRequestThread = Thread { makeNetworkRequest() }
    networkRequestThread.threadDictionary.addEntries(from: Thread.current.threadDictionary as! [AnyHashable: Any])
    networkRequestThread.start()

    while !databaseQueryThread.isFinished || !networkRequestThread.isFinished {
      Thread.sleep(forTimeInterval: 0.1)
    }

    return .init()
  }

  //for _ in 0..<10 {
    let thread = Thread {
      response(for: .init(url: .init(string: "http://pointfree.co")!))
    }
    thread.threadDictionary["requestId"] = UUID()
    thread.start()
  //}
}

let workCount = 1_000

func threadPerformance() {
  func isPrime(_ p: Int) -> Bool {
    if p <= 1 { return false }
    if p <= 3 { return true }
    for i in 2...Int(sqrtf(Float(p))) {
      if p % i == 0 { return false }
    }
    return true
  }
  func nthPrime(_ n: Int) {
    let start = Date()
    var primeCount = 0
    var prime = 2
    while primeCount < n {
      defer { prime += 1 }
      if isPrime(prime) {
        primeCount += 1
      }
    }
    print(
      "\(n)th prime", prime-1,
      "time", Date().timeIntervalSince(start)
    )
  }

  for n in 0..<workCount {
    Thread.detachNewThread {
      while true {}
    }
  }

  Thread.detachNewThread {
    print("Starting the prime thread")
    nthPrime(50_000)
  }
}

class Counter {
  let lock = NSLock()
  var count = 0
//  var count: Int {
//    get {
//      self.lock.lock()
//      defer { self.lock.unlock() }
//      return self._count
//    }
//    set {
//      self.lock.lock()
//      defer { self.lock.unlock() }
//      self._count = newValue
//    }
//    _read {
//      self.lock.lock()
//      defer { self.lock.unlock() }
//      yield self._count
//    }
//    _modify {
//      self.lock.lock()
//      defer { self.lock.unlock() }
//      yield &self._count
//    }
//  }

  func increment() {
    self.lock.lock()
    defer { self.lock.unlock() }
    self.count += 1
  }
  func modify(work: (Counter) -> Void) {
    self.lock.lock()
    defer { self.lock.unlock() }
    work(self)
  }
}
let counter = Counter()


for _ in 0..<1_000 {
  Thread.detachNewThread {
    Thread.sleep(forTimeInterval: 0.01)
    counter.modify { $0.count += 1 + $0.count/100 }

//    lock.lock()
//    let count = counter.count
//    lock.unlock()
//    lock.lock()
//    counter.count += 1 + count/100
//    lock.unlock()

//    var count1 = counter.count
//    var count2 = counter.count
//    count1 += 1
//    count2 += 1
//    counter.count = count1
//    counter.count = count2
//    counter.increment()
//    counter.modify { $0.count += 1 }
  }
}
Thread.sleep(forTimeInterval: 2)
print("count", counter.count)

Thread.sleep(forTimeInterval: 5)
