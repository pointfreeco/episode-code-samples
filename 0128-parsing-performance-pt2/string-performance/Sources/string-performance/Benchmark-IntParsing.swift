import Benchmark
import Foundation

let intParserSuite = BenchmarkSuite(name: "Int Parsing") { suite in
  let string = "1234567890"
  
  suite.benchmark("Int.init") {
    precondition(Int(string) == 1234567890)
  }

  suite.benchmark("Substring") {
    var string = string[...]
    precondition(Parser.int.run(&string) == 1234567890)
  }

  suite.benchmark("UnicodeScalar") {
    var string = string[...].unicodeScalars
    precondition(Parser.int.run(&string) == 1234567890)
  }

  suite.benchmark("UTF8") {
    var string = string[...].utf8
    precondition(Parser.int.run(&string) == 1234567890)
  }

  var arr = Array(string.utf8)
  suite.benchmark("Array") {
    var arr = arr[...]
    precondition(Parser.int.run(&arr) == 1234567890)
  }

  suite.benchmark("UnsafeBufferPointer") {
    string.utf8.withContiguousStorageIfAvailable { ptr in
      var ptr = ptr[...]
      precondition(Parser.int.run(&ptr) == 1234567890)
    }
  }

  var scanner: Scanner!
  suite.register(
    benchmark: Benchmarking(
      name: "Scanner",
      setUp: { scanner = Scanner(string: string) }
    ) { _ in
      precondition(scanner.scanInt() == 1234567890)
    }
  )
}
