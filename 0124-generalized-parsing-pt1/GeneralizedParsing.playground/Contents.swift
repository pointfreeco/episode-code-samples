import Foundation

struct Parser<Input, Output> {
  let run: (inout Input) -> Output?
}

//dump(
//ProcessInfo.processInfo.environment
//)

//URLComponents
let components = URLComponents(string: "https://www.pointfree.co/episodes/1?time=120")
components?.host
components?.path
components?.query
components?.queryItems
//URLQueryItem.init(name: <#T##String#>, value: <#T##String?#>)

// swift package init --name=MyPackage --type=executable
// swift build -v
// swift build --verbose --sanitize
// swift build --sanitize --verbose
//dump(CommandLine.arguments)

[
  "/Users/point-free/Library/Developer/XCPGDevices/7791186F-129C-4B2D-A0DF-2B685D338A84/data/Containers/Bundle/Application/F6013A8B-FED5-4A87-B7E7-D2BA154AE029/GeneralizedParsing-17305-7.app/GeneralizedParsing",
  "-DVTDeviceRunExecutableOptionREPLMode",
  "1"
]

extension Parser {
  func run(_ input: Input) -> (match: Output?, rest: Input) {
    var input = input
    let match = self.run(&input)
    return (match, input)
  }
}

extension Parser where Input == Substring, Output == Int {
  static let int = Self { input in
    let original = input

    var isFirstCharacter = true
    let intPrefix = input.prefix { character in
      defer { isFirstCharacter = false }
      return (character == "-" || character == "+") && isFirstCharacter
        || character.isNumber
    }

    guard let match = Int(intPrefix)
    else {
      input = original
      return nil
    }
    input.removeFirst(intPrefix.count)
    return match
  }
}

Parser.int.run("123 Hello")


extension Parser where Input == Substring, Output == Double {
  static let double = Self { input in
    let original = input
    let sign: Double
    if input.first == "-" {
      sign = -1
      input.removeFirst()
    } else if input.first == "+" {
      sign = 1
      input.removeFirst()
    } else {
      sign = 1
    }

    var decimalCount = 0
    let prefix = input.prefix { char in
      if char == "." { decimalCount += 1 }
      return char.isNumber || (char == "." && decimalCount <= 1)
    }

    guard let match = Double(prefix)
    else {
      input = original
      return nil
    }

    input.removeFirst(prefix.count)
    return match * sign
  }
}

Parser.double.run("123.4 Hello")


extension Parser where Input == Substring, Output == Character {
  static let char = Self { input in
    guard !input.isEmpty else { return nil }
    return input.removeFirst()
  }
}

extension Parser {
  static func always(_ output: Output) -> Self {
    Self { _ in output }
  }

  static var never: Self {
    Self { _ in nil }
  }
}

extension Parser {
  func map<NewOutput>(_ f: @escaping (Output) -> NewOutput) -> Parser<Input, NewOutput> {
    .init { input in
      self.run(&input).map(f)
    }
  }
}

extension Parser {
  func flatMap<NewOutput>(
    _ f: @escaping (Output) -> Parser<Input, NewOutput>
  ) -> Parser<Input, NewOutput> {
    .init { input in
      let original = input
      let output = self.run(&input)
      let newParser = output.map(f)
      guard let newOutput = newParser?.run(&input) else {
        input = original
        return nil
      }
      return newOutput
    }
  }
}

func zip<Input, Output1, Output2>(
  _ p1: Parser<Input, Output1>,
  _ p2: Parser<Input, Output2>
) -> Parser<Input, (Output1, Output2)> {

  .init { input -> (Output1, Output2)? in
    let original = input
    guard let output1 = p1.run(&input) else { return nil }
    guard let output2 = p2.run(&input) else {
      input = original
      return nil
    }
    return (output1, output2)
  }
}

extension Parser {
  static func oneOf(_ ps: [Self]) -> Self {
    .init { input in
      for p in ps {
        if let match = p.run(&input) {
          return match
        }
      }
      return nil
    }
  }

  static func oneOf(_ ps: Self...) -> Self {
    self.oneOf(ps)
  }
}

