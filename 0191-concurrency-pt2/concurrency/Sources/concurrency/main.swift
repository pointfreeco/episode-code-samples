import Combine
import Foundation

let publisher1 = Deferred {
  Future<Int, Never> { callback in
    print(Thread.current)
    callback(.success(42))
  }
}
  .subscribe(on: DispatchQueue(label: "queue1"))

let publisher2 = Deferred {
  Future<String, Never> { callback in
    print(Thread.current)
    callback(.success("Hello world"))
  }
}
  .subscribe(on: DispatchQueue(label: "queue2"))

let cancellable = publisher1
  .flatMap { integer in
    Deferred {
      Future<String, Never> { callback in
        print(Thread.current)
        callback(.success("\(integer)"))
      }
    }
    .subscribe(on: DispatchQueue(label: "queue3"))
  }
  .zip(publisher2)
  .sink {
  print("sink", $0, Thread.current)
}

_ = cancellable


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

//a
//  .handleEvents(...)
//  .compactMap { $0 }
//  .flatMap { a in zip(b(a), c(a)) }
//  .flatMap { b, c in d(b, c) }
//  .handleEvents(receiveCompletion: { _ in print("Finished") })

// defer { print("Finished") }
// guard let a = await f()
// else { return }
// async let b = g(a)
// async let c = h(a)
// let d = await i(b, c)


func dispatchDiamondDependency() {
  let queue = DispatchQueue(label: "queue", attributes: .concurrent)
  queue.async {
    print("A")

    let group = DispatchGroup()
    queue.async(group: group) {
      print("B")
    }
    queue.async(group: group) {
      print("C")
    }

    group.notify(queue: queue) {
      print("D")
    }
  }
}

Thread.sleep(forTimeInterval: 5)
