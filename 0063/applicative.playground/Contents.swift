
struct Coordinate {
  let latitude: Double
  let longitude: Double
}

infix operator <*
public func <* <T, U, E>(lhs: Result<T, E>, rhs: Result<U, E>) -> Result<T, E> {
  switch rhs {
  case let .failure(err):
    return .failure(err)
  case .success:
    return lhs
  }
}


struct Parser<A> {
  let run: (inout Substring) -> A?

  func run(_ str: String) -> (rest: Substring, match: A?) {
    var sub = str[...]
    let a = self.run(&sub)
    return (sub, a)
  }

  func parse(_ string: String) -> A? {
    guard
      case let (rest, .some(match)) = self.run(string)
      else { return nil }
    guard rest == "" else { return nil }
    return match
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

let char = Parser<Character> { str in
  guard !str.isEmpty else { return nil }
  return str.removeFirst()
}

func always<A>(_ a: A) -> Parser<A> {
  return Parser<A> { _ in a }
}

extension Parser {
  static var never: Parser {
    return Parser { _ in nil }
  }
}

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
let coord = zip(latitude, literal(", "), longitude)
  .map { lat, _, long in
    Coordinate(
      latitude: lat,
      longitude: long
    )
}


let coord2 = zip(
  double,
  literal("° "),
  northSouth,
  literal(", "),
  double,
  literal("° "),
  eastWest
  ).map { lat, _, latSign, _, long, _, longSign in
    Coordinate(
      latitude: lat * latSign,
      longitude: long * longSign
    )
}


extension Parser {
  func apply<B, C>(_ b: Parser<B>) -> Parser<C> where A == (B) -> C {
    return zip(self, b).map { f, b in f(b) }
  }

  func keep<B, C>(andKeep b: Parser<B>) -> Parser<C> where A == (B) -> C {
    return self.apply(b)
  }

  func keep<B>(andDiscard b: Parser<B>) -> Parser<A> {
    return zip(self, b).map { a, _ in a }
  }

  func skip<B>(andKeep b: Parser<B>) -> Parser<B> {
    return zip(self, b).map { _, b in b }
  }

  func skip<B>(andDiscard b: Parser<B>) -> Parser<Void> {
    return zip(self, b).map { _, _ in () }
  }
}

func curry<A, B, C>(
  _ f: @escaping (A, B) -> C
  )
  -> (A)
  -> (B)
  -> C {
  return { a in { b in f(a, b) } }
}

extension Parser {
  init<B, C, D>(
    _ a: @escaping (B, C) -> D
    ) where A == (B) -> (C) -> D {
    self = Parser { _ in { b in { c in a(b, c) } } }
  }
}
extension Parser {
  static func of<B, C, D>(
    _ a: @escaping (B, C) -> D
    ) -> Parser<A> where A == (B) -> (C) -> D {
    return Parser<A> { _ in { b in { c in a(b, c) } } }
  }
}

let lat = always(curry(*))
  .keep(andKeep: double)
  .keep(andDiscard: literal("° "))
  .keep(andKeep: northSouth)
let long = always(curry(*))
  .keep(andKeep: double)
  .keep(andDiscard: literal("° "))
  .keep(andKeep: eastWest)
let coord3 = Parser.of(Coordinate.init)
  //always(curry(Coordinate.init(latitude: longitude:)))
  .keep(andKeep: lat)
  .keep(andDiscard: literal(", "))
  .keep(andKeep: long)

always(curry(*))
  .keep(andKeep: double)
  .keep(andDiscard: literal("° "))
  .keep(andKeep: northSouth)
  .run("40° E")


//always({ $0 })
//  .keep(andKeep: double)
//  .keep(andDiscard: literal("° "))
//  .keep(andKeep: northSouth)



func zip<A, B>(keep a: Parser<A>, keep b: Parser<B>) -> Parser<(A, B)> {
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

func zip<A, B>(keep a: Parser<A>, discard b: Parser<B>) -> Parser<A> {
  return zip(a, b).map { a, _ in a }
}

let latitude1 = zip(zip(keep: double, discard: literal("°")), northSouth)

extension Parser {
  func _keep<B>(andKeep b: Parser<B>) -> Parser<(A, B)> {
    return zip(self, b)
  }

  func _keep<B>(andDiscard b: Parser<B>) -> Parser<A> {
    return zip(self, b).map { a, _ in a }
  }
}

let latitude2 = double
  ._keep(andDiscard: literal("°"))
  ._keep(andKeep: northSouth)
  ._keep(andDiscard: literal(", "))
  ._keep(andKeep: double)
  ._keep(andDiscard: literal("°"))
  ._keep(andKeep: eastWest)
