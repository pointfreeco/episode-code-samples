import Foundation

private let testCaseFinishedLine = Parser
  .skip(.prefix(through: " ("))
  .take(.double)
  .skip(" seconds).\n")

private let testCaseStartedLine = Parser
  .skip(.prefix(upTo: "Test Case '-["[...]))
  .take(.prefix(through: "\n"))
  .map { line in
    line.split(separator: " ")[3].dropLast(2)
  }

private let fileName = Parser
  .skip("/")
  .take(.prefix(through: ".swift"))
  .flatMap { path in
    path.split(separator: "/").last.map(Parser.always)
      ?? .never
  }

private let testCaseBody = fileName
  .skip(":")
  .take(.int)
  .skip(.prefix(through: "] : "))
  .take(Parser.prefix(upTo: "Test Case '-[").map { $0.dropLast() })

enum TestResult {
  case failed(failureMessage: Substring, file: Substring, line: Int, testName: Substring, time: TimeInterval)
  case passed(testName: Substring, time: TimeInterval)
}

private let testFailed = testCaseStartedLine
  .take(testCaseBody)
  .take(testCaseFinishedLine)
  .map { testName, bodyData, time in
    TestResult.failed(failureMessage: bodyData.2, file: bodyData.0, line: bodyData.1, testName: testName, time: time)
  }

private let testPassed = testCaseStartedLine
  .take(testCaseFinishedLine)
  .map(TestResult.passed(testName:time:))

private let testResult = Parser.oneOf(testFailed, testPassed)

let testResults = testResult.zeroOrMore()
