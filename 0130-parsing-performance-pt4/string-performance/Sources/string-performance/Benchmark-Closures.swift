import Benchmark

let f = {{{{{{{{{{ max(1, 100) }}}}}}}}}}

func g() -> Int {
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
  return g()
}

let closureSuite = BenchmarkSuite(name: "Closures") { suite in
  suite.benchmark("Escaping") {
    precondition(f()()()()()()()()()() == 100)
  }

  suite.benchmark("Non-escaping") {
    let h = {{{{{{{{{{ max(1, 100) }}}}}}}}}}
    precondition(h()()()()()()()()()() == 100)
  }

  suite.benchmark("None") {
    precondition(max(1, 100) == 100)
  }

  suite.benchmark("Function") {
    precondition(g() == 100)
  }
}
