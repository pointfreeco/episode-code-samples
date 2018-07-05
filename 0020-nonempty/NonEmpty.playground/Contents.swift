
enum List<A> {
  case empty
  indirect case cons(A, List<A>)
}

struct NonEmptyListProduct<A> {
  let head: A
  let tail: List<A>
}

enum NonEmptyListSum<A> {
  case singleton(A)
  indirect case cons(A, NonEmptyListSum<A>)
}

[1, 2, 3]
NonEmptyListProduct(head: 1, tail: .cons(2, .cons(3, .empty)))
NonEmptyListSum.cons(1, .cons(2, .singleton(3)))

struct NonEmptyArray<A> {
  var head: A
  var tail: [A]
}

extension NonEmptyArray: CustomStringConvertible {
  var description: String {
    return "\(head)\(tail)"
  }
}

NonEmptyArray(head: 1, tail: [2, 3])

extension NonEmptyArray {
//  init(_ head: A, _ tail: [A] = []) {
//    self.head = head
//    self.tail = tail
//  }
  init(_ head: A, _ tail: A...) {
    self.head = head
    self.tail = tail
  }
}

//NonEmptyArray(1, [2, 3])
//NonEmptyArray(1, [])
NonEmptyArray(1)
NonEmptyArray(1, 2, 3)
//NonEmptyArray()

extension NonEmptyArray: Collection {
  var startIndex: Int {
    return 0
  }

  var endIndex: Int {
    return self.tail.endIndex + 1
  }

  subscript(position: Int) -> A {
    return position == 0 ? self.head : self.tail[position - 1]
  }

  func index(after i: Int) -> Int {
    return i + 1
  }
}

let xs = NonEmptyArray(1, 2, 3)
xs.forEach { print($0) }
xs.count
xs.first

extension NonEmptyArray {
  var first: A {
    return self.head
  }
}

xs.first + 1

extension NonEmptyArray: BidirectionalCollection {
  func index(before i: Int) -> Int {
    return i - 1
  }
}

xs.last

extension NonEmptyArray {
  var last: A {
    return self.tail.last ?? self.head
  }
}

xs.last + 1

struct NonEmpty<C: Collection> {
  var head: C.Element
  var tail: C

  init(_ head: C.Element, _ tail: C) {
    self.head = head
    self.tail = tail
  }
}

extension NonEmpty: CustomStringConvertible {
  var description: String {
    return "\(self.head)\(self.tail)"
  }
}

NonEmpty<[Int]>(1, [2, 3])
NonEmpty<[Int]>(1, [])
NonEmpty<Set<Int>>(1, [2, 3])
NonEmpty<[Int: String]>((1, "Blob"), [2: "Blob Junior", 3: "Blob Senior"])

NonEmpty<String>("B", "lob")

extension NonEmpty where C: RangeReplaceableCollection {
  init(_ head: C.Element, _ tail: C.Element...) {
    self.head = head
    self.tail = C(tail)
  }
}

NonEmpty<[Int]>(1, 2, 3)
//NonEmpty<Set<Int>>(1, 2, 3)

extension NonEmpty: Collection {
  enum Index: Comparable {
    case head
    case tail(C.Index)

    static func < (lhs: Index, rhs: Index) -> Bool {
      switch (lhs, rhs) {
      case (.head, .tail):
        return true
      case (.tail, .head):
        return false
      case (.head, .head):
        return false
      case let (.tail(l), .tail(r)):
        return l < r
      }
    }
  }

  var startIndex: Index {
    return .head
  }

  var endIndex: Index {
    return .tail(self.tail.endIndex)
  }

  subscript(position: Index) -> C.Element {
    switch position {
    case .head:
      return self.head
    case let .tail(index):
      return self.tail[index]
    }
  }

  func index(after i: Index) -> Index {
    switch i {
    case .head:
      return .tail(self.tail.startIndex)
    case let .tail(index):
      return .tail(self.tail.index(after: index))
    }
  }
}

let ys = NonEmpty<[Int]>(1, 2, 3)
ys.forEach { print($0) }
ys.count
ys.first

extension NonEmpty {
  var first: C.Element {
    return self.head
  }
}

ys.first + 1

