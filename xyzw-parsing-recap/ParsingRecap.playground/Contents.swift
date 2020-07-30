
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

let int = Parser<Int> { input in
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

var input = "123 Hello"[...]
//var input: Substring = "123 Hello"
//var input = "123 Hello" as Substring

int.run(&input)
input

extension Parser {
  func run(_ input: String) -> (match: Output?, rest: Substring) {
    var input = input[...]
    let match = self.run(&input)
    return (match, input)
  }
}

int.run("123 Hello")
int.run("+123 Hello")
int.run("Hello Blob")
int.run("-123 Hello")
int.run("-Hello")
