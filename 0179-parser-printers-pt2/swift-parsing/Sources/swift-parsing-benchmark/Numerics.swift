import Benchmark
import Foundation
import Parsing

/// This benchmark demonstrates how the numeric parsers in the library compare to Apple's tools, such
/// as initializers and `Scanner`.
let numericsSuite = BenchmarkSuite(name: "Numerics") { suite in
  do {
    let input = "123"
    let expected = 123
    var output: Int!

    suite.benchmark("Int.init") {
      output = Int(input)
    } tearDown: {
      precondition(output == expected)
    }

    suite.benchmark("Int.parser") {
      var input = input[...].utf8
      output = try Int.parser().parse(&input)
    } tearDown: {
      precondition(output == expected)
    }

    if #available(macOS 10.15, *) {
      let scanner = Scanner(string: input)
      suite.benchmark("Scanner.scanInt") {
        output = scanner.scanInt()
      } setUp: {
        scanner.currentIndex = input.startIndex
      } tearDown: {
        precondition(output == expected)
      }
    }
  }

  do {
    let input = (1...100_000).map(String.init).joined(separator: ",")
    let expected = Array(1...100_000)
    var output: [Int]!

    suite.benchmark("Comma separated: Int.parser") {
      var input = input[...].utf8
      output = try Many {
        Int.parser()
      } separator: {
        ",".utf8
      }
      .parse(&input)
    } tearDown: {
      precondition(output == expected)
    }

    if #available(macOS 10.15, *) {
      let scanner = Scanner(string: input)
      suite.benchmark("Comma separated: Scanner.scanInt") {
        output = []
        while let n = scanner.scanInt() {
          output.append(n)
          guard let separator = scanner.scanCharacter() else { break }
          guard separator == "," else {
            scanner.string.formIndex(before: &scanner.currentIndex)
            break
          }
        }
      } setUp: {
        scanner.currentIndex = input.startIndex
      } tearDown: {
        precondition(output == expected)
      }
    }

    suite.benchmark("Comma separated: String.split") {
      output = input.split(separator: ",").compactMap { Int($0) }
    } tearDown: {
      precondition(output == expected)
    }
  }

  do {
    let input = "123.45"
    let expected = 123.45
    var output: Double!

    suite.benchmark("Double.init") {
      output = Double(input)
    } tearDown: {
      precondition(output == expected)
    }

    suite.benchmark("Double.parser") {
      var input = input[...].utf8
      output = try Double.parser().parse(&input)
    } tearDown: {
      precondition(output == expected)
    }

    if #available(macOS 10.15, *) {
      let scanner = Scanner(string: input)
      suite.benchmark("Scanner.scanDouble") {
        output = scanner.scanDouble()
      } setUp: {
        scanner.currentIndex = input.startIndex
      } tearDown: {
        precondition(output == expected)
      }
    }
  }

  do {
    let input = (1...100_000).map(String.init).joined(separator: ",")
    let expected = (1...100_000).map(Double.init)
    var output: [Double]!

    suite.benchmark("Comma separated: Double.parser") {
      var input = input[...].utf8
      output = try Many {
        Double.parser()
      } separator: {
        ",".utf8
      }
      .parse(&input)
    } tearDown: {
      precondition(output == expected)
    }

    if #available(macOS 10.15, *) {
      let scanner = Scanner(string: input)
      suite.benchmark("Comma separated: Scanner.scanDouble") {
        output = []
        while let n = scanner.scanDouble() {
          output.append(n)
          guard let separator = scanner.scanCharacter() else { break }
          guard separator == "," else {
            scanner.string.formIndex(before: &scanner.currentIndex)
            break
          }
        }
      } setUp: {
        scanner.currentIndex = input.startIndex
      } tearDown: {
        precondition(output == expected)
      }
    }

    suite.benchmark("Comma separated: String.split") {
      output = input.split(separator: ",").compactMap { Double($0) }
    } tearDown: {
      precondition(output == expected)
    }
  }
}
