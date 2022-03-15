import Benchmark
import Foundation
import Parsing

/// This benchmark demonstrates how to parse a boolean from the front of an input and compares its
/// performance against `Bool.init`, which does not incrementally parse, and Foundation's `Scanner`
/// type. `Scanner` does not have a `scanBool` method, but we can emulate this functionality by calling
/// `scanString` twice and mapping each result to a boolean.
let boolSuite = BenchmarkSuite(name: "Bool") { suite in
  var input = "true"
  var expected = true
  var output: Bool!

  suite.benchmark("Bool.init") {
    output = Bool(input)
  } tearDown: {
    tearDown()
  }

  suite.benchmark("Bool.parser") {
    var input = input[...].utf8
    output = try Bool.parser().parse(&input)
  } tearDown: {
    tearDown()
  }

  if #available(macOS 10.15, *) {
    var scanner: Scanner!
    suite.benchmark("Scanner.scanBool") {
      output = scanner.scanBool()
    } setUp: {
      scanner = Scanner(string: input)
    } tearDown: {
      tearDown()
    }
  }

  func tearDown() {
    precondition(output == expected)
    (input, expected) = expected ? ("false", false) : ("true", true)
  }
}

extension Scanner {
  @available(macOS 10.15, *)
  func scanBool() -> Bool? {
    self.scanString("true").map { _ in true }
      ?? self.scanString("false").map { _ in false }
  }
}
