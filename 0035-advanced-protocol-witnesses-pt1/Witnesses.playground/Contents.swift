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

extension Array: Equatable where Element: Equatable {
  //...
}


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
