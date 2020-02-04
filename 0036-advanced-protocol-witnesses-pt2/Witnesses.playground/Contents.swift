import Darwin

struct Predicate<A> {
  let contains: (A) -> Bool
  func contramap<B>(_ f: @escaping (B) -> A) -> Predicate<B> {
    return Predicate<B> { self.contains(f($0)) }
  }
  func pullback<B>(_ f: @escaping (B) -> A) -> Predicate<B> {
    return Predicate<B> { self.contains(f($0)) }
  }
}

let isLessThan10 = Predicate { $0 < 10 }
isLessThan10.contains(5)
isLessThan10.contains(11)

//let shortStrings = isLessThan10.contramap { (s: String) in s.count }

import Overture

let shortStrings = isLessThan10.contramap(get(\String.count))

shortStrings.contains("Blob")
shortStrings.contains("Blobby McBlob")

isLessThan10.pullback(get(\String.count))


struct Describing<A> {
  let describe: (A) -> String

  func contramap<B>(_ f: @escaping (B) -> A) -> Describing<B> {
    return Describing<B> { b in
      self.describe(f(b))
    }
  }

  func pullback<B>(_ f: @escaping (B) -> A) -> Describing<B> {
    return Describing<B> { b in
      self.describe(f(b))
    }
  }
}

struct PostgresConnInfo {
  var database: String
  var hostname: String
  var password: String
  var port: Int
  var user: String
}


let compactWitness = Describing<PostgresConnInfo> { conn in
  return "PostgresConnInfo(database: \"\(conn.database)\", hostname: \"\(conn.hostname)\", password: \"\(conn.password)\", port: \"\(conn.port)\", user: \"\(conn.user)\")"
}

let prettyWitness = Describing<PostgresConnInfo> {
  """
  PostgresConnInfo(
    database: \"\($0.database)\",
    hostname: \"\($0.hostname)\",
    password: \"\($0.password)\",
    port: \"\($0.port)\",
    user: \"\($0.user)\"
  )
  """
}

let secureCompactWitness = compactWitness.contramap(set(\.password, "*******"))

let securePrettyWitness = prettyWitness.contramap(set(\.password, "******"))

compactWitness.pullback(set(\.password, "******"))


protocol Combinable {
  func combine(with other: Self) -> Self
}

struct Combining<A> {
  let combine: (A, A) -> A
}
struct EmptyInitializing<A> {
  let create: () -> A
}

let sum = Combining<Int>(combine: +)
let zero = EmptyInitializing { 0 }

let product = Combining<Int>(combine: *)
let one = EmptyInitializing { 1 }

extension Array {
  func reduce(_ initial: EmptyInitializing<Element>, _ combining: Combining<Element>) -> Element {
    return self.reduce(initial.create(), combining.combine)
  }
}

[1, 2, 3, 4].reduce(zero, sum)
[1, 2, 3, 4].reduce(one, product)

//extension Combining where A == Int {
//  static let sum = Combining(combine: +)
//  static let product = Combining(combine: *)
//}
//
//extension EmptyInitializing where A == Int {
//  static let zero = EmptyInitializing { 0 }
//  static let one = EmptyInitializing { 1 }
//}

extension Combining where A: Numeric {
  static var sum: Combining {
    return Combining(combine: +)
  }
  static var product: Combining {
    return Combining(combine: *)
  }
}

extension EmptyInitializing where A: Numeric {
  static var zero: EmptyInitializing {
    return EmptyInitializing { 0 }
  }
  static var one: EmptyInitializing {
    return EmptyInitializing { 1 }
  }
}


[1, 2, 3, 4].reduce(EmptyInitializing.zero, Combining.sum)
[1, 2, 3, 4].reduce(EmptyInitializing.one, Combining.product)

[1, 2, 3, 4].reduce(.zero, .sum)
[1, 2, 3, 4].reduce(.one, .product)

[1.1, 2, 3, 4].reduce(.zero, .sum)
[1.1, 2, 3, 4].reduce(.one, .product)

extension Describing where A == PostgresConnInfo {

