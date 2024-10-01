//let x: any Equatable

struct User: Equatable, Hashable {
  let id: Int
  var isAdmin = false
  var name: String

  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
//    && lhs.isAdmin == rhs.isAdmin
//    && lhs.name == rhs.name
//    lhs.id == rhs.id
//    lhs.isAdmin == rhs.isAdmin && lhs.name == rhs.name
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(isAdmin)
    hasher.combine(name)
  }
}

struct SlowDictionary<Key, Value> {
  let keyValues: [(Key, Value)]

  subscript(key: Key) -> Value? where Key: Equatable {
    for (k, v) in keyValues {
      if key == k {
        return v
      }
    }
    return nil
  }
}

do {
  let blob = User(id: 42, isAdmin: false, name: "Blob")
  var friends: [User: [User]] = [:]

  friends[blob] = [
    User(id: 43, name: "Blob Jr."),
    User(id: 44, name: "Blob Sr."),
  ]

  friends[blob]
  blob.hashValue
  let blobJr = User(id: 43, name: "Blob Jr.")
  friends[blobJr]

  blob.hashValue
  blobJr.hashValue

  let users = Set([
    blob,
    blob,
    blob,
    blob,
    blobJr,
    blobJr,
    blobJr,
  ])
  users.contains(blob)
  users.contains(User(id: 44, name: "Blob Sr."))

  var blobDraft = blob
  blobDraft.isAdmin.toggle()
  blob == blobDraft
  blob.hashValue == blobDraft.hashValue
  friends[blob]
  friends[blobDraft]

//  friends[blobDraft] = []

  var friendsSlow = SlowDictionary(
    keyValues: [
      (blob, [
        User(id: 43, name: "Blob Jr."),
        User(id: 44, name: "Blob Sr."),
      ])
    ]
  )

  friendsSlow[blob]
  friendsSlow[blobDraft]
}

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

Double.nan

Double.zero / .zero

import Foundation

sqrt(-1)
Double.infinity * .zero

let nanValue = Double.nan
nanValue == nanValue

let veryLargeNumber: Double = 1_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000
veryLargeNumber == veryLargeNumber + 1

Double.zero
-Double.zero

Double.zero == -.zero

func isSpecialNumber(_ value: Double) -> Bool {
  1 / value == .infinity
}

isSpecialNumber(.zero)
isSpecialNumber(-.zero)

do {
  let name = "Blob"

  let cafe = "Café"

  name == name
  cafe == name
  name == cafe

  let cafe1 = "Caf\u{e9}"
  let cafe2 = "Cafe\u{301}"
  cafe1 == cafe2

  struct Flag: Equatable {
    let id: UUID
    var isEnabled = false
  }

  let dejavu = "déjà-vu"
  let dejavu1 = "d\u{e9}j\u{e0}-vu"
  let dejavu2 = "de\u{301}j\u{e0}-vu"
  let dejavu3 = "d\u{e9}ja\u{300}-vu"
  let dejavu4 = "de\u{301}ja\u{300}-vu"

  dejavu1 == dejavu2
  dejavu2 == dejavu3
  dejavu3 == dejavu4
  dejavu4 == dejavu1

  dejavu1.hashValue
  dejavu2.hashValue
  dejavu3.hashValue
  dejavu4.hashValue

  Array(cafe1.unicodeScalars).description
  Array(cafe2.unicodeScalars).description
  cafe1.unicodeScalars.elementsEqual(cafe2.unicodeScalars)

  Array(cafe1.utf8).description
  Array(cafe2.utf8).description
  cafe1.utf8.elementsEqual(cafe2.utf8)

  func specialAlgorithm(_ str: String) -> Bool {
    if str.utf8.count <= 5 {
      // Fast path
      return true
    } else {
      // Slow path
      return false
    }
  }

  specialAlgorithm(cafe1)
  specialAlgorithm(cafe2)
  cafe1 == cafe2
}

do {
//  let x: Hashable
//  let y: Hashable
//  if x == y {
//    x.hashValue == y.hashValue
//  }
//  if x.hashValue == y.hashValue {
//    x == y
//  }
}

final class UserRef: Equatable, Hashable {
  let id: Int
  var isAdmin = false
  var name: String

  init(id: Int, isAdmin: Bool = false, name: String) {
    self.id = id
    self.isAdmin = isAdmin
    self.name = name
  }

  static func == (lhs: UserRef, rhs: UserRef) -> Bool {
    lhs.id == rhs.id
    && lhs.isAdmin == rhs.isAdmin
    && lhs.name == rhs.name
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(isAdmin)
    hasher.combine(name)
  }
}

do {
  let blob = User(id: 42, name: "Blob")
  let blob2 = User(id: 42, name: "Blob")

  blob == blob2

  var blobJr = User(id: 43, name: "Blob Jr.")
  var users = Set([
    blob,
    blobJr,
  ])

  users.contains(blob)
  users.contains(blobJr)
  users.count

  blobJr.name = "Blob II"

  users.map(\.name)

  users.contains(blob)
  users.contains(blobJr)
  users.count

  users.insert(blobJr)
  users.contains(blobJr)
  users.count

}

do {
  let blob = UserRef(id: 42, name: "Blob")
  let blob2 = UserRef(id: 42, name: "Blob")

  blob === blob2

  let blobJr = UserRef(id: 43, name: "Blob Jr.")

  ObjectIdentifier(blob)
  ObjectIdentifier(blobJr)

  blob === blob
  blob === blobJr
  blobJr === blob

  var users = Set([
    blob,
    blobJr,
  ])

  users.contains(blob)
  users.contains(blobJr)
  users.count

  blobJr.name = "Blob II"

  ObjectIdentifier(blobJr)

  users.map(\.name)

  users.contains(blob)
  users.contains(blobJr)
  users.count

  users.insert(blobJr)
  users.count

  Set(Array(users))

}

final class UserRefCorrect: Equatable, Hashable {
  let id: Int
  var isAdmin = false
  var name: String

  init(id: Int, isAdmin: Bool = false, name: String) {
    self.id = id
    self.isAdmin = isAdmin
    self.name = name
  }

  static func == (lhs: UserRefCorrect, rhs: UserRefCorrect) -> Bool {
    lhs === rhs
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
  }
}

do {
  let blob = UserRefCorrect(id: 42, name: "Blob")
  let blobJr = UserRefCorrect(id: 43, name: "Blob Jr.")
  var users = Set([
    blob,
    blobJr,
  ])

  users.contains(blob)
  users.contains(blobJr)

  blobJr.name = "Blob II"
  users.map(\.name)

  users.contains(blob)
  users.contains(blobJr)
}

actor Status: Hashable {
  var isLoading = false

  static func == (lhs: Status, rhs: Status) -> Bool {
    lhs === rhs
  }
  nonisolated func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
  }
}

let status = Status()
ObjectIdentifier(status)
status === status

func operation(_ value: some Hashable) {
  _ = value.hashValue
}
operation(status)


final class UserRef2: Hashable {
  let id: Int
  let isAdmin: Bool
  let name: String
  init(id: Int, isAdmin: Bool, name: String) {
    self.id = id
    self.isAdmin = isAdmin
    self.name = name
  }
  static func == (lhs: UserRef2, rhs: UserRef2) -> Bool {
    lhs.id == rhs.id
    && lhs.isAdmin == rhs.isAdmin
    && lhs.name == rhs.name
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(isAdmin)
    hasher.combine(name)
  }
}
