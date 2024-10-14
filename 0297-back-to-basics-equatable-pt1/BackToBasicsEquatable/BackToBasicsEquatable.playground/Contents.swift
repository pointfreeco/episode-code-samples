//let x: any Equatable

struct User: Equatable {
  let id: Int
  var isAdmin = false
  var name: String

  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id && lhs.isAdmin == rhs.isAdmin && lhs.name == rhs.name
//    lhs.id == rhs.id
//    lhs.isAdmin == rhs.isAdmin && lhs.name == rhs.name
  }
}

let blob = User(id: 42, isAdmin: false, name: "Blob")

let id42Partition = [
  User(id: 42, isAdmin: true, name: "Blob"),
  User(id: 42, isAdmin: false, name: "Blob, Esq."),
  User(id: 42, isAdmin: true, name: "Blob, Esq."),
  User(id: 42, isAdmin: true, name: "Blob, MD"),
  User(id: 42, isAdmin: true, name: "Blob, MD"),
  // ...
]

id42Partition.allSatisfy { lhs in
  id42Partition.allSatisfy { rhs in
    lhs == rhs
  }
}

struct Mod12: Equatable {
  var value: Int
  init(_ value: Int) {
    self.value = value
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    (rhs.value - lhs.value).isMultiple(of: 12)
  }

  func add(to other: Self) -> Self {
    Self(value + other.value)
  }
  var isBig: Bool {
    value >= 100
  }
}
func algorithm(lhs: Mod12, rhs: Mod12) {
  let bothAreBig = lhs == rhs
  ? lhs.isBig
  : lhs.isBig && rhs.isBig
}

do {
  let three = Mod12(3)
  let fifteen = Mod12(15)
  Mod12(2).add(to: three) == Mod12(2).add(to: fifteen)

  Mod12(2) == Mod12(50)
  Mod12(2).isBig == Mod12(50).isBig
  Mod12(2) == Mod12(110)
  Mod12(2).isBig == Mod12(110).isBig
  Mod12(2).isBig
  Mod12(110).isBig
}

Mod12(1) == Mod12(6)
Mod12(1) == Mod12(13)
Mod12(1) == Mod12(25)

struct NeverEqual<A>: Equatable {
  var value: A
  init(_ value: A) {
    self.value = value
  }
  static func == (lhs: Self, rhs: Self) -> Bool { false }
}

do {
  let neverEqual1 = NeverEqual(1)
  neverEqual1 == neverEqual1

  let values = [NeverEqual(true), NeverEqual(false)]
  values.count
  values.contains(NeverEqual(true))
  values.contains(NeverEqual(false))
}

struct LessThanOrEqual: Equatable {
  var value: Int
  init(_ value: Int) {
    self.value = value
  }
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.value <= rhs.value
  }
}

LessThanOrEqual(2) == LessThanOrEqual(3)
LessThanOrEqual(3) == LessThanOrEqual(2)

extension Array where Element: Equatable {
  func firstOffset(of needle: Element) -> Int? {
    for (offset, element) in enumerated() {
      if needle == element {
//      if element == needle {
        return offset
      }
    }
    return nil
  }
}

[
  LessThanOrEqual(2),
  LessThanOrEqual(3),
]
  .firstOffset(of: LessThanOrEqual(3))

struct Approximation: Equatable {
  var value: Double
  init(_ value: Double) {
    self.value = value
  }
  static func == (lhs: Self, rhs: Self) -> Bool {
    abs(lhs.value - rhs.value) < 0.1
  }
}

Approximation(1) == Approximation(1.05)
Approximation(1.05) == Approximation(1.1)
Approximation(1) == Approximation(1.1)

extension Array where Element: Equatable {
  func uniques() -> Array {
    var result = Array()
    for element in self {
      if !result.contains(element) {
        result.append(element)
      }
    }
    return result
  }
}

[
  Approximation(1),
  Approximation(1.05),
  Approximation(1.025),
  Approximation(1.075),
  Approximation(1.1),
  Approximation(1.15),
]
  .uniques()
  .map(\.value)

func f<A: Equatable>(_ a: A) -> Bool {
  //
  fatalError()
}
do {
//  let x: Int
//  let y: Int
//  if x == y {
//    f(x) == f(y)
//  }
}
func algorithm<A: Equatable>(lhs: A, rhs: A) -> Bool {
  if lhs == rhs {
    // fast path using 'lhs'
  } else {
    // slow path using both 'lhs' and 'rhs'
  }
  fatalError()
}