  static let compact = Describing { conn in
    return "PostgresConnInfo(database: \"\(conn.database)\", hostname: \"\(conn.hostname)\", password: \"\(conn.password)\", port: \"\(conn.port)\", user: \"\(conn.user)\")"
  }

  static let pretty = Describing {
    """
    PostgresConnInfo(
    database: \"\($0.database)\",
    hostname: \"\($0.hostname)\",
    password: \"\($0.password)\",
    port: \"\($0.port)\",
    user: \"\($0.user)\"
    )
    """
  }

}

let localhostPostgres = PostgresConnInfo(
  database: "pointfreeco_development",
  hostname: "localhost",
  password: "",
  port: 5432,
  user: "pointfreeco"
)

func print<A>(tag: String, _ value: A, _ witness: Describing<A>) {
  print("[\(tag)] \(witness.describe(value))")
}

print(tag: "debug", localhostPostgres, compactWitness)
print(tag: "debug", localhostPostgres, .compact)

extension Describing where A == Bool {
  static let compact = Describing { $0 ? "t" : "f" }
  static let pretty = Describing { $0 ? "𝓣𝓻𝓾𝓮" : "𝓕𝓪𝓵𝓼𝓮" }
}

print(tag: "debug", true, .compact)
print(tag: "debug", true, .pretty)

//extension Array: Equatable where Element: Equatable {
//}


// public protocol Equatable {
//   public static func == (lhs: Self, rhs: Self) -> Bool
// }

struct Equating<A> {
  let equals: (A, A) -> Bool

  func pullback<B>(_ f: @escaping (B) -> A) -> Equating<B> {
    return Equating<B> { lhs, rhs in
      self.equals(f(lhs), f(rhs))
    }
  }
}

extension Equating where A == Int {
  static let int = Equating(equals: ==)
}

extension Equating {
  static func array(of equating: Equating) -> Equating<[A]> {
    return Equating<[A]> { lhs, rhs in
      guard lhs.count == rhs.count else { return false }

      for (lhs, rhs) in zip(lhs, rhs) {
        if !equating.equals(lhs, rhs) {
          return false
        }
      }

      return true
    }
  }
}

Equating.array(of: .int).equals([], [])
Equating.array(of: .int).equals([1], [1])
Equating.array(of: .int).equals([1], [1, 2])

let stringCount = Equating.int.pullback(get(\String.count))

Equating.array(of: stringCount).equals([], [])
Equating.array(of: stringCount).equals(["Blob"], ["Blob"])
Equating.array(of: stringCount).equals(["Blob"], ["Bolb"])
Equating.array(of: stringCount).equals(["Blob"], ["Blob Sr"])


//[[Int]]

[[1, 2], [3, 4]] == [[1, 2], [3, 4, 5]]
[[1, 2], [3, 4]] == [[1, 2], [3, 4]]

(Equating.array >>> Equating.array)(.int).equals([[1, 2], [3, 4]] , [[1, 2], [3, 4]])
(Equating.array >>> Equating.array)(.int).equals([[1, 2], [3, 4]] , [[1, 2], [3, 4, 5]])

(Equating.array >>> Equating.array)(stringCount)

(Equating.array >>> Equating.array)(stringCount).equals([["Blob"], ["Blob Jr"]], [["Bolb"], ["Bolb Jr"]])

(Equating.array >>> Equating.array)(stringCount).equals([["Blob"], ["Blob Jr"]], [["Bolb"], ["Bolb Esq"]])

//extension (Int, Int) {
//  var sum: Int { return self.0 + self.1 }
//}


//extension (A, B): Equatable where A: Equatable, B: Equatable {
//  static func ==(lhs: (A, B), rhs: (A, B)) -> Bool {
//    return lhs.0 == rhs.0 && lhs.1 == rhs.1
//  }
//}


//extension Void: Equatable {
//  static func ==(lhs: Void, rhs: Void) -> Bool {
//    return true
//  }
//}

extension Equating where A == Void {
  static let void = Equating { _, _ in true }
}

Equating.array(of: .void).equals([(), ()], [(), ()])
Equating.array(of: .void).equals([(), ()], [()])

//[(), ()] == [()]

