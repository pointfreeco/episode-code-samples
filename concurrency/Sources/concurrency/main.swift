import Foundation

func dispatchBasics() {
  let queue = DispatchQueue(label: "my.queue", attributes: .concurrent)

  //queue.async {
  //  print(Thread.current)
  //}
  //
  //queue.async { print("1", Thread.current) }
  //queue.async { print("2", Thread.current) }
  //queue.async { print("3", Thread.current) }
  //queue.async { print("4", Thread.current) }
  //queue.async { print("5", Thread.current) }

  //for n in 0..<workCount {
  //  queue.async {
  //    print(n, Thread.current)
  //  }
  //}

  print("before scheduling")
  queue.asyncAfter(deadline: .now() + 1) {
    print("1 second passed")
  }
  print("after scheduling")
}

let queue = DispatchQueue(label: "my.queue", qos: .background)

var item: DispatchWorkItem!
item = DispatchWorkItem {
  defer { item = nil }
  let start = Date()
  defer { print("Finished in", Date().timeIntervalSince(start)) }
  Thread.sleep(forTimeInterval: 1)
  guard !item.isCancelled
  else {
    print("Cancelled!")
    return
  }
  print(Thread.current)
}

queue.async(execute: item)

Thread.sleep(forTimeInterval: 0.5)
item.cancel()

Thread.sleep(forTimeInterval: 5)
