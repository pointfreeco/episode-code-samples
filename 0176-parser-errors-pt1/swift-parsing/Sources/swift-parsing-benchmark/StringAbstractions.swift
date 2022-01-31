import Benchmark
import Parsing

/*
 This benchmark demonstrates how to parse on multiple string abstractions at once, and the costs
 of doing so. The parsers benchmarked parse a list of integers that are separated by a
 UTF8 character with multiple equivalent representations: "LATIN SMALL LETTER E WITH ACUTE" and
 "E + COMBINING ACUTE ACCENT".

 In the "Substring" suite we parse integers on the UTF8View abstraction and parse the separator
 on the Substring abstraction in order to take advantage of its UTF8 normalization logic.

 In the "UTF8" suite we parse both the integers and the separators on the UTF8View abstraction,
 but this means we are responsible for handling UTF8 normalization, so we have to explicitly
 handle both the "LATIN SMALL LETTER E WITH ACUTE" and "E + COMBINING ACUTE ACCENT" characters.
 */

let stringAbstractionsSuite = BenchmarkSuite(name: "String Abstractions") { suite in
  let count = 1_000
  let input = (1...count)
    .reduce(into: "") { accum, int in
      accum += "\(int)" + (int.isMultiple(of: 2) ? "\u{00E9}" : "e\u{0301}")
    }
    .dropLast()

  suite.benchmark("Substring") {
    var input = input[...].utf8
    let output = Many {
      Int.parser(of: Substring.UTF8View.self)
    } separator: {
      FromSubstring { "\u{00E9}" }
    }
    .parse(&input)
    precondition(output?.count == count)
  }

  suite.benchmark("UTF8") {
    var input = input[...].utf8
    let output = Many {
      Int.parser()
    } separator: {
      OneOf {
        "\u{00E9}".utf8
        "e\u{0301}".utf8
      }
    }
    .parse(&input)
    precondition(output?.count == count)
  }
}
