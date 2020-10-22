
Int.init as (String) -> Int?

Int("42")
Int("Blob")

Double.init as (String) -> Double?

Double("42.42")
Double("Blob")

Bool.init as (String) -> Bool?

Bool("true")
Bool("false")
Bool("1")
Bool("tru")
Bool("verdad")

import Foundation

URL.init(string:) as (String) -> URL?

URL(string: "https://www.pointfree.co")
URL(string: "bad^website")


URLComponents.init(string:) as (String) -> URLComponents?
UUID.init(uuidString:) as (String) -> UUID?

//import UIKit
//
//NSCoder.cgRect(for: "{{1,2},{3,4}}")
//NSCoder.cgRect(for: "")
//NSCoder.uiEdgeInsets(for: "{1,2,3,4}")
//NSCoder.uiEdgeInsets(for: "")

DateFormatter().date(from:) as (String) -> Date?
NumberFormatter().number(from:) as (String) -> NSNumber?

// (String) -> A?
// (String) -> (match: A?, rest: String)
// (inout String) -> A?
// (inout Substring) -> A?

struct Parser<Output> {
  let run: (inout Substring) -> Output?
}
// Parser<Int>.int
// .int
extension Parser where Output == Int {
  static let int = Self { input in
    let original = input
    
    let sign: Int // +1, -1
    if input.first == "-" {
      sign = -1
      input.removeFirst()
    } else if input.first == "+" {
      sign = 1
      input.removeFirst()
    } else {
      sign = 1
    }
    
    let intPrefix = input.prefix(while: \.isNumber)
    guard let match = Int(intPrefix)
    else {
      input = original
      return nil
    }
    input.removeFirst(intPrefix.count)
    return match * sign
  }
}

var input = "123 Hello"[...]
//var input: Substring = "123 Hello"
//var input = "123 Hello" as Substring

Parser.int.run(&input)
input

extension Parser {
  func run(_ input: String) -> (match: Output?, rest: Substring) {
    var input = input[...]
    let match = self.run(&input)
    return (match, input)
  }
}

Parser.int.run("123 Hello")
Parser.int.run("+123 Hello")
Parser.int.run("Hello Blob")
Parser.int.run("-123 Hello")
Parser.int.run("-Hello")


