import Benchmark

let f = { { { { { { { { { max(1, 100) } } } } } } } } }

func g() -> Int {
  func g() -> Int {
    func g() -> Int {
      func g() -> Int {
        func g() -> Int {
          func g() -> Int {
            func g() -> Int {
              func g() -> Int {
                func g() -> Int {
                  max(1, 100)
                }
                return g()
              }
              return g()
            }
            return g()
          }
          return g()
        }
        return g()
      }
      return g()
    }
    return g()
  }
  return g()
}

let closureSuite = BenchmarkSuite(name: "Closures") { suite in
  suite.benchmark("Escaping") {
    precondition(f()()()()()()()()() == 100)
  }

  suite.benchmark("Non-escaping") {
    let f = { { { { { { { { { max(1, 100) } } } } } } } } }
    precondition(f()()()()()()()()() == 100)
  }

  suite.benchmark("Function") {
    precondition(g() == 100)
  }

  suite.benchmark("None") {
    precondition(max(1, 100) == 100)
  }
}


import Combine
import SwiftUI

let collection = [1, 2, 3]
  .lazy
  .filter { _ in true }
  .map { $0 + 1 }
  .map { $0 + 1 }

let publisher = Future<Int, Never> { $0(.success(1)) }
  .filter { _ in true }
  .map { $0 + 1 }
  .map { $0 + 1 }

let view = VStack {
  Text("hi")
    .foregroundColor(.red)

  HStack {
    Text("Go")
    Button("Now") {}
  }
}
//.font(.system(.title))
//.foregroundColor(.red)
