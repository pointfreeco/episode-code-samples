
struct Parser<A> {
  let run: (inout Substring) -> A?
}

















let int = Parser<Int> { str in
  let prefix = str.prefix(while: { $0.isNumber })
  let match = Int(prefix)
  str.removeFirst(prefix.count)
  return match
}

let double = Parser<Double> { str in
  let prefix = str.prefix(while: { $0.isNumber || $0 == "." })
  let match = Double(prefix)
  str.removeFirst(prefix.count)
  return match
}

let char = Parser<Character> { str in
  guard !str.isEmpty else { return nil }
  return str.removeFirst()
}

func literal(_ p: String) -> Parser<Void> {
  return Parser<Void> { str in
    guard str.hasPrefix(p) else { return nil }
    str.removeFirst(p.count)
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





















extension Parser {
  func map<B>(_ f: @escaping (A) -> B) -> Parser<B> {
    return Parser<B> { str -> B? in
      self.run(&str).map(f)
    }
  }

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





func zip<A, B, C>(
  _ a: Parser<A>,
  _ b: Parser<B>,
  _ c: Parser<C>
  ) -> Parser<(A, B, C)> {
  return zip(a, zip(b, c))
    .map { a, bc in (a, bc.0, bc.1) }
}
func zip<A, B, C, D>(
  _ a: Parser<A>,
  _ b: Parser<B>,
  _ c: Parser<C>,
  _ d: Parser<D>
  ) -> Parser<(A, B, C, D)> {
  return zip(a, zip(b, c, d))
    .map { a, bcd in (a, bcd.0, bcd.1, bcd.2) }
}
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





















extension Parser {
  func run(_ str: String) -> (match: A?, rest: Substring) {
    var str = str[...]
    let match = self.run(&str)
    return (match, str)
  }
}





















// 40.446° N, 79.982° W
struct Coordinate {
  let latitude: Double
  let longitude: Double
}

func prefix(while p: @escaping (Character) -> Bool) -> Parser<Substring> {
  return Parser<Substring> { str in
    let prefix = str.prefix(while: p)
    str.removeFirst(prefix.count)
    return prefix
  }
}

let zeroOrMoreSpaces = prefix(
  while: { $0 == " " })
  .map { _ in () }
//  Parser<Void> { str -> Void? in
//  let prefix = str.prefix(while: { $0 == " " })
//  str.removeFirst(prefix.count)
//  return ()
//}
let oneOrMoreSpaces = prefix(
  while: { $0 == " " })
  .flatMap {
    $0.isEmpty
      ? .never
      : always(())
}
//  Parser<Void> { str -> Void? in
//  let prefix = str.prefix(while: { $0 == " " })
//  guard !prefix.isEmpty else { return nil }
//  str.removeFirst(prefix.count)
//  return ()
//}



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
let latitude = zip(
  double,
  literal("°"),
  oneOrMoreSpaces,
  northSouth
  )
  .map { lat, _, _, latSign in lat * latSign }
let longitude = zip(
  double,
  literal("°"),
  oneOrMoreSpaces,
  eastWest
  )
  .map { long, _, _, longSign in long * longSign }
let coord = zip(
  zeroOrMoreSpaces,
  latitude,
  literal(","),
  oneOrMoreSpaces,
  longitude
  )
  .map { _, lat, _, _, long in
    Coordinate(
      latitude: lat,
      longitude: long
    )
}



coord.run("40.446° N, 79.982° W")


coord.run("40.446°   N,   79.982°   W")
coord.run("40.446°   N,   79.982°   W   ")
coord.run("   40.446°   N,   79.982°   W   ")


import Foundation

let df = DateFormatter()
df.dateStyle = .medium

df.date(from: "Jan 29, 2018")
df.date(from: "Jan   29,   2018")
df.date(from: "   Jan   29,   2018")



try NSRegularExpression(pattern: " *")



Scanner().charactersToBeSkipped = .whitespaces



oneOrMoreSpaces.run("   Hello, world!")
oneOrMoreSpaces.run("Hello, world!")



"€42,£42,$42"


func oneOf<A>(
  _ ps: [Parser<A>]
  ) -> Parser<A> {
  return Parser<A> { str -> A? in
    for p in ps {
      if let match = p.run(&str) {
        return match
      }
    }
    return nil
    //    if let value = p1.run(&str) {
    //      return value
    //    }
    //    if let value = p2.run(&str) {
    //      return value
    //    }
    //    return nil
  }
}


enum Currency { case eur, gbp, usd }
let currency = oneOf([
  literal("€").map { Currency.eur },
  literal("£").map { .gbp },
  literal("$").map { .usd }
  ])
//  char.flatMap {
//  $0 == "€" ? always(Currency.eur)
//    : $0 == "£" ? always(.gbp)
//    : $0 == "$" ? always(.usd)
//    : .never
//}


struct Money {
  let currency: Currency
  let value: Double
}
let money = zip(currency, double).map(Money.init)


money.run("€42,£42,$42")


zip(money, literal(","), money, literal(","), money)
  .run("€42,£42")


func zeroOrMore<A>(
  _ p: Parser<A>,
  separatedBy s: Parser<Void>
  ) -> Parser<[A]> {
  return Parser<[A]> { str in
    var rest = str
    var matches: [A] = []
    while let match = p.run(&str) {
      rest = str
      matches.append(match)
      if s.run(&str) == nil {
        return matches
      }
    }
    str = rest
    return matches
  }
}


zeroOrMore(money, separatedBy: literal(","))
  .run("€42,£42,$42,")
  .match
zeroOrMore(money, separatedBy: literal(","))
  .run("€42,£42,$42,")
  .rest


zeroOrMore(money, separatedBy: literal(""))
  .run("€42£42$42")
  .match

let commaOrNewline = char
  .flatMap { $0 == "," || $0 == "\n" ? always(()) : .never }

dump(
zeroOrMore(money, separatedBy: commaOrNewline)
  .run("""
€42,£42,$42
€42,£42,$42
€42,£42,$42,฿10
""")
  .match)

zeroOrMore(money, separatedBy: commaOrNewline)
  .run("""
€42,£42,$42
€42,£42,$42
€42,£42,$42,฿10
""")
  .rest

dump(
  zeroOrMore(money, separatedBy: commaOrNewline)
    .run("""
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
€42,£42,$42,€42,£42,$42,€42,£42,$42,€42,£42,$42
""")
    .match)


"($19.00)"

let moneyLoss = zip(literal("("), money, literal(")"))
  .map { _, money, _ in
    Money(currency: money.currency, value: -money.value)
}

moneyLoss.run("($19.00)")

let accounting = oneOf([money, moneyLoss])
//  Parser<Money> { str -> Money? in
//  if let value = money.run(&str) {
//    return value
//  }
//  if let value = moneyLoss.run(&str) {
//    return value
//  }
//  return nil
//}


accounting.run("£19.00")
accounting.run("(£19.00)")



enum Location {
  case nyc, berlin, london
}

struct Race {
  let location: Location
  let entranceFee: Money
  let path: [Coordinate]
}

let location = oneOf([
  literal("New York City").map { Location.nyc },
  literal("Berlin").map { .berlin },
  literal("London").map { .london }
  ])

let race: Parser<Race> = zip(
  location,
  literal(","),
  oneOrMoreSpaces,
  money,
  literal("\n"),
  zeroOrMore(coord, separatedBy: literal("\n"))
  ).map { location, _, _, entranceFee, _, path in
    Race(location: location, entranceFee: entranceFee, path: path)
}

let races: Parser<[Race]> = zeroOrMore(race, separatedBy: literal("\n---\n"))

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

dump(
races.run(upcomingRaces).match
)
