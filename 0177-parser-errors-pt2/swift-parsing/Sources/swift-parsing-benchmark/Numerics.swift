import Benchmark
import Foundation
import Parsing

/*
 This benchmark demonstrates how the numeric parsers in the library compare to Apple's tools, such
 as initializers and `Scanner`.
 */

let numericsSuite = BenchmarkSuite(name: "Numerics") { suite in
  do {
    let input = "123"
    let expected = 123
    var output: Int!

    suite.benchmark(
      name: "Int.init",
      run: { output = Int(input) },
      tearDown: { precondition(output == expected) }
    )

    suite.benchmark(
      name: "Int.parser",
      run: { output = Int.parser(of: Substring.UTF8View.self).parse(input) },
      tearDown: { precondition(output == expected) }
    )

    if #available(macOS 10.15, *) {
      let scanner = Scanner(string: input)
      suite.benchmark(
        name: "Scanner.scanInt",
        setUp: { scanner.currentIndex = input.startIndex },
        run: { output = scanner.scanInt() },
        tearDown: { precondition(output == expected) }
      )
    }
  }

  do {
    let input = (1...100_000).map(String.init).joined(separator: ",")
    let expected = Array(1...100_000)
    var output: [Int]!

    let parser = Many {
      Int.parser()
    } separator: {
      ",".utf8
    }
    suite.benchmark(
      name: "Comma separated: Int.parser",
      run: { output = parser.parse(input) },
      tearDown: { precondition(output == expected) }
    )

    if #available(macOS 10.15, *) {
      let scanner = Scanner(string: input)
      suite.benchmark(
        name: "Comma separated: Scanner.scanInt",
        setUp: { scanner.currentIndex = input.startIndex },
        run: {
          output = []
          while let n = scanner.scanInt() {
            output.append(n)
            guard let separator = scanner.scanCharacter() else { break }
            guard separator == "," else {
              scanner.string.formIndex(before: &scanner.currentIndex)
              break
            }
          }
        },
        tearDown: { precondition(output == expected) }
      )
    }

    suite.benchmark(
      name: "Comma separated: String.split",
      run: { output = input.split(separator: ",").compactMap { Int($0) } },
      tearDown: { precondition(output == expected) }
    )
  }

  do {
    let input = "123.45"
    let expected = 123.45
    var output: Double!

    suite.benchmark(
      name: "Double.init",
      run: { output = Double(input) },
      tearDown: { precondition(output == expected) }
    )

    suite.benchmark(
      name: "Double.parser",
      run: {
        output = Double.parser(of: Substring.UTF8View.self).parse(input)
      },
      tearDown: { precondition(output == expected) }
    )

    if #available(macOS 10.15, *) {
      let scanner = Scanner(string: input)
      suite.benchmark(
        name: "Scanner.scanDouble",
        setUp: { scanner.currentIndex = input.startIndex },
        run: { output = scanner.scanDouble() },
        tearDown: { precondition(output == expected) }
      )
    }
  }

  do {
    let input = (1...100_000).map(String.init).joined(separator: ",")
    let expected = (1...100_000).map(Double.init)
    var output: [Double]!

    let parser = Many {
      Double.parser()
    } separator: {
      ",".utf8
    }
    suite.benchmark(
      name: "Comma separated: Double.parser",
      run: { output = parser.parse(input) },
      tearDown: { precondition(output == expected) }
    )

    if #available(macOS 10.15, *) {
      let scanner = Scanner(string: input)
      suite.benchmark(
        name: "Comma separated: Scanner.scanDouble",
        setUp: { scanner.currentIndex = input.startIndex },
        run: {
          output = []
          while let n = scanner.scanDouble() {
            output.append(n)
            guard let separator = scanner.scanCharacter() else { break }
            guard separator == "," else {
              scanner.string.formIndex(before: &scanner.currentIndex)
              break
            }
          }
        },
        tearDown: { precondition(output == expected) }
      )
    }

    suite.benchmark(
      name: "Comma separated: String.split",
      run: { output = input.split(separator: ",").compactMap { Double($0) } },
      tearDown: { precondition(output == expected) }
    )
  }
}