extension Parser {
  func zeroOrMore(
    separatedBy separator: Parser<Input, Void> = .always(())
  ) -> Parser<Input, [Output]> {
    Parser<Input, [Output]> { input in
      var rest = input
      var matches: [Output] = []
      while let match = self.run(&input) {
        rest = input
        matches.append(match)
        if separator.run(&input) == nil {
          return matches
        }
      }
      input = rest
      return matches
    }
  }
}

extension Parser
where Input: Collection,
      Input.SubSequence == Input,
      Output == Void,
      Input.Element: Equatable {
  static func prefix(_ p: Input.SubSequence) -> Self {
    Self { input in
      guard input.starts(with: p) else { return nil }
      input.removeFirst(p.count)
      return ()
    }
  }
}

extension Parser where Input == Substring, Output == Substring {
  static func prefix(while p: @escaping (Character) -> Bool) -> Self {
    Self { input in
      let output = input.prefix(while: p)
      input.removeFirst(output.count)
      return output
    }
  }

  static func prefix(upTo substring: Substring) -> Self {
    Self { input in
      guard let endIndex = input.range(of: substring)?.lowerBound
      else { return nil }

      let match = input[..<endIndex]

      input = input[endIndex...]

      return match
    }
  }

  static func prefix(through substring: Substring) -> Self {
    Self { input in
      guard let endIndex = input.range(of: substring)?.upperBound
      else { return nil }

      let match = input[..<endIndex]

      input = input[endIndex...]

      return match
    }
  }
}

extension Parser: ExpressibleByUnicodeScalarLiteral where Input == Substring, Output == Void {
  typealias UnicodeScalarLiteralType = StringLiteralType
}

extension Parser: ExpressibleByExtendedGraphemeClusterLiteral where Input == Substring, Output == Void {
  typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
}

extension Parser: ExpressibleByStringLiteral where Input == Substring, Output == Void {
  typealias StringLiteralType = String

  init(stringLiteral value: String) {
    self = .prefix(value[...])
  }
}

extension Parser {
  static func skip(_ p: Self) -> Parser<Input, Void> {
    p.map { _ in () }
  }

  func skip<OtherOutput>(_ p: Parser<Input, OtherOutput>) -> Self {
    zip(self, p).map { a, _ in a }
  }

  func take<NewOutput>(_ p: Parser<Input, NewOutput>) -> Parser<Input, (Output, NewOutput)> {
    zip(self, p)
  }

  func take<A>(_ p: Parser<Input, A>) -> Parser<Input, A>
  where Output == Void {
    zip(self, p).map { _, a in a }
  }

  func take<A, B, C>(_ p: Parser<Input, C>) -> Parser<Input, (A, B, C)>
  where Output == (A, B) {
    zip(self, p).map { ab, c in
      (ab.0, ab.1, c)
    }
  }
}



let temperature = Parser.int.skip("°F")

temperature.run("100°F")
temperature.run("-100°F")

let northSouth = Parser.char.flatMap {
  $0 == "N" ? .always(1.0)
    : $0 == "S" ? .always(-1)
    : .never
}

let eastWest = Parser.char.flatMap {
  $0 == "E" ? .always(1.0)
    : $0 == "W" ? .always(-1)
    : .never
}

//"40.446° N"
//"40.446° S"
let latitude = Parser.double
  .skip("° ")
  .take(northSouth)
  .map(*)

let longitude = Parser.double
  .skip("° ")
  .take(eastWest)
  .map(*)

struct Coordinate {
  let latitude: Double
  let longitude: Double
}

let zeroOrMoreSpaces = Parser<Substring, Void>.prefix(" ").zeroOrMore()

//"40.446° N, 79.982° W"
let coord = latitude
  .skip(",")
  .skip(zeroOrMoreSpaces)
  .take(longitude)
  .map(Coordinate.init)


Parser.prefix([1, 2]).run([1, 2, 3, 4, 5, 6][...])
Parser<ArraySlice<Int>, Void>.prefix([1, 2]).run([1, 2, 3, 4, 5, 6])

Parser.prefix([1, 2]).run([1, 2, 3, 4, 5, 6][...])

enum Currency { case eur, gbp, usd }

