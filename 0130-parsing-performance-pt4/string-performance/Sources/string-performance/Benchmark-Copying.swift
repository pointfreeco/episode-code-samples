import Benchmark

let copyingSuite = BenchmarkSuite(name: "Copying") { suite in
  let string = String.init(repeating: "👨‍👨‍👧‍👧", count: 1_000_000)

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

  suite.benchmark("UnicodeScalars") {
    var copy = string[...].unicodeScalars
    copy.removeFirst()
    var copy1 = copy
    copy1.removeFirst()
    var copy2 = copy1
    copy2.removeFirst()
    var copy3 = copy2
    copy3.removeFirst()
  }

  suite.benchmark("UTF8") {
    var copy = string[...].utf8
    copy.removeFirst()
    var copy1 = copy
    copy1.removeFirst()
    var copy2 = copy1
    copy2.removeFirst()
    var copy3 = copy2
    copy3.removeFirst()
  }
}

