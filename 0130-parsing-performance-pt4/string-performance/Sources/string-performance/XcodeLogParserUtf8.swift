import Foundation

private let testCaseFinishedLine = Parser
  .skip(.prefix(through: " ("[...].utf8))
  .take(.double)
  .skip(.prefix(" seconds).\n"[...].utf8))

private let testCaseStartedLine = Parser
  .skip(.prefix(upTo: "Test Case '-["[...].utf8))
  .take(.prefix(through: "\n"[...].utf8))
  .map { line in
    line.split(separator: .init(ascii: " "))[3].dropLast(2)
  }

private let fileName = Parser
  .skip(.prefix("/"[...].utf8))
  .take(.prefix(through: ".swift"[...].utf8))
  .flatMap { path in
    path.split(separator: .init(ascii: "/")).last.map(Parser.always)
      ?? .never
  }

private let testCaseBody = fileName
  .skip(.prefix(":"[...].utf8))
  .take(.int)
  .skip(.prefix(through: "] : "[...].utf8))
  .take(Parser.prefix(upTo: "Test Case '-["[...].utf8).map { $0.dropLast() })

enum TestResultUtf8 {
  case failed(failureMessage: Substring, file: Substring, line: Int, testName: Substring, time: TimeInterval)
  case passed(testName: Substring, time: TimeInterval)
}

private let testFailed = testCaseStartedLine
  .take(testCaseBody)
  .take(testCaseFinishedLine)
  .map { testName, bodyData, time in
    TestResultUtf8.failed(failureMessage: Substring(bodyData.2), file: Substring(bodyData.0), line: bodyData.1, testName: Substring(testName), time: time)
  }

private let testPassed = testCaseStartedLine.map(Substring.init)
  .take(testCaseFinishedLine)
  .map(TestResultUtf8.passed(testName:time:))

private let testResult = Parser.oneOf(testFailed, testPassed)

let testResultsUtf8 = testResult.zeroOrMore()