extension NonEmpty: BidirectionalCollection where C: BidirectionalCollection {
  func index(before i: Index) -> Index {
    switch i {
    case .head:
      return .tail(self.tail.index(before: self.tail.startIndex))
    case let .tail(index):
      return index == self.tail.startIndex ? .head : .tail(self.tail.index(before: index))
    }
  }
}

extension NonEmpty where C: BidirectionalCollection {
  var last: C.Element {
    return self.tail.last ?? self.head
  }
}

ys.last + 1

ys[.head]
ys[.tail(0)]
ys[.tail(1)]

extension NonEmpty where C.Index == Int {
  subscript(position: Int) -> C.Element {
    return self[position == 0 ? .head : .tail(position - 1)]
  }
}

ys[0]
ys[1]
ys[2]

var zs = NonEmpty<[Int]>(1, 2, 3)
//zs[0] = 42

extension NonEmpty: MutableCollection where C: MutableCollection {
  subscript(position: Index) -> C.Element {
    get {
      switch position {
      case .head:
        return self.head
      case let .tail(index):
        return self.tail[index]
      }
    }
    set(newValue) {
      switch position {
      case .head:
        self.head = newValue
      case let .tail(index):
        self.tail[index] = newValue
      }
    }
  }
}

zs[.head] = 42
zs

extension NonEmpty where C: MutableCollection, C.Index == Int {
  subscript(position: Int) -> C.Element {
    get {
      return self[position == 0 ? .head : .tail(position - 1)]
    }
    set {
      self[position == 0 ? .head : .tail(position - 1)] = newValue
    }
  }
}

zs[0] = 42
zs[1] = 1000
zs[2] = 19
zs

let set = Set([1, 1, 2, 3])
set.count

extension NonEmpty where C: SetAlgebra {
  init(_ head: C.Element, _ tail: C) {
    var tail = tail
    tail.remove(head)
    self.head = head
    self.tail = tail
  }
  init(_ head: C.Element, _ tail: C.Element...) {
    var tail = C(tail)
    tail.remove(head)
    self.head = head
    self.tail = tail
  }
}

let nonEmptySet = NonEmpty<Set<Int>>(1, 1, 2, 3)
nonEmptySet.count

Set([1, 2, 3])

typealias NonEmptySet<A> = NonEmpty<Set<A>> where A: Hashable
typealias _NonEmptyArray<A> = NonEmpty<[A]>

NonEmptySet(1, 1, 2, 3)
_NonEmptyArray(1, 1, 2, 3)

extension NonEmpty where C: RangeReplaceableCollection {
  mutating func append(_ newElement: C.Element) {
    self.tail.append(newElement)
  }
}

extension Sequence {
  func groupBy<A>(_ f: (Element) -> A) -> [A: NonEmpty<[Element]>] {
    var result: [A: NonEmpty<[Element]>] = [:]
    for element in self {
      let key = f(element)
      if result[key] == nil {
        result[key] = NonEmpty(element)
      } else {
        result[key]?.append(element)
      }
    }
    return result
  }
}

Array(1...10)
  .groupBy { $0 % 3 }
  .debugDescription

"Mississippi"
  .groupBy { $0 }

[1, 2, 3].randomElement()

NonEmpty<[Int]>(1, 2, 3)

extension NonEmpty {
  func safeRandomElement() -> C.Element {
    return self.randomElement() ?? self.head
  }
}

NonEmpty<[Int]>(1, 2, 3).safeRandomElement() + 1

// { email name }
// {}


enum UserField: String {
  case id
  case name
  case email
}

func query(_ fields: NonEmptySet<UserField>) -> String {
  return (["{\n"] + fields.map { "  \($0.rawValue)\n" } + ["}\n"])
    .joined()
}

print(query(.init(.email, .name)))

enum Result<Value, Error> {
  case success(Value)
  case failure(Error)
}

enum Validated<Value, Error> {
  case valid(Value)
  case invalid(NonEmpty<[Error]>)
}

//let validatedPassword = Validated<String, String>.valid("blobisawesome")

let validatedPassword = Validated<String, String>.invalid(.init("Too short", "Didn't contain any numbers"))

//let validatedPassword = Validated<String, String>.invalid([])
