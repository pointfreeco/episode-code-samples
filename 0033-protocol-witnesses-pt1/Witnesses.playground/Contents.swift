
protocol Describable {
  var describe: String { get }
}

struct PostgresConnInfo {
  var database: String
  var hostname: String
  var password: String
  var port: Int
  var user: String
}

let localhostPostgres = PostgresConnInfo(
  database: "pointfreeco_development",
  hostname: "localhost",
  password: "",
  port: 5432,
  user: "pointfreeco"
)

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

extension Int: Describable {
  var describe: String {
    return "\(self)"
  }
}

2.describe

protocol EmptyInitializable {
  init()
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

[1, 2, 3, 4].reduce()
[[1, 2], [], [3, 4]].reduce()
[nil, nil, 3].reduce()

//extension Int: Combinable {
//  func combine(with other: Int) -> Int {
//    return self * other
//  }
//}
