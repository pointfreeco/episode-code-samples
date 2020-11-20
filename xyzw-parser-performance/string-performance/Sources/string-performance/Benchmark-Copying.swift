import Benchmark

let copyingSuite = BenchmarkSuite(name: "Copying") { suite in
  let string = String.init(repeating: "A", count: 1_000_000)

  suite.benchmark("String") {
    var copy = string
    copy.removeFirst()
    var copy1 = copy
    copy1.removeFirst()
    var copy2 = copy1
    copy2.removeFirst()
    var copy3 = copy2
    copy3.removeFirst()
  }

  suite.benchmark("Substring") {
    var copy = string[...]
    copy.removeFirst()
    var copy1 = copy
    copy1.removeFirst()
    var copy2 = copy1
    copy2.removeFirst()
    var copy3 = copy2
    copy3.removeFirst()
  }
}