let currency = Parser<Substring, Currency>.oneOf(
  Parser.prefix("€").map { Currency.eur },
  Parser.prefix("£").map { .gbp },
  Parser.prefix("$").map { .usd }
)

struct Money {
  let currency: Currency
  let value: Double
}

//"$100"
let money = zip(currency, .double)
  .map(Money.init(currency:value:))

money.run("$100")
money.run("£100")
money.run("€100")



let upcomingRaces = """
  New York City, $300
  40.60248° N, 74.06433° W
  40.61807° N, 74.02966° W
  40.64953° N, 74.00929° W
  40.67884° N, 73.98198° W
  40.69894° N, 73.95701° W
  40.72791° N, 73.95314° W
  40.74882° N, 73.94221° W
  40.75740° N, 73.95309° W
  40.76149° N, 73.96142° W
  40.77111° N, 73.95362° W
  40.80260° N, 73.93061° W
  40.80409° N, 73.92893° W
  40.81432° N, 73.93292° W
  40.80325° N, 73.94472° W
  40.77392° N, 73.96917° W
  40.77293° N, 73.97671° W
  ---
  Berlin, €100
  13.36015° N, 52.51516° E
  13.33999° N, 52.51381° E
  13.32539° N, 52.51797° E
  13.33696° N, 52.52507° E
  13.36454° N, 52.52278° E
  13.38152° N, 52.52295° E
  13.40072° N, 52.52969° E
  13.42555° N, 52.51508° E
  13.41858° N, 52.49862° E
  13.40929° N, 52.48882° E
  13.37968° N, 52.49247° E
  13.34898° N, 52.48942° E
  13.34103° N, 52.47626° E
  13.32851° N, 52.47122° E
  13.30852° N, 52.46797° E
  13.28742° N, 52.47214° E
  13.29091° N, 52.48270° E
  13.31084° N, 52.49275° E
  13.32052° N, 52.50190° E
  13.34577° N, 52.50134° E
  13.36903° N, 52.50701° E
  13.39155° N, 52.51046° E
  13.37256° N, 52.51598° E
  ---
  London, £500
  51.48205° N, 0.04283° E
  51.47439° N, 0.02170° E
  51.47618° N, 0.02199° E
  51.49295° N, 0.05658° E
  51.47542° N, 0.03019° E
  51.47537° N, 0.03015° E
  51.47435° N, 0.03733° E
  51.47954° N, 0.04866° E
  51.48604° N, 0.06293° E
  51.49314° N, 0.06104° E
  51.49248° N, 0.04740° E
  51.48888° N, 0.03564° E
  51.48655° N, 0.01830° E
  51.48085° N, 0.02223° W
  51.49210° N, 0.04510° W
  51.49324° N, 0.04699° W
  51.50959° N, 0.05491° W
  51.50961° N, 0.05390° W
  51.49950° N, 0.01356° W
  51.50898° N, 0.02341° W
  51.51069° N, 0.04225° W
  51.51056° N, 0.04353° W
  51.50946° N, 0.07810° W
  51.51121° N, 0.09786° W
  51.50964° N, 0.11870° W
  51.50273° N, 0.13850° W
  51.50095° N, 0.12411° W
  """

struct Race {
  let location: String
  let entranceFee: Money
  let path: [Coordinate]
}


let locationName = Parser.prefix(while: { $0 != "," })

let race = locationName.map(String.init)
  .skip(",")
  .skip(zeroOrMoreSpaces)
  .take(money)
  .skip("\n")
  .take(coord.zeroOrMore(separatedBy: "\n"))
  .map(Race.init(location:entranceFee:path:))

let races = race.zeroOrMore(separatedBy: "\n---\n")

races.run(upcomingRaces[...])



