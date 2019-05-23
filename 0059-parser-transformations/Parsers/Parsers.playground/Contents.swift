
Int("42")
Int("42-")
Double("42")
Double("42.32435")
Bool("true")
Bool("false")
Bool("f")

import Foundation

UUID.init(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")
UUID.init(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEE")
UUID.init(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEZ")

URL.init(string: "https://www.pointfree.co")
URL.init(string: "^https://www.pointfree.co")

let components = URLComponents.init(string: "https://www.pointfree.co?ref=twitter")
components?.queryItems

let df = DateFormatter()
df.timeStyle = .none
df.dateStyle = .short
type(of: df.date(from: "1/29/17"))
df.date(from: "-1/29/17")


let emailRegexp = try NSRegularExpression(pattern: #"\S+@\S+"#)
let emailString = "You're logged in as blob@pointfree.co"
let emailRange = emailString.startIndex..<emailString.endIndex
let match = emailRegexp.firstMatch(
  in: emailString,
  range: NSRange(emailRange, in: emailString)
  )!
emailString[Range(match.range(at: 0), in: emailString)!]

//let scanner = Scanner.init(string: "A42 Hello World")
//var int = 0
//scanner.scanInt(&int)
//int

// 40.6782° N, 73.9442° W
struct Coordinate {
  let latitude: Double
  let longitude: Double
}

//typealias Parser<A> = (String) -> A

struct Parser<A> {
//  let run: (String) -> A?
//  let run: (String) -> (match: A?, rest: String)
//  let run: (inout String) -> A?
  let run: (inout Substring) -> A?

  func run(_ str: String) -> (match: A?, rest: Substring) {
    var str = str[...]
    let match = self.run(&str)
    return (match, str)
  }
}

let int = Parser<Int> { str in
  let prefix = str.prefix(while: { $0.isNumber })
  guard let int = Int(prefix) else { return nil }
  str.removeFirst(prefix.count)
  return int
}

//Substring


int.run("42")
int.run("42 Hello World")
int.run("Hello World")

let double = Parser<Double> { str in
  let prefix = str.prefix(while: { $0.isNumber || $0 == "." })
  guard let match = Double(prefix) else { return nil }
  str.removeFirst(prefix.count)
  return match
}

double.run("42")
double.run("42.87432893247")
double.run("42.87432 Hello World")
double.run("42.4.1.4.6")

func literal(_ literal: String) -> Parser<Void> {
  return Parser<Void> { str in
    guard str.hasPrefix(literal) else { return nil }
    str.removeFirst(literal.count)
    return ()
  }
}

literal("cat").run("cat dog")
literal("cat").run("dog cat")

func always<A>(_ a: A) -> Parser<A> {
  return Parser<A> { _ in a }
}

always("cat").run("dog")

// let never<A> = Parser { ... }
func never<A>() -> Parser<A> {
  return Parser<A> { _ in nil }
}
extension Parser {
  static var never: Parser {
    return Parser { _ in nil }
  }
}
(never() as Parser<Int>).run("dog")
Parser<Int>.never.run("dog")


// (A)       -> A
// (inout A) -> Void



enum Route {
  case home
  case profile
  case episodes
  case episode(id: Int)
}

let router = Parser<Route> { str in
  fatalError()
}

//router.run("/") // .home
//router.run("/episodes/42") // .episode(42)

//switch router.run("/episodes/42") {
//case .none:
//case .some(.home):
//case .some(.profile):
//case .some(.episodes):
//case let .some(.episode(id)):
//}

enum EnumPropertyGenerator {
  case help
  case version
  case invoke(urls: [URL], dryRun: Bool)
}

let cli = Parser<EnumPropertyGenerator> { str in
  fatalError()
}

//cli.run("generate-enum-properties --version") // .version
//cli.run("generate-enum-properties --help") // .help
//cli.run("generate-enum-properties --dry-run /path/to/file.swift") // .invoke(["/path/to/file.swift"], dryRun: true)
//
//switch cli.run("generate-enum-properties --dry-run /path/to/file.swift") {
//case .help:
//case .version:
//case .invoke:
//case nil:
//}

let northSouth = Parser<Double> { str in
  guard
    let cardinal = str.first,
    cardinal == "N" || cardinal == "S"
    else { return nil }
  str.removeFirst(1)
  return cardinal == "N" ? 1 : -1
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


//  let parts = str.split(separator: " ")
//  guard parts.count == 4 else { return nil }
//  guard
//    let lat = Double(parts[0].dropLast()),
//    let long = Double(parts[2].dropLast())
//    else { return nil }
//  let latCard = parts[1].dropLast()
//  guard latCard == "N" || latCard == "S" else { return nil }
//  let longCard = parts[3]
//  guard longCard == "E" || longCard == "W" else { return nil }
//  let latSign = latCard == "N" ? 1.0 : -1
//  let longSign = longCard == "E" ? 1.0 : -1
//  return Coordinate(latitude: lat * latSign, longitude: long * longSign)
}

print(parseLatLong("40.6782° N, 73.9442° W"))




func parseLatLongWithScanner(_ string: String) -> Coordinate? {
  let scanner = Scanner(string: string)

  var lat: Double = 0
  guard scanner.scanDouble(&lat) else { return nil }

  guard scanner.scanString("° ", into: nil) else { return nil }

  var northSouth: NSString? = ""
  guard scanner.scanCharacters(from: ["N", "S"], into: &northSouth) else { return nil }
  let latSign = northSouth == "N" ? 1.0 : -1

  guard scanner.scanString(", ", into: nil) else { return nil }

  var long: Double = 0
  guard scanner.scanDouble(&long) else { return nil }

  guard scanner.scanString("° ", into: nil) else { return nil }

  var eastWest: NSString? = ""
  guard scanner.scanCharacters(from: ["E", "W"], into: &eastWest) else { return nil }
  let longSign = eastWest == "E" ? 1.0 : -1

  return Coordinate(latitude: lat * latSign, longitude: long * longSign)
}

var x: FixedWidthInteger

extension Parser {
  func map<B>(_ f: @escaping (A) -> B) -> Parser<B> {
    return Parser<B> { str in
      self.run(&str).map(f)
    }
  }

  func flatMap<B>(_ f: @escaping (A) -> Parser<B>) -> Parser<B> {
    return Parser<B> { str in
      let original = str
      let matchA = self.run(&str)
      let parserB = matchA.map(f)
      guard let matchB = parserB?.run(&str) else {
        str = original
        return nil
      }
      return matchB
    }
  }
}

func zip<A, B>(_ a: Parser<A>, _ b: Parser<B>) -> Parser<(A, B)> {
  return Parser<(A, B)> { str in
    guard
      let matchA = a.run(&str),
      let matchB = b.run(&str)
      else { return nil }
    return (matchA, matchB)
  }
}
func zip3<A, B, C>(
  _ a: Parser<A>,
  _ b: Parser<B>,
  _ c: Parser<C>
  ) -> Parser<(A, B, C)> {
  return Parser { str in
    guard
      let matchA = a.run(&str),
      let matchB = b.run(&str),
      let matchC = c.run(&str)
      else { return nil }
    return (matchA, matchB, matchC)
  }
}

let char = Parser<Character> { str in
  guard !str.isEmpty else { return nil }
  return str.removeFirst()
}

char
  .map { $0 == "N" ? 1.0 : -1.0 }

let tmp1 = char.flatMap {
  $0 == "N" ? always(1.0)
    : $0 == "S" ? always(-1)
    : .never
}

tmp1.run("E, 42")

let latCoord: Parser<Double> = zip3(double, literal("° "), northSouth)
  .map { lat, _, sign in lat * sign }
let longCoord: Parser<Double> = zip3(double, literal("° "), eastWest)
  .map { lat, _, sign in lat * sign }
let coord = zip3(latCoord, literal(", "), longCoord)
  .map { lat, _, long in Coordinate(latitude: lat, longitude: long) }

func pred(_ p: @escaping (Character) -> Bool) -> Parser<Void> {
  return Parser { str in
    str = str.suffix(from: str.prefix(while: p).endIndex)
    return ()
  }
}

let tmp = pred({ $0.isWhitespace })
  .run("  Hello")
tmp

2


struct Printer<A> {
  let run: (A) -> String

  func pullback<B>(_ f: @escaping (B) -> A) -> Printer<B> {
    return Printer<B> { b in
      self.run(f(b))
    }
  }
}

func contrazip<A, B, Z>(_ f: @escaping (Z) -> (A, B)) -> (Printer<A>, Printer<B>) -> Printer<Z> {
  return { printerA, printerB in
    return Printer<Z> { z in
      let (a, b) = f(z)
      return printerA.run(a) + printerB.run(b)
    }
  }
}
func contrazip7<A, B, C, D, E, F, G, Z>(
  _ f: @escaping (Z) -> (A, B, C, D, E, F, G)
  )
  -> (Printer<A>, Printer<B>, Printer<C>, Printer<D>, Printer<E>, Printer<F>, Printer<G>)
  -> Printer<Z> {
    return { printerA, printerB, printerC, printerD, printerE, printerF, printerG in
      return Printer<Z> { z in
        let (a, b, c, d, e, f, g) = f(z)
        return printerA.run(a)
          + printerB.run(b)
          + printerC.run(c)
          + printerD.run(d)
          + printerE.run(e)
          + printerF.run(f)
          + printerG.run(g)
      }
    }
}

extension Printer where A == Double {
  static let double = Printer<Double> { String($0) }
  static let northSouth = Printer<Double> { $0 >= 0 ? "N" : "S" }
  static let eastWest = Printer<Double> { $0 >= 0 ? "E" : "W" }
}
extension Printer where A == Void {
  static func literal(_ str: String) -> Printer<Void> {
    return Printer { _ in str }
  }
}

print(
contrazip7({ ($0.latitude, (), $0.latitude, (), $0.longitude, (), $0.longitude) })(
  .double,
  .literal("° "),
  .northSouth,
  .literal(", "),
  .double,
  .literal("° "),
  .eastWest
  )
  .run(Coordinate(latitude: 40.6782, longitude: -73.9442))
)

//"40.6782° N, 73.9442° W"
