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

// flatMap: ((A) -> M<B>) -> (M<A>) -> M<B>


extension Parser {
  func flatMap<B>(_ f: @escaping (A) -> Parser<B>) -> Parser<B> {
    return Parser<B> { str -> B? in
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


//let eastWest = Parser<Double> { str in
//  guard
//    let cardinal = str.first,
//    cardinal == "E" || cardinal == "W"
//    else { return nil }
//  str.removeFirst(1)
//  return cardinal == "E" ? 1 : -1
//}

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


"40.6782° N, 73.9442° W"

let coord = double
  .flatMap { lat in
    literal("° ")
      .flatMap { _ in
        northSouth
          .flatMap { latSign in
            literal(", ")
              .flatMap { _ in
                double
                  .flatMap { long in
                    literal("° ")
                      .flatMap { _ in
                        eastWest
                          .map { longSign in
                            return Coordinate(
                              latitude: lat * latSign,
                              longitude: long * longSign
                            )
                        }
                    }
                }
            }
        }
    }
}

coord.run("40.6782° N, 73.9442° W")
coord.run("40.6782° Z, 73.9442° W")


// zip: (F<A>, F<B>) -> F<(A, B)>

func zip<A, B>(_ a: Parser<A>, _ b: Parser<B>) -> Parser<(A, B)> {
  return Parser<(A, B)> { str -> (A, B)? in
    let original = str
    guard let matchA = a.run(&str) else { return nil }
    guard let matchB = b.run(&str) else {
      str = original
      return nil
    }
    return (matchA, matchB)
  }
}


"$10"
"€10"


enum Currency {
  case eur
  case gbp
  case usd
}

let currency = char.flatMap {
  $0 == "€" ? always(Currency.eur)
    : $0 == "£" ? always(.gbp)
    : $0 == "$" ? always(.usd)
    : .never
}


struct Money {
  let currency: Currency
  let value: Double
}

let money = zip(currency, double).map(Money.init)
money.run("$10")
money.run("£10")
money.run("€10")
money.run("฿10")

"40.6782° N, 73.9442° W"

zip(zip(double, literal("° ")), northSouth)

func zip<A, B, C>(
  _ a: Parser<A>,
  _ b: Parser<B>,
  _ c: Parser<C>
  ) -> Parser<(A, B, C)> {
  return zip(a, zip(b, c))
    .map { a, bc in (a, bc.0, bc.1) }
}

zip(double, literal("° "), northSouth)

zip(zip(double, literal("° "), northSouth), literal(", "))

func zip<A, B, C, D>(
  _ a: Parser<A>,
  _ b: Parser<B>,
  _ c: Parser<C>,
  _ d: Parser<D>
  ) -> Parser<(A, B, C, D)> {
  return zip(a, zip(b, c, d))
    .map { a, bcd in (a, bcd.0, bcd.1, bcd.2) }
}

zip(double, literal("° "), northSouth, literal(", "))


func zip<A, B, C, D, E>(
  _ a: Parser<A>,
  _ b: Parser<B>,
  _ c: Parser<C>,
  _ d: Parser<D>,
  _ e: Parser<E>
  ) -> Parser<(A, B, C, D, E)> {

  return zip(a, zip(b, c, d, e))
    .map { a, bcde in (a, bcde.0, bcde.1, bcde.2, bcde.3) }
}
func zip<A, B, C, D, E, F>(
  _ a: Parser<A>,
  _ b: Parser<B>,
  _ c: Parser<C>,
  _ d: Parser<D>,
  _ e: Parser<E>,
  _ f: Parser<F>
  ) -> Parser<(A, B, C, D, E, F)> {

  return zip(a, zip(b, c, d, e, f))
    .map { a, bcdef in (a, bcdef.0, bcdef.1, bcdef.2, bcdef.3, bcdef.4) }
}
func zip<A, B, C, D, E, F, G>(
  _ a: Parser<A>,
  _ b: Parser<B>,
  _ c: Parser<C>,
  _ d: Parser<D>,
  _ e: Parser<E>,
  _ f: Parser<F>,
  _ g: Parser<G>
  ) -> Parser<(A, B, C, D, E, F, G)> {

  return zip(a, zip(b, c, d, e, f, g))
    .map { a, bcdefg in (a, bcdefg.0, bcdefg.1, bcdefg.2, bcdefg.3, bcdefg.4, bcdefg.5) }
}

"40.6782° N, 73.9442° W"



func parseLatLongHandRolled(_ string: String) -> Coordinate? {
  let parts = string.split(separator: " ")
  guard parts.count == 4 else { return nil }
  guard
    let lat = Double(parts[0].dropLast()),
    let long = Double(parts[2].dropLast())
    else { return nil }
  let latCard = parts[1].dropLast()
  guard latCard == "N" || latCard == "S" else { return nil }
  let longCard = parts[3]
  guard longCard == "E" || longCard == "W" else { return nil }
  let latSign = latCard == "N" ? 1.0 : -1
  let longSign = longCard == "E" ? 1.0 : -1
  return Coordinate(latitude: lat * latSign, longitude: long * longSign)
}

parseLatLongHandRolled("40.446° N, 79.982° W")



func parseLatLongWithScanner(_ string: String) -> Coordinate? {
  let scanner = Scanner(string: string)

  var lat: Double = 0
  var northSouth: NSString? = ""
  var long: Double = 0
  var eastWest: NSString? = ""

  guard
    scanner.scanDouble(&lat),
    scanner.scanString("° ", into: nil),
    scanner.scanCharacters(from: ["N", "S"], into: &northSouth),
    scanner.scanString(", ", into: nil),
    scanner.scanDouble(&long),
    scanner.scanString("° ", into: nil),
    scanner.scanCharacters(from: ["E", "W"], into: &eastWest)
    else { return nil }

  let latSign = northSouth == "N" ? 1.0 : -1
  let longSign = eastWest == "E" ? 1.0 : -1

  return Coordinate(latitude: lat * latSign, longitude: long * longSign)
}

parseLatLongWithScanner("40.446° N, 79.982° W")

let northSouth = char
  .flatMap {
    $0 == "N" ? always(1.0)
      : $0 == "S" ? always(-1)
      : .never
}
let eastWest = char
  .flatMap {
    $0 == "E" ? always(1.0)
      : $0 == "W" ? always(-1)
      : .never
}
let latitude = zip(double, literal("° "), northSouth)
  .map { lat, _, latSign in lat * latSign }
let longitude = zip(double, literal("° "), eastWest)
  .map { long, _, longSign in long * longSign }
let coord2 = zip(latitude, literal(", "), longitude)
  .map { lat, _, long in
    Coordinate(
      latitude: lat,
      longitude: long
    )
}