extension Parser where Output == Double {
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
Parser.double.run("42 hello")
Parser.double.run("4.2 hello")
Parser.double.run("42. hello")
Parser.double.run(".42 hello")

Parser.double.run("-42 hello")
Parser.double.run("+42 hello")
Parser.double.run("1.2.3 hello")


extension Parser where Output == Character {
  static let char = Self { input in
    guard !input.isEmpty else { return nil }
    return input.removeFirst()
  }
}

Parser.char.run("Hello Blob")
Parser.char.run("")


extension Parser where Output == Void {
  static func prefix(_ p: String) -> Self {
    Self { input in
      guard input.hasPrefix(p) else { return nil }
      input.removeFirst(p.count)
      return ()
    }
  }
}

Parser.prefix("Hello").run("Hello Blob")

extension Parser {
  func map<NewOutput>(_ f: @escaping (Output) -> NewOutput) -> Parser<NewOutput> {
    .init { input in
      self.run(&input).map(f)
    }
  }
}

let even = Parser.int.map { $0.isMultiple(of: 2) }

even.run("123 Hello")
even.run("124 Hello")


extension Parser {
  func flatMap<NewOutput>(
    _ f: @escaping (Output) -> Parser<NewOutput>
  ) -> Parser<NewOutput> {
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

extension Parser {
  static func always(_ output: Output) -> Self {
    Self { _ in output }
  }

  static var never: Self {
    Self { _ in nil }
  }
}

let evenInt = Parser.int
  .flatMap { n in
    n.isMultiple(of: 2)
      ? .always(n)
      : .never
  }

evenInt.run("123 Hello")
evenInt.run("124 Hello")


func zip<Output1, Output2>(
  _ p1: Parser<Output1>,
  _ p2: Parser<Output2>
) -> Parser<(Output1, Output2)> {

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

"100°F"

let temperature = zip(.int, "°F")
  .map { temperature, _ in temperature }

temperature.run("100°F")
temperature.run("-100°F")

"40.446° N"
"40.446° S"

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


func zip<Output1, Output2, Output3>(
  _ p1: Parser<Output1>,
  _ p2: Parser<Output2>,
  _ p3: Parser<Output3>
) -> Parser<(Output1, Output2, Output3)> {
  zip(p1, zip(p2, p3))
    .map { output1, output23 in (output1, output23.0, output23.1) }
}

let latitude = zip(.double, "° ", northSouth)
  .map { latitude, _, latSign in
    latitude * latSign
  }

let longitude = zip(.double, "° ", eastWest)
  .map { longitude, _, longSign in
    longitude * longSign
  }

"40.446° N, 79.982° W"

struct Coordinate {
  let latitude: Double
  let longitude: Double
}

extension Parser: ExpressibleByUnicodeScalarLiteral where Output == Void {
  typealias UnicodeScalarLiteralType = StringLiteralType
}

extension Parser: ExpressibleByExtendedGraphemeClusterLiteral where Output == Void {
  typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
}

extension Parser: ExpressibleByStringLiteral where Output == Void {
  typealias StringLiteralType = String
  
  init(stringLiteral value: String) {
    self = .prefix(value)
  }
}

let coord = zip(
  latitude,
  ", ",
  longitude
)
  .map { lat, _, long in
    Coordinate(latitude: lat, longitude: long)
  }


enum Currency { case eur, gbp, usd }

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


let currency = Parser.oneOf(
  Parser.prefix("€").map { Currency.eur },
  Parser.prefix("£").map { .gbp },
  Parser.prefix("$").map { .usd }
)

"$100"


struct Money {
  let currency: Currency
  let value: Double
}

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

extension Parser where Output == Substring {
  static func prefix(while p: @escaping (Character) -> Bool) -> Self {
    Self { input in
      let output = input.prefix(while: p)
      input.removeFirst(output.count)
      return output
    }
  }
}

//let locationName = Parser.prefix(while: { $0 != "," })

func zip<A, B, C, D>(
  _ a: Parser<A>,
  _ b: Parser<B>,
  _ c: Parser<C>,
  _ d: Parser<D>
) -> Parser<(A, B, C, D)> {
  zip(a, zip(b, c, d))
    .map { a, bcd in (a, bcd.0, bcd.1, bcd.2) }
}
func zip<A, B, C, D, E>(
  _ a: Parser<A>,
  _ b: Parser<B>,
  _ c: Parser<C>,
  _ d: Parser<D>,
  _ e: Parser<E>
) -> Parser<(A, B, C, D, E)> {
  zip(a, zip(b, c, d, e))
    .map { a, bcde in (a, bcde.0, bcde.1, bcde.2, bcde.3) }
}

extension Parser {
  func zeroOrMore(
    separatedBy separator: Parser<Void> = ""
  ) -> Parser<[Output]> {
    Parser<[Output]> { input in
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

let race = zip(
  .prefix(while: { $0 != "," }),
  ", ",
  money,
  "\n",
  coord.zeroOrMore(separatedBy: "\n")
)
.map { locationName, _, entranceFee, _, path in
  Race(
    location: String(locationName),
    entranceFee: entranceFee,
    path: path
  )
}

let races = race.zeroOrMore(separatedBy: "\n---\n")

dump(
races.run(upcomingRaces)
)

// coord.zeroOrMore()

extension Parser where Output == Substring {
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

let logs = """
2020-08-19 12:36:07.528 xcodebuild[45126:3958202] [MT] IDETestOperationsObserverDebug: (444776CA-26EF-481A-8BF7-DC816C5C4DD0) Finished requesting crash reports. Continuing with testing.
2020-08-19 12:36:11.698683-0400 VoiceMemos[45357:3964974] Launching with XCTest injected. Preparing to run tests.
2020-08-19 12:36:11.708349-0400 VoiceMemos[45357:3964974] Waiting to run tests until the app finishes launching.
Test Suite 'All tests' started at 2020-08-19 12:36:12.062
Test Suite 'VoiceMemosTests.xctest' started at 2020-08-19 12:36:12.062
Test Suite 'VoiceMemosTests' started at 2020-08-19 12:36:12.062


Test Case '-[VoiceMemosTests.VoiceMemosTests testPermissionDenied]' started.
/Users/point-free/projects/swift-composable-architecture/Examples/VoiceMemos/VoiceMemosTests/VoiceMemosTests.swift:107: error: -[VoiceMemosTests.VoiceMemosTests testPermissionDenied] : XCTAssertTrue failed
Test Case '-[VoiceMemosTests.VoiceMemosTests testPermissionDenied]' failed (0.003 seconds).
Test Case '-[VoiceMemosTests.VoiceMemosTests testPlayMemoFailure]' started.
Test Case '-[VoiceMemosTests.VoiceMemosTests testPlayMemoFailure]' passed (0.002 seconds).
Test Case '-[VoiceMemosTests.VoiceMemosTests testPlayMemoHappyPath]' started.
Test Case '-[VoiceMemosTests.VoiceMemosTests testPlayMemoHappyPath]' passed (0.002 seconds).
"""

let testCaseStartedLine = zip(
  .prefix(upTo: "Test Case '-["),
  .prefix(through: "\n")
).map { _, line in
  line.split(separator: " ")[3].dropLast(2)
}
//  Parser<Substring> { input in
//  guard let startIndex = input.range(of: "Test Case '-[")?.lowerBound
//  else { return nil }
//
//  guard let newlineRange = input.range(of: "\n", range: startIndex..<input.endIndex)
//  else { return nil }
//
//  let line = input[startIndex..<newlineRange.lowerBound]
//
//  input = input[newlineRange.upperBound...]
//
//  return line.split(separator: " ")[3].dropLast(2)
//}

let testCaseBody = Parser<Substring> { input in
  guard let endIndex = input.range(of: "Test Case '-[")?.lowerBound
  else { return nil }
  
  let body = input[..<endIndex].dropLast()
  
  input = input[endIndex...]
  
  return body
}

["a", "b", "c"].prefix(upTo: 2)
["a", "b", "c"].prefix(through: 2)

let fileName = Parser.prefix(through: ".swift")
  .flatMap { path in
    path.split(separator: "/").last.map(Parser.always)
      ?? .never
  }
//  Parser<Substring> { input in
//  guard let endIndex = input.range(of: ".swift")?.upperBound
//  else { return nil }
//
//  let path = input[..<endIndex]
//  guard let filePath = path.split(separator: "/").last
//  else { return nil }
//
//  input = input[endIndex...]
//
//  return filePath
//}

fileName.run("/Users/point-free/projects/swift-composable-architecture/Examples/VoiceMemos/VoiceMemosTests/VoiceMemosTests.swift:107: error: -[VoiceMemosTests.VoiceMemosTests testPermissionDenied] : XCTAssertTrue failed")

enum TestResult {
  case failed(failureMessage: Substring, file: Substring, line: Int, testName: Substring, time: TimeInterval)
  case passed(testName: Substring, time: TimeInterval)
}

let testResult: Parser<TestResult> = .never
let testResults: Parser<[TestResult]> = testResult.zeroOrMore()


testCaseStartedLine.run(logs)


