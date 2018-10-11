
protocol Describable {
  var describe: String { get }
}

struct Describing<A> {
  let describe: (A) -> String

  func contramap<B>(_ f: @escaping (B) -> A) -> Describing<B> {
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

import Overture

let secureCompactWitness = compactWitness.contramap(set(\.password, "*******"))

let localhostPostgres = PostgresConnInfo(
  database: "pointfreeco_development",
  hostname: "localhost",
  password: "",
  port: 5432,
  user: "pointfreeco"
)

print(secureCompactWitness.describe(localhostPostgres))

compactWitness.describe(localhostPostgres)

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

let securePrettyWitness = prettyWitness.contramap(set(\.password, "******"))

prettyWitness.describe(localhostPostgres)
print(securePrettyWitness.describe(localhostPostgres))

let connectionWitness = Describing<PostgresConnInfo> {
  "postgres://\($0.user):\($0.password)@\($0.hostname):\($0.port)/\($0.database)"
}

connectionWitness.describe(localhostPostgres)

//extension PostgresConnInfo: Describable {
//  var describe: String {
//    return "PostgresConnInfo(database: \"\(self.database)\", hostname: \"\(self.hostname)\", password: \"\(self.password)\", port: \"\(self.port)\", user: \"\(self.user)\")"
//  }
//}

//extension PostgresConnInfo: Describable {
//  var describe: String {
//    return """
//PostgresConnInfo(
//  database: \"\(self.database)\",
//  hostname: \"\(self.hostname)\",
//  password: \"\(self.password)\",
//  port: \"\(self.port)\",
//  user: \"\(self.user)\"
//)
//"""
//  }
//}

extension PostgresConnInfo: Describable {
  var describe: String {
    return "postgres://\(self.user):\(self.password)@\(self.hostname):\(self.port)/\(self.database)"
  }
}


print(localhostPostgres.describe)

func print<A>(tag: String, _ value: A, _ witness: Describing<A>) {
  print("[\(tag)] \(witness.describe(value))")
}

func print<A: Describable>(tag: String, _ value: A) {
  print("[\(tag)] \(value.describe)")
}

print(tag: "debug", localhostPostgres, connectionWitness)
print(tag: "debug", localhostPostgres, prettyWitness)
print(tag: "debug", localhostPostgres)


extension Int: Describable {
  var describe: String {
    return "\(self)"
  }
}

2.describe


protocol EmptyInitializable {
  init()
}

struct EmptyInitializing<A> {
  let create: () -> A
}

extension String: EmptyInitializable {
}
extension Array: EmptyInitializable {
}
extension Int: EmptyInitializable {
  init() {
    self = 1
  }
}
extension Optional: EmptyInitializable {
  init() {
    self = nil
  }
}

[1, 2, 3].reduce(0, +)

extension Array {
  func reduce<Result: EmptyInitializable>(_ accumulation: (Result, Element) -> Result) -> Result {
    return self.reduce(Result(), accumulation)
  }
}

[1, 2, 3].reduce(+)
[[1, 2], [], [3, 4]].reduce(+)
["Hello", " ", "Blob"].reduce(+)

protocol Combinable {
  func combine(with other: Self) -> Self
}

struct Combining<A> {
  let combine: (A, A) -> A
}

extension Int: Combinable {
  func combine(with other: Int) -> Int {
    return self * other
  }
}
extension String: Combinable {
  func combine(with other: String) -> String {
    return self + other
  }
}
extension Array: Combinable {
  func combine(with other: Array) -> Array {
    return self + other
  }
}
extension Optional: Combinable {
  func combine(with other: Optional) -> Optional {
    return self ?? other
  }
}

extension Array where Element: Combinable {
  func reduce(_ initial: Element) -> Element {
    return self.reduce(initial) { $0.combine(with: $1) }
  }
}

extension Array /* where Element: Combinable */ {
  func reduce(_ initial: Element, _ combining: Combining<Element>) -> Element {
    return self.reduce(initial, combining.combine)
  }
}

[1, 2, 3].reduce(1)
[[1, 2], [], [3, 4]].reduce([])
[nil, nil, 3].reduce(nil)

let sum = Combining<Int>(combine: +)
[1, 2, 3, 4].reduce(0, sum)

let product = Combining<Int>(combine: *)
[1, 2, 3, 4].reduce(1, product)


extension Array where Element: Combinable & EmptyInitializable {
  func reduce() -> Element {
    return self.reduce(Element()) { $0.combine(with: $1) }
  }
}

extension Array {
  func reduce(_ initial: EmptyInitializing<Element>, _ combining: Combining<Element>) -> Element {
    return self.reduce(initial.create(), combining.combine)
  }
}


[1, 2, 3, 4].reduce()
[[1, 2], [], [3, 4]].reduce()
[nil, nil, 3].reduce()

let zero = EmptyInitializing<Int> { 0 }
[1, 2, 3, 4].reduce(zero, sum)
let one = EmptyInitializing<Int> { 1 }
[1, 2, 3, 4].reduce(one, product)



//extension Int: Combinable {
//  func combine(with other: Int) -> Int {
//    return self * other
//  }
//}
