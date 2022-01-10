import Benchmark
import Foundation
import Parsing

/*
 This benchmark demonstrates how to parse a boolean from the front of an input. The parser library
 is compared against Foundation's `Scanner` type, which doesn't have a `.scanBool` method but can
 be emulated by using the `.scanString` method twice.
 */

let boolSuite = BenchmarkSuite(name: "Bool") { suite in
  let input = "true"
  let expected = true
  var output: Bool!

  suite.benchmark(
    name: "Bool.init",
    run: { output = Bool(input) },
    tearDown: { precondition(output == expected) }
  )

  suite.benchmark(
    name: "BoolParser",
    run: { output = Bool.parser(of: Substring.UTF8View.self).parse(input) },
    tearDown: { precondition(output == expected) }
  )

  if #available(macOS 10.15, *) {
    let scanner = Scanner(string: input)
    suite.benchmark(
      name: "Scanner.scanBool",
      setUp: { scanner.currentIndex = input.startIndex },
      run: {
        output =
          scanner.scanString("true").map { _ in true }
          ?? scanner.scanString("false").map { _ in false }
      },
      tearDown: { precondition(output == expected) }
    )
  }
}
