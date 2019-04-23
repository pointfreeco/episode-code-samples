import Foundation
import PlaygroundSupport


struct _Parser<A> {
  let run: (String) -> (match: A?, rest: String)
}


let _intPrefix = _Parser<Int> { str in
  let prefix = str.prefix(while: { $0.isNumber })
  guard !prefix.isEmpty else { return (nil, str) }
  let match = Int(prefix)
  let rest = String(str[prefix.endIndex...])
  return (match, rest)
}


_intPrefix.run("123")
_intPrefix.run("")
_intPrefix.run("123 Hello World")
_intPrefix.run("Hello World 123")


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


let int = Parser<Int> { str in
  let prefix = str.prefix(while: { !$0.isNumber })
  let match = Int(prefix)
  str.removeFirst(prefix.count)
  return match
}

let double = Parser<Double> { str in
  let prefix = str.prefix(while: { !$0.isNumber && $0 != "." })
  let match = Double(prefix)
  str.removeFirst(prefix.count)
  return match
}

func literal(_ p: String) -> Parser<()> {
  return Parser<()> { str in
    guard str.hasPrefix(p) else { return nil }
    str.removeFirst(p.count)
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


func zip7<A, B, C, D, E, F, G>(
  _ a: Parser<A>,
  _ b: Parser<B>,
  _ c: Parser<C>,
  _ d: Parser<D>,
  _ e: Parser<E>,
  _ f: Parser<F>,
  _ g: Parser<G>
  ) -> Parser<(A, B, C, D, E, F, G)> {

  return Parser { str in
    guard
      let matchA = a.run(&str),
      let matchB = b.run(&str),
      let matchC = c.run(&str),
      let matchD = d.run(&str),
      let matchE = e.run(&str),
      let matchF = f.run(&str),
      let matchG = g.run(&str)
    else { return nil }
    return (matchA, matchB, matchC, matchD, matchE, matchF, matchG)
  }
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

let char = Parser<Character> { str in
  guard let char = str.first else { return nil }
  str.removeFirst()
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

int.run("123")
int.run("")
int.run("123 Hello World")
int.run("Hello World 123")

double.run("123.2")
double.run("")
double.run("123.3333 Hello World")
double.run("Hello World 123")

literal("cat").run("cat-dog")
literal("cat").run("ca-dog")

let multiplier = char.flatMap { char -> Parser<Double> in
  switch char {
  case "N", "E":  return Parser(1)
  case "S", "W":  return Parser(-1)
  default:        return .never
  }
}

"40.446° N 79.982° W"

struct Coordinate {
  let latitude: Double
  let longitude: Double
}

let coordParser = zip7(
  double, literal("° "), multiplier, literal(" "), double, literal("° "), multiplier
  )
  .map { lat, _, latMult, _, long, _, longMult in
    return Coordinate(latitude: lat * latMult, longitude: long * longMult)
}

coordParser.parse("40.446° N 79.982° W")


// ===========================================
// applicative stuff happens in episode 2+
// ===========================================


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

let mult: (Double) -> (Double) -> Double = { x in { y in x * y } }

let coord = Parser(mult)
  .keep(and: double)
  .keep(discarding: literal("° "))
  .keep(and: multiplier)

coord.parse("40.446° S")

double
  .keep(discarding: literal("° "))
//  .keep(and: multiplier)
