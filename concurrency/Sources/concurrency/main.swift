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

func dispatchPriorityAndCancellation() {
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
}

func makeDatabaseQuery() {
  let requestId = DispatchQueue.getSpecific(key: requestIdKey)!
  print(requestId, "Making database query")
  Thread.sleep(forTimeInterval: 0.5)
  print(requestId, "Finished database query")
}

func makeNetworkRequest() {
  let requestId = DispatchQueue.getSpecific(key: requestIdKey)!
  print(requestId, "Making network request")
  Thread.sleep(forTimeInterval: 0.5)
  print(requestId, "Finished network request")
}


func response(for request: URLRequest, queue: DispatchQueue) -> HTTPURLResponse {
  let requestId = DispatchQueue.getSpecific(key: requestIdKey)!

  let start = Date()
  defer { print(requestId, "Finished in", Date().timeIntervalSince(start)) }

  let group = DispatchGroup()

  let databaseQueue = DispatchQueue(label: "database-query", target: queue)
  databaseQueue.async(group: group) {
    makeDatabaseQuery()
  }

  let networkQueue = DispatchQueue(label: "network-request", target: queue)
  networkQueue.async(group: group) {
    makeNetworkRequest()
  }

  group.wait()

  // TODO: return real response
  return .init()
}

let serverQueue = DispatchQueue(label: "server-queue", attributes: .concurrent)


let requestIdKey = DispatchSpecificKey<UUID>()
let requestId = UUID()
let requestQueue = DispatchQueue(label: "request-\(requestId)", attributes: .concurrent, target: serverQueue)
requestQueue.setSpecific(key: requestIdKey, value: requestId)

let item = DispatchWorkItem {
  response(for: .init(url: .init(string: "http://pointfree.co")!), queue: requestQueue)
}
requestQueue.async(execute: item)


let queue1 = DispatchQueue(label: "queue1")
let idKey = DispatchSpecificKey<Int>()
let dateKey = DispatchSpecificKey<Date>()
queue1.setSpecific(key: idKey, value: 42)
queue1.setSpecific(key: dateKey, value: Date())

queue1.async {
  print("queue1", "id", DispatchQueue.getSpecific(key: idKey))
  print("queue1", "date", DispatchQueue.getSpecific(key: dateKey))

  let queue2 = DispatchQueue(label: "queue2", target: queue1)
//  queue2.setSpecific(key: idKey, value: 1729)
  queue2.async {
    print("queue2", "id", DispatchQueue.getSpecific(key: idKey))
    print("queue2", "date", DispatchQueue.getSpecific(key: dateKey))
  }
}

Thread.sleep(forTimeInterval: 5)
