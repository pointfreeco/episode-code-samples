import Foundation

enum MyLocals {
  @TaskLocal static var id: Int!
}

//print("before:", MyLocals.id)
//MyLocals.$id.withValue(42) {
//  print("withValue:", MyLocals.id!)
//  Task.detached {
//    print("Task:", MyLocals.id!)
//  }
//}
//print("after:", MyLocals.id)


//print(Task.currentPriority)
//Task(priority: .low) {
//  print(Task.currentPriority)
//  Task.detached {
//    print(Task.currentPriority)
//  }
//}


actor Counter {
  var count = 0

  func increment() async {
    self.count += 1

    await withTaskGroup(of: Void.self) { group in
      for _ in 1...1000 {
        group.addTask {
          if Bool.random() {
            await self.increment()
          } else {
            await self.decrement()
          }
        }
      }
    }
  }

  func decrement() {
    self.count -= 1
    Task.detached {
      try await Task.sleep(nanoseconds: NSEC_PER_SEC/2)
      if await self.count < 0 {
        await self.increment()
      }
    }
  }
}


Task {
  let counter = Counter()
  for _ in 0..<workCount {
    Task {
      await counter.decrement()
    }
  }
  Thread.sleep(forTimeInterval: 1)
  print(await counter.count)
}

Thread.sleep(forTimeInterval: 5)
