import Foundation
import PlaygroundSupport



struct Parser<A> {
  let run: (inout String) -> A?

  func run(_ str: String) -> (rest: String, match: A?) {
    var str = str
    let a = self.run(&str)
    return (str, a)
  }

  func parse(_ string: String) -> A? {
    guard
      case let (rest, .some(match)) = self.run(string)
      else { return nil }
    guard rest == "" else { return nil }
    return match
  }
}


let intPrefix = Parser<Int> { str in
  let index = str.firstIndex(where: { !$0.isNumber }) ?? str.endIndex
  let result = Int(str[..<index])
  str.removeSubrange(str.startIndex ..< index)
  return result
}

let doublePrefix = Parser<Double> { str in
  let index = str.firstIndex(where: { !$0.isNumber && $0 != "." }) ?? str.endIndex
  let result = Double(str[..<index])
  str.removeSubrange(str.startIndex ..< index)
  return result
}

func prefix(_ p: String) -> Parser<()> {
  return Parser<()> { str in
    guard str.hasPrefix(p) else { return nil }
    str.removeSubrange(str.startIndex ..< str.index(str.startIndex, offsetBy: p.count))
    return ()
  }
}

func zip<A, B, C>(
  with f: @escaping (A, B) -> C,
  _ a: Parser<A>,
  _ b: Parser<B>
  ) -> Parser<C> {
  return Parser<C> { str in
    guard
      let matchA = a.run(&str),
      let matchB = b.run(&str)
      else { return nil }
    return f(matchA, matchB)
  }
}

func zip<A, B>(_ a: Parser<A>, _ b: Parser<B>) -> Parser<(A, B)> {
  return zip(with: { ($0, $1) }, a, b)
}


extension Parser {
  func map<B>(_ f: @escaping (A) -> B) -> Parser<B> {
    return Parser<B> { str in
      let match = self.run(&str)
      return match.map(f)
    }
  }

  func flatMap<B>(_ f: @escaping (A) -> Parser<B>) -> Parser<B> {
    return Parser<B> { str in
      guard let matchA = self.run(&str) else { return nil }
      let parserB = f(matchA)
      return parserB.run(&str)
    }
  }
}

extension Parser {
  func apply<B, C>(_ b: Parser<B>) -> Parser<C> where A == (B) -> C {
    return zip(self, b).map { f, b in f(b) }
  }

  func keep<B, C>(and b: Parser<B>) -> Parser<C> where A == (B) -> C {
    return self.apply(b)
  }

  func keep<B>(discarding b: Parser<B>) -> Parser<A> {
    return zip(self, b).map { a, _ in a }
  }

  func discard<B>(keeping b: Parser<B>) -> Parser<B> {
    return zip(self, b).map { _, b in b }
  }
}

let char = Parser<Character> { str in
  guard let char = str.first else { return nil }
  str.remove(at: str.startIndex)
  return char
}

extension Parser {
  static var never: Parser {
    return Parser { _ in nil }
  }

  init(_ a: A) {
    self = Parser { _ in a }
  }
}

intPrefix.run("123")
intPrefix.run("")
intPrefix.run("123 Hello World")
intPrefix.run("Hello World 123")

doublePrefix.run("123.2")
doublePrefix.run("")
doublePrefix.run("123.3333 Hello World")
doublePrefix.run("Hello World 123")

prefix("cat").run("cat-dog")
prefix("cat").run("ca-dog")

let multiplier = char.flatMap { char -> Parser<Int> in
  switch char {
  case "N", "E":  return Parser(1)
  case "S", "W":  return Parser(-1)
  default:        return .never
  }
}

"40.446° N 79.982° W"



let mult: (Double) -> (Double) -> Double = { x in { y in x * y } }

let coord = Parser(mult)
  .keep(and: doublePrefix)
  .keep(discarding: prefix("° "))
  .keep(and: multiplier.map(Double.init))

coord.parse("40.446° S")

doublePrefix
  .keep(discarding: prefix("° "))
//  .keep(and: multiplier)
