import Benchmark
import Parsing

/*
 This benchmark demonstrates how to build process a dump of Xcode test logs to transform them
 in an array of test failures and passes.
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

private let testCaseFinishedLine = Parse {
  Skip {
    PrefixThrough(" (".utf8)
  }
  Double.parser()
  " seconds).\n".utf8
}

private let testCaseStartedLine = Parse {
  Skip {
    PrefixUpTo("Test Case '-[".utf8)
  }
  PrefixThrough("\n".utf8)
    .map { line in line.split(separator: .init(ascii: " "))[3].dropLast(2) }
}

private let fileName = Parse {
  "/".utf8
  PrefixThrough(".swift".utf8)
    .compactMap { $0.split(separator: .init(ascii: "/")).last }
}

private let testCaseBody = Parse {
  fileName
  ":".utf8
  Int.parser()
  Skip {
    PrefixThrough("] : ".utf8)
  }
  Rest()
}

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

private let testFailed = Parse {
  testCaseStartedLine
  Many { TestCaseBody() }
  testCaseFinishedLine
}
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

private let testPassed = Parse {
  testCaseStartedLine.map(Substring.init)
  testCaseFinishedLine
}
.map { [TestResult.passed(testName: $0, time: $1)] }

private let testResult = OneOf {
  testFailed
  testPassed
}

let testResultsUtf8 = Many {
  testResult
}
.map { $0.flatMap { $0 } }
