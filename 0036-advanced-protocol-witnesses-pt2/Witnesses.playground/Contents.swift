import Overture

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

let secureCompactWitness = compactWitness.contramap(set(\.password, "*******"))

let localhostPostgres = PostgresConnInfo(
  database: "pointfreeco_development",
  hostname: "localhost",
  password: "",
  port: 5432,
  user: "pointfreeco"
)

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

let connectionWitness = Describing<PostgresConnInfo> {
  "postgres://\($0.user):\($0.password)@\($0.hostname):\($0.port)/\($0.database)"
}

func print<A>(tag: String, _ value: A, _ witness: Describing<A>) {
  print("[\(tag)] \(witness.describe(value))")
}

struct EmptyInitializing<A> {
  let create: () -> A
}

let zero = EmptyInitializing<Int> { 0 }
let one = EmptyInitializing<Int> { 1 }

struct Combining<A> {
  let combine: (A, A) -> A
}

let sum = Combining<Int>(combine: +)
let product = Combining<Int>(combine: *)

extension Array {
  func reduce(_ initial: EmptyInitializing<Element>, _ combining: Combining<Element>) -> Element {
    return self.reduce(initial.create(), combining.combine)
  }
}
