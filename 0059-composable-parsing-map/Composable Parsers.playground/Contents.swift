import Foundation

struct Parser<A> {
  let run: (inout Substring) -> A?
}

let int = Parser<Int> { str in
  let prefix = str.prefix(while: { $0.isNumber })
  guard let int = Int(prefix) else { return nil }
  str.removeFirst(prefix.count)
  return int
}

let double = Parser<Double> { str in
  let prefix = str.prefix(while: { $0.isNumber || $0 == "." })
  guard let match = Double(prefix) else { return nil }
  str.removeFirst(prefix.count)
  return match
}

func literal(_ literal: String) -> Parser<Void> {
  return Parser<Void> { str in
    guard str.hasPrefix(literal) else { return nil }
    str.removeFirst(literal.count)
    return ()
  }
}

func always<A>(_ a: A) -> Parser<A> {
  return Parser<A> { _ in a }
}

extension Parser {
  static var never: Parser {
    return Parser { _ in nil }
  }
}

struct Coordinate {
  let latitude: Double
  let longitude: Double
}


extension Parser {
  func run(_ str: String) -> (match: A?, rest: Substring) {
    var str = str[...]
    let match = self.run(&str)
    return (match, str)
  }
}


// map: ((A) -> B) -> (F<A>) -> F<B>

// F<A> = Parser<A>
// map: ((A) -> B) -> (Parser<A>) -> Parser<B>

// map(id) = id

[1, 2, 3]
  .map { $0 }

Optional("Blob")
  .map { $0 }


// map: (Parser<A>, (A) -> B) -> Parser<B>

extension Parser {
  func map<B>(_ f: @escaping (A) -> B) -> Parser<B> {
    return Parser<B> { str -> B? in
      self.run(&str).map(f)
    }
  }

  func fakeMap<B>(_ f: @escaping (A) -> B) -> Parser<B> {
    return Parser<B> { _ in nil }
  }
  func fakeMap2<B>(_ f: @escaping (A) -> B) -> Parser<B> {
    return Parser<B> { str in
      let matchB = self.run(&str).map(f)
      str = ""
      return matchB
    }
  }
}

int.map { $0 }
int.fakeMap { $0 }.run("123")
int
  .fakeMap2 { $0 }.run("123 Hello World")
int
  .run("123 Hello World")

let even = int.map { $0 % 2 == 0 }

even.run("123 Hello World")
even.run("42 Hello World")

let char = Parser<Character> { str in
  guard !str.isEmpty else { return nil }
  return str.removeFirst()
}

//let northSouth = Parser<Double> { str in
//  guard
//    let cardinal = str.first,
//    cardinal == "N" || cardinal == "S"
//    else { return nil }
//  str.removeFirst(1)
//  return cardinal == "N" ? 1 : -1
//}
let northSouth = char
  .map {
    $0 == "N" ? always(1.0)
      : $0 == "S" ? always(-1)
      : .never
}

let eastWest = Parser<Double> { str in
  guard
    let cardinal = str.first,
    cardinal == "E" || cardinal == "W"
    else { return nil }
  str.removeFirst(1)
  return cardinal == "E" ? 1 : -1
}

func parseLatLong(_ str: String) -> Coordinate? {
  var str = str[...]

  guard
    let lat = double.run(&str),
    literal("° ").run(&str) != nil,
    let latSign = northSouth.run(&str),
    literal(", ").run(&str) != nil,
    let long = double.run(&str),
    literal("° ").run(&str) != nil,
    let longSign = eastWest.run(&str)
    else { return nil }

  return Coordinate(
    latitude: lat * latSign,
    longitude: long * longSign
  )
}

print(String(describing: parseLatLong("40.6782° N, 73.9442° W")))
