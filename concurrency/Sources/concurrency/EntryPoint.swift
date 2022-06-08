import Foundation

//@main
//struct Main {
//  static func main() async throws {
//    try await Task.sleep(nanoseconds: NSEC_PER_SEC)
//    print("done!")
//  }
//}


//@preconcurrency import Foundation
//
////var x = 0
////outer: var y = 0
////inner: if x.isMultiple(of: 2) && y.isMultiple(of: 2) {
////  print(x, y)
////}
////y += 1
////if y <= 100 {
////  continue inner
////}
////print("Inner loop finished")
////x += 1
////if x <= 100 {
////  continue outer
////}
////print("Outer loop finished")
////
////func loops() {
////  defer { print("Outer loop has finished") }
////  for x in 0...100 {
////    defer { print("Inner loop has finished") }
////    for y in 0...100 {
////      if x.isMultiple(of: 2) && y.isMultiple(of: 2) {
////        print(x, y)
////      }
////    }
////  }
////}
////
////func add(_ lhs: Int, _ rhs: Int) -> Int {
////  lhs + rhs
////}
////
////add(3, 4)
////
////
////final class Counter {
////  let lock = NSLock()
////  var count = 0
////  func increment() {
////    self.lock.lock()
////    self.count += 1
////    continue somewhereElse
////    self.lock.unlock()
////  }
////}
////
////func thread() {
////  let lock = NSLock()
////  lock.lock()
////  defer { print("Finished") }
////  print("Before")
////  Thread.detachNewThread {
////    print(Thread.current)
////  }
////  print("After")
////  lock.unlock()
////}
////thread()
//
//
//enum RequestData {
//  @TaskLocal static var requestId: UUID!
//  @TaskLocal static var startDate: Date!
//}
//
//struct Response: Encodable {
//  let user: User
//  let subscription: StripeSubscription
//}
//
//struct User: Encodable { var id: Int }
//func fetchUser() async throws -> User {
//  let requestId = RequestData.requestId!
//  defer { print(requestId, "databaseQuery", "isCancelled", Task.isCancelled) }
//  print(requestId, "Making database query")
//  try await Task.sleep(nanoseconds: 500_000_000)
//  print(requestId, "Finished database query")
//  return User(id: 42)
//}
//
//struct StripeSubscription: Encodable { var id: Int }
//func fetchSubscription() async throws -> StripeSubscription {
//  let requestId = RequestData.requestId!
//  defer { print(requestId,"networkRequest", "isCancelled", Task.isCancelled) }
//  print(requestId, "Making network request")
//  try await Task.sleep(nanoseconds: 500_000_000)
//  print(requestId, "Finished network request")
//  return StripeSubscription(id: 1729)
//}
//
//func response(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
//  let requestId = RequestData.requestId!
//  let start = RequestData.startDate!
//
//  defer { print(requestId, "Request finished in", Date().timeIntervalSince(start)) }
//
//  Task {
//    print(RequestData.requestId!, "Track analytics")
//  }
//  async let user = fetchUser()
//  async let subscription = fetchSubscription()
//
//  let jsonData = try await JSONEncoder().encode(Response(user: user, subscription: subscription))
//
//  return (jsonData, .init())
//}
//
////RequestData.$requestId.withValue(UUID()) {
////  RequestData.$startDate.withValue(Date()) {
////    let task = Task {
////      _ = try await response(for: .init(url: .init(string: "https://www.pointfree.co")!))
////    }
////    Thread.sleep(forTimeInterval: 0.1)
////    task.cancel()
////  }
////}
//
//Task {
//  let sum = try await withThrowingTaskGroup(of: Int.self, returning: Int.self) { group in
//    for n in 1...1000 {
//      group.addTask {
//        try await Task.sleep(nanoseconds: NSEC_PER_SEC)
//        return n
//      }
//    }
//    var sum = 0
//    for try await int in group {
//      sum += int
//    }
//    return sum
//  }
//  print("sum", sum)
//  // n*(n+1)/2, 1000*1001/2 = 500,500
//}
//
//import SwiftUI
//
//Text("Hi")
//  .task {
//    let sum = try? await withThrowingTaskGroup(of: Int.self, returning: Int.self) { group in
//      for n in 1...1000 {
//        group.addTask {
//          try await Task.sleep(nanoseconds: NSEC_PER_SEC)
//          return n
//        }
//      }
//      var sum = 0
//      for try await int in group {
//        sum += int
//      }
//      return sum
//    }
//    print("sum", sum)
//  }
//
////try await Task.sleep(nanoseconds: NSEC_PER_SEC)
//
////var sum = 0
////for n in 1...1000 {
////  Thread.detachNewThread {
////    Thread.sleep(forTimeInterval: 1)
////    sum += n
////  }
////}
////Thread.sleep(forTimeInterval: 1.1)
////print("sum", sum)
//
//Thread.sleep(forTimeInterval: 5)