let logs = """
Test Suite 'All tests' started at 2020-08-19 12:36:12.062
Test Suite 'VoiceMemosTests.xctest' started at 2020-08-19 12:36:12.062
Test Suite 'VoiceMemosTests' started at 2020-08-19 12:36:12.062
Test Case '-[VoiceMemosTests.VoiceMemosTests testDeleteMemo]' started.
Test Case '-[VoiceMemosTests.VoiceMemosTests testDeleteMemo]' passed (0.004 seconds).
Test Case '-[VoiceMemosTests.VoiceMemosTests testDeleteMemoWhilePlaying]' started.
Test Case '-[VoiceMemosTests.VoiceMemosTests testDeleteMemoWhilePlaying]' passed (0.002 seconds).
Test Case '-[VoiceMemosTests.VoiceMemosTests testPermissionDenied]' started.
/Users/point-free/projects/swift-composable-architecture/Examples/VoiceMemos/VoiceMemosTests/VoiceMemosTests.swift:107: error: -[VoiceMemosTests.VoiceMemosTests testPermissionDenied] : XCTAssertTrue failed
Test Case '-[VoiceMemosTests.VoiceMemosTests testPermissionDenied]' failed (0.003 seconds).
Test Case '-[VoiceMemosTests.VoiceMemosTests testPlayMemoFailure]' started.
Test Case '-[VoiceMemosTests.VoiceMemosTests testPlayMemoFailure]' passed (0.002 seconds).
Test Case '-[VoiceMemosTests.VoiceMemosTests testPlayMemoHappyPath]' started.
Test Case '-[VoiceMemosTests.VoiceMemosTests testPlayMemoHappyPath]' passed (0.002 seconds).
Test Case '-[VoiceMemosTests.VoiceMemosTests testRecordMemoFailure]' started.
/Users/point-free/projects/swift-composable-architecture/Examples/VoiceMemos/VoiceMemosTests/VoiceMemosTests.swift:144: error: -[VoiceMemosTests.VoiceMemosTests testRecordMemoFailure] : State change does not match expectation: …

      VoiceMemosState(
    −   alert: nil,
    +   alert: AlertState<VoiceMemosAction>(
    +     title: "Voice memo recording failed.",
    +     message: nil,
    +     primaryButton: nil,
    +     secondaryButton: nil
    +   ),
        audioRecorderPermission: RecorderPermission.allowed,
        currentRecording: nil,
        voiceMemos: [
        ]
      )

(Expected: −, Actual: +)
Test Case '-[VoiceMemosTests.VoiceMemosTests testRecordMemoFailure]' failed (0.009 seconds).
Test Case '-[VoiceMemosTests.VoiceMemosTests testRecordMemoHappyPath]' started.
/Users/point-free/projects/swift-composable-architecture/Examples/VoiceMemos/VoiceMemosTests/VoiceMemosTests.swift:56: error: -[VoiceMemosTests.VoiceMemosTests testRecordMemoHappyPath] : State change does not match expectation: …

      VoiceMemosState(
        alert: nil,
        audioRecorderPermission: RecorderPermission.allowed,
        currentRecording: CurrentRecording(
          date: 2001-01-01T00:00:00Z,
    −     duration: 3.0,
    +     duration: 2.0,
          mode: Mode.recording,
          url: file:///tmp/DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF.m4a
        ),
        voiceMemos: [
        ]
      )

(Expected: −, Actual: +)
Test Case '-[VoiceMemosTests.VoiceMemosTests testRecordMemoHappyPath]' failed (0.006 seconds).
Test Case '-[VoiceMemosTests.VoiceMemosTests testStopMemo]' started.
Test Case '-[VoiceMemosTests.VoiceMemosTests testStopMemo]' passed (0.001 seconds).
Test Suite 'VoiceMemosTests' failed at 2020-08-19 12:36:12.094.
   Executed 8 tests, with 3 failures (0 unexpected) in 0.029 (0.032) seconds
Test Suite 'VoiceMemosTests.xctest' failed at 2020-08-19 12:36:12.094.
   Executed 8 tests, with 3 failures (0 unexpected) in 0.029 (0.032) seconds
Test Suite 'All tests' failed at 2020-08-19 12:36:12.095.
   Executed 8 tests, with 3 failures (0 unexpected) in 0.029 (0.033) seconds
2020-08-19 12:36:19.538 xcodebuild[45126:3958202] [MT] IDETestOperationsObserverDebug: 14.165 elapsed -- Testing started completed.
2020-08-19 12:36:19.538 xcodebuild[45126:3958202] [MT] IDETestOperationsObserverDebug: 0.000 sec, +0.000 sec -- start
2020-08-19 12:36:19.538 xcodebuild[45126:3958202] [MT] IDETestOperationsObserverDebug: 14.165 sec, +14.165 sec -- end

Test session results, code coverage, and logs:
  /Users/point-free/Library/Developer/Xcode/DerivedData/ComposableArchitecture-fnpkwoynrpjrkrfemkkhfdzooaes/Logs/Test/Test-VoiceMemos-2020.08.19_12-35-57--0400.xcresult

Failing tests:
  VoiceMemosTests:
    VoiceMemosTests.testPermissionDenied()
    VoiceMemosTests.testRecordMemoFailure()
    VoiceMemosTests.testRecordMemoHappyPath()

"""

