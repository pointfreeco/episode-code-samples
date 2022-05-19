import Foundation

func operationQueueBasics() {
  let queue = OperationQueue()

  queue.addOperation {
    print(Thread.current)
  }
  queue.addOperation { print("1", Thread.current) }
  queue.addOperation { print("2", Thread.current) }
  queue.addOperation { print("3", Thread.current) }
  queue.addOperation { print("4", Thread.current) }
  queue.addOperation { print("5", Thread.current) }
}

func operationPriorityAndCancellation() {
  let queue = OperationQueue()

  let operation = BlockOperation()
  operation.addExecutionBlock { [unowned operation] in
    let start = Date()
    defer { print("Finished in", Date().timeIntervalSince(start)) }

    Thread.sleep(forTimeInterval: 1)
    guard !operation.isCancelled
    else {
      print("Cancelled!")
      return
    }
    print(Thread.current)
  }
  operation.qualityOfService = .background
  queue.addOperation(operation)

  Thread.sleep(forTimeInterval: 0.1)
  operation.cancel()
}

func operationQueueCoordination() {
  let queue = OperationQueue()

  let operationA = BlockOperation {
    print("A")
    Thread.sleep(forTimeInterval: 1)
  }
  let operationB = BlockOperation {
    print("B")
  }
  let operationC = BlockOperation {
    print("C")
  }
  let operationD = BlockOperation {
    print("D")
  }
  operationB.addDependency(operationA)
  operationC.addDependency(operationA)
  operationD.addDependency(operationB)
  operationD.addDependency(operationC)
  queue.addOperation(operationA)
  queue.addOperation(operationB)
  queue.addOperation(operationC)
  queue.addOperation(operationD)

  operationA.cancel()

  /*
    A ➡️ B
   ⬇️    ⬇️
    C ➡️ D
   */
}

func operationPerformance() {
  let queue = OperationQueue()

  for n in 0..<workCount {
    queue.addOperation {
      print(n, Thread.current)
      while true {}
    }
  }

  queue.addOperation {
    print("Starting the prime operation")
    nthPrime(50_000)
  }
}
