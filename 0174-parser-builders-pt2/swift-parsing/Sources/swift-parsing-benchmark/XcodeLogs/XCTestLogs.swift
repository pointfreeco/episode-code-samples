import Benchmark
import Parsing

/*
 This benchmark demonstrates how to build process a dump of Xcode test logs to transform them
 in an array of test failures and passes. It can process roughly 80 mb/s.

     name              time           std        iterations
     ------------------------------------------------------
     Xcode Logs.Parser 7367774.000 ns ±   6.57 %        189
 */

let xcodeLogsSuite = BenchmarkSuite(name: "Xcode Logs") { suite in
  var output: [TestResult]!

  suite.benchmark(
    name: "Parser",
    run: {
      var input = xcodeLogs[...].utf8
      output = testResultsUtf8.parse(&input)!
    },
    tearDown: {
      precondition(output.count == 284)
    }
  )
}

private let testCaseFinishedLine = Skip(PrefixThrough(" (".utf8))
  .take(Double.parser())
  .skip(" seconds).\n".utf8)

private let testCaseStartedLine = Skip(PrefixUpTo("Test Case '-[".utf8))
  .take(PrefixThrough("\n".utf8))
  .map { line in
    line.split(separator: .init(ascii: " "))[3].dropLast(2)
  }

private let fileName = Skip("/".utf8)
  .take(PrefixThrough(".swift".utf8))
  .compactMap { $0.split(separator: .init(ascii: "/")).last }

private let testCaseBody =
  fileName
  .skip(":".utf8)
  .take(Int.parser())
  .skip(PrefixThrough("] : ".utf8))
  .take(Rest())

struct TestCaseBody: Parser {
  func parse(
    _ input: inout Substring.UTF8View
  ) -> (file: Substring.UTF8View, line: Int, message: Substring.UTF8View)? {
    let original = input

    guard input.first == .init(ascii: "/")
    else { return nil }

    var slashCount = 0
    let filePathPrefix = input.prefix { codeUnit in
      if codeUnit == .init(ascii: "/") {
        slashCount += 1
      }
      return slashCount != 3
    }

    input.removeFirst(filePathPrefix.count)
    guard
      var failure = PrefixUpTo(filePathPrefix).parse(&input)
        ?? PrefixUpTo("Test Case '-[".utf8).parse(&input)
    else {
      input = original
      return nil
    }

    failure.removeLast()  // trailing newline
    let output = testCaseBody.parse(&failure)
    return output
  }
}

enum TestResult {
  case failed(
    failureMessage: Substring,
    file: Substring,
    line: Int,
    testName: Substring,
    time: Double
  )
  case passed(testName: Substring, time: Double)
}

private let testFailed =
  testCaseStartedLine
  .take(Many(TestCaseBody()))
  .take(testCaseFinishedLine)
  .map { testName, bodyData, time in
    bodyData.map { body in
      TestResult.failed(
        failureMessage: Substring(body.2),
        file: Substring(body.0),
        line: body.1,
        testName: Substring(testName),
        time: time
      )
    }
  }
  .filter { !$0.isEmpty }

private let testPassed = testCaseStartedLine.map(Substring.init)
  .take(testCaseFinishedLine)
  .map { [TestResult.passed(testName: $0, time: $1)] }

private let testResult = testFailed.orElse(testPassed)

let testResultsUtf8 = Many(testResult)
  .map { $0.flatMap { $0 } }
