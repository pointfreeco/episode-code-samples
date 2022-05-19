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

Thread.sleep(forTimeInterval: 1.1)
