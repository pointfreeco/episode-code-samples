
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

let temperature = zip(.int, .prefix("°F"))
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

let latitude = zip(.double, .prefix("° "), northSouth)
  .map { latitude, _, latSign in
    latitude * latSign
  }

let longitude = zip(.double, .prefix("° "), eastWest)
  .map { longitude, _, longSign in
    longitude * longSign
  }

"40.446° N, 79.982° W"

struct Coordinate {
  let latitude: Double
  let longitude: Double
}

let coord = zip(
  latitude,
  .prefix(", "),
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
