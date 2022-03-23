import Benchmark
import Foundation
import Parsing

/// This benchmarks the performance of `PrefixUpTo` against Apple's tools.
let prefixUpToSuite = BenchmarkSuite(name: "PrefixUpTo") { suite in
  let input = String(repeating: ".", count: 10_000) + "Hello, world!"

  do {
    var output: Substring!
    suite.benchmark("Parser: Substring") {
      var input = input[...]
      output = try PrefixUpTo("Hello").parse(&input)
    } tearDown: {
      precondition(output.count == 10_000)
    }
  }

  do {
    var output: Substring.UTF8View!
    suite.benchmark("Parser: UTF8") {
      var input = input[...].utf8
      output = try PrefixUpTo("Hello".utf8).parse(&input)
    } tearDown: {
      precondition(output.count == 10_000)
    }
  }

  do {
    var output: Substring!
    suite.benchmark("String.range(of:)") {
      output = input.range(of: "Hello").map { input.prefix(upTo: $0.lowerBound) }
    } tearDown: {
      precondition(output.count == 10_000)
    }
  }

  if #available(macOS 10.15, *) {
    var output: String!
    let scanner = Scanner(string: input)
    suite.benchmark("Scanner.scanUpToString") {
      output = scanner.scanUpToString("Hello")
    } setUp: {
      scanner.currentIndex = input.startIndex
    } tearDown: {
      precondition(output.count == 10_000)
    }
  }
}
