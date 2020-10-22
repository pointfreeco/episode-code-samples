
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

import UIKit

NSCoder.cgRect(for: "{{1,2},{3,4}}")
NSCoder.cgRect(for: "")
NSCoder.uiEdgeInsets(for: "{1,2,3,4}")
NSCoder.uiEdgeInsets(for: "")

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