extension Equating {
  static func tuple<B>(_ a: Equating<A>, _ b: Equating<B>) -> Equating<(A, B)> {
    return Equating<(A, B)> { lhs, rhs in
      a.equals(lhs.0, rhs.0) && b.equals(lhs.1, rhs.1)
    }
  }
}

Equating.tuple(.int, stringCount).equals((1, "Blob"), (1, "Bolb"))
Equating.tuple(.int, stringCount).equals((1, "Blob"), (1, "Blob Jr"))
Equating.tuple(.int, stringCount).equals((1, "Blob"), (2, "Bolb"))


//extension (A) -> A: Combinable {
//  func combine(other f: @escaping (A) -> A) -> (A) -> A {
//    return { a in other(self(a)) }
//  }
//}

struct Endo<A>: Combinable {
  let call: (A) -> A
  func combine(with other: Endo) -> Endo {
    return Endo { a in other.call(self.call(a)) }
  }
}

extension Combining {
  static var endo: Combining<(A) -> A> {
//    return Combining<(A) -> A> { f, g in
//      { a in g(f(a)) }
//    }
    return Combining<(A) -> A>(combine: >>>)
  }
}

extension EmptyInitializing {
  static var identity: EmptyInitializing<(A) -> A> {
    return EmptyInitializing<(A) -> A> {
      { $0 }
    }
  }
}


let endos: [(Double) -> Double] = [
  { $0 + 1.0 },
  { $0 * $0 },
  sin,
  { $0 * 1000.0 }
]

endos.reduce(EmptyInitializing.identity, Combining.endo)(3)


//protocol Comparable: Equatable {
//  static func < (lhs: Self, rhs: Self) -> Bool
//}

struct Comparing<A> {
  let equating: Equating<A>
  let lessThan: (A, A) -> Bool

  func pullback<B>(_ f: @escaping (B) -> A) -> Comparing<B> {
    return Comparing<B>(
      equating: self.equating.pullback(f),
      lessThan: { lhs, rhs in
        self.lessThan(f(lhs), f(rhs))
    })
  }
}

let intAsc = Comparing(equating: .int, lessThan: <)
let intDesc = Comparing(equating: .int, lessThan: >)

struct User { let id: Int, name: String }

intAsc.pullback(get(\User.id))
intDesc.pullback(get(\User.id))

intAsc.pullback(get(\User.name.count))

extension Equating {
  var notEquals: (A, A) -> Bool {
    return { lhs, rhs in
      !self.equals(lhs, rhs)
    }
  }
}


public protocol Reusable {
  static var reuseIdentifier: String { get }
}

public extension Reusable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

class UserCell: UITableViewCell {}
class EpisodeCell: UITableViewCell {}
extension UserCell: Reusable {}
extension EpisodeCell: Reusable {}

UserCell.reuseIdentifier
EpisodeCell.reuseIdentifier

struct Reusing<A> {
  let reuseIdentifier: () -> String

  init(reuseIdentifier: @escaping () -> String = { String(describing: A.self) }) {
    self.reuseIdentifier = reuseIdentifier
  }
}

Reusing<UserCell>().reuseIdentifier()
Reusing<EpisodeCell>().reuseIdentifier()


//let collections: [Collection]

//public protocol RawRepresentable {
//  associatedtype RawValue
//  public init?(rawValue: Self.RawValue)
//  public var rawValue: Self.RawValue { get }
//}

enum Directions: String {
  case down = "D"
  case left = "L"
  case right = "R"
  case up = "U"
}

Directions.down.rawValue
Directions(rawValue: "D")
Directions(rawValue: "X")

struct RawRepresenting<A, RawValue> {
  let convert: (RawValue) -> A?
  let rawValue: (A) -> RawValue
}

extension RawRepresenting where A == Int, RawValue == String {
  static var stringToInt = RawRepresenting(
    convert: Int.init,
    rawValue: String.init(describing:)
  )
}

extension RawRepresenting where A: RawRepresentable, A.RawValue == RawValue {
  static var rawRepresentable: RawRepresenting {
    return RawRepresenting(
      convert: A.init(rawValue:),
      rawValue: { $0.rawValue }
    )
  }
}

RawRepresenting<Directions, String>.rawRepresentable
