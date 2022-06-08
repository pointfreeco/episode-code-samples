import Foundation

//var x = 0
//outer: var y = 0
//inner: if x.isMultiple(of: 2) && y.isMultiple(of: 2) {
//  print(x, y)
//}
//y += 1
//if y <= 100 {
//  continue inner
//}
//print("Inner loop finished")
//x += 1
//if x <= 100 {
//  continue outer
//}
//print("Outer loop finished")
//
//func loops() {
//  defer { print("Outer loop has finished") }
//  for x in 0...100 {
//    defer { print("Inner loop has finished") }
//    for y in 0...100 {
//      if x.isMultiple(of: 2) && y.isMultiple(of: 2) {
//        print(x, y)
//      }
//    }
//  }
//}
//
//func add(_ lhs: Int, _ rhs: Int) -> Int {
//  lhs + rhs
//}
//
//add(3, 4)
//
//
//final class Counter {
//  let lock = NSLock()
//  var count = 0
//  func increment() {
//    self.lock.lock()
//    self.count += 1
//    continue somewhereElse
//    self.lock.unlock()
//  }
//}

func thread() {
  let lock = NSLock()
  lock.lock()
  defer { print("Finished") }
  print("Before")
  Thread.detachNewThread {
    print(Thread.current)
  }
  print("After")
  lock.unlock()
}
thread()

Thread.sleep(forTimeInterval: 5)