let testCaseFinishedLine = Parser
  .skip(.prefix(through: " ("))
  .take(.double)
  .skip(" seconds).\n")

testCaseFinishedLine.run("""
Test Case '-[VoiceMemosTests.VoiceMemosTests testPermissionDenied]' failed (0.003 seconds).

""")

let testCaseStartedLine = Parser
  .skip(.prefix(upTo: "Test Case '-["))
  .take(.prefix(through: "\n"))
  .map { line in
    line.split(separator: " ")[3].dropLast(2)
  }

let fileName = Parser
  .skip("/")
  .take(.prefix(through: ".swift"))
  .flatMap { path in
    path.split(separator: "/").last.map(Parser.always)
      ?? .never
  }

let testCaseBody = fileName
  .skip(":")
  .take(.int)
  .skip(.prefix(through: "] : "))
  .take(Parser.prefix(upTo: "Test Case '-[").map { $0.dropLast() })

testCaseBody.run("""
/Users/point-free/projects/swift-composable-architecture/Examples/VoiceMemos/VoiceMemosTests/VoiceMemosTests.swift:107: error: -[VoiceMemosTests.VoiceMemosTests testPermissionDenied] : XCTAssertTrue failed
Test Case '-[VoiceMemosTests.VoiceMemosTests testPermissionDenied]' failed (0.003 seconds).
""")

fileName.run("/Users/point-free/projects/swift-composable-architecture/Examples/VoiceMemos/VoiceMemosTests/VoiceMemosTests.swift:107: error: -[VoiceMemosTests.VoiceMemosTests testPermissionDenied] : XCTAssertTrue failed")

enum TestResult {
  case failed(failureMessage: Substring, file: Substring, line: Int, testName: Substring, time: TimeInterval)
  case passed(testName: Substring, time: TimeInterval)
}

let testFailed = testCaseStartedLine
  .take(testCaseBody)
  .take(testCaseFinishedLine)
  .map { testName, bodyData, time in
    TestResult.failed(failureMessage: bodyData.2, file: bodyData.0, line: bodyData.1, testName: testName, time: time)
  }

let testPassed = testCaseStartedLine
  .take(testCaseFinishedLine)
  .map(TestResult.passed(testName:time:))

let testResult = Parser.oneOf(testFailed, testPassed)

let testResults = testResult.zeroOrMore()

testResults.run(logs[...])

testCaseStartedLine.run(logs[...])

//VoiceMemoTests.swift:123, testDelete failed in 2.00 seconds.
//  ┃
//  ┃  XCTAssertTrue failed
//  ┃
//  ┗━━──────────────
func format(result: TestResult) -> String {
  switch result {
  case .failed(failureMessage: let failureMessage, file: let file, line: let line, testName: let testName, time: let time):
    var output = "\(file):\(line), \(testName) failed in \(time) seconds."
    output.append("\n")
    output.append("  ┃")
    output.append("\n")
    output.append(
      failureMessage
        .split(separator: "\n")
        .map { "  ┃  \($0)" }
        .joined(separator: "\n")
    )
    output.append("\n")
    output.append("  ┃")
    output.append("\n")
    output.append("  ┗━━──────────────")
    output.append("\n")
    return output
  case .passed(testName: let testName, time: let time):
    return "\(testName) passed in \(time) seconds."
  }
}

format(result: .failed(failureMessage: "XCTAssertTrue failed", file: "VoiceMemosTest.swift", line: 123, testName: "testFailed", time: 0.03))
