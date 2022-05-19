import Foundation

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

Thread.sleep(forTimeInterval: 1.1)
