
enum Either<A, B> {
  case left(A)
  case right(B)
}

struct Pair<A, B> {
  let first: A
  let second: B
}

struct Func<A, B> {
  let apply: (A) -> B
}

// Either<A, B> = A + B
// Pair<A, B>   = A * B
// Func<A, B>   = B^A

// Either<Pair<A, B>, Pair<A, C>>
//   = Pair<A, B> + Pair<A, C>
//   = A * B + A * C
//   = A * (B + C)
//   = Pair<A, B + C>
//   = Pair<A, Either<B, C>>

// Either(A, B) = A + B
// Pair(A, B)   = A * B
// Func(A, B)   = B^A

// | Algebra      | Swift Type System |
// | ------------ | ----------------- |
// | Sums         | Enums             |
// | Products     | Structs           |
// | Exponentials | Functions         |
// | Functions    | Generics          |

enum Optional<A> {
  case some(A)
  case none // Void
}

// Optional(A) = A + Void
//             = A + 1
// A? = A + 1

// Pair(Optional(A), Optional(B))
//   = A? * B?
//   = (A + 1) * (B + 1)
//   = A*B + A + B + 1

// A natural number is either:
// - Zero, or
// - The successor to some other natural number

enum NaturalNumber {
  case zero
  indirect case successor(NaturalNumber)
}

let zero = NaturalNumber.zero
let one = NaturalNumber.successor(.zero)
let two = NaturalNumber.successor(.successor(.zero))
let three = NaturalNumber.successor(.successor(.successor(.zero)))

let x: UInt = 0
x &- 1

func predecessor(_ nat: NaturalNumber) -> NaturalNumber? {
  switch nat {
  case .zero:
    return nil
  case .successor(let predecessor):
    return predecessor
  }
}

// NaturalNumber = 1 + NaturalNumber
//   = 1 + (1 + NaturalNumber)
//   = 1 + (1 + (1 + NaturalNumber))
//   = 1 + (1 + (1 + (1 + NaturalNumber)))
//   ...
//   = 1 + 1 + 1 + 1 + 1 + ...



// List<A>
// A value in List<A> is either:
// - empty list, or
// - a value (called the head) appended onto the rest of the list (called the tail)

enum List<A> {
  case empty
  indirect case cons(A, List<A>)
}

let xs: List<Int> = .cons(1, .cons(2, .cons(3, .empty)))
// [1, 2, 3]

func sum(_ xs: List<Int>) -> Int {
  switch xs {
  case .empty:
    return 0
  case let .cons(head, tail):
    return head + sum(tail)
  }
}

sum(xs)

// List(A) = 1 + A * List(A)
//  => List(A) - A * List(A) = 1
//  => List(A) * (1 - A) = 1
//  => List(A) = 1 / (1 - A)

// List(A) = 1 + A * List(A)
//         = 1 + A * (1 + A * List(A))
//         = 1 + A + A*A * List(A)
//         = 1 + A + A*A * (1 + A * List(A))
//         = 1 + A + A*A + A*A*A * List(A)
//         = 1 + A + A*A + A*A*A + A*A*A*A * List(A)
//         = 1 + A + A*A + A*A*A + A*A*A*A + ...

enum AlgebraicList<A> {
  case empty
  case one(A)
  case two(A, A)
  case three(A, A, A)
  case four(A, A, A, A)
  //...
}

AlgebraicList<Int>.four(1, 2, 3, 4)

// List(A) = 1 / (1 - A)
//         = 1 + A + A*A + A*A*A + ...

struct NonEmptyArray<A> {
  private let values: [A]

  init?(_ values: [A]) {
    guard !values.isEmpty else { return nil }
    self.values = values
  }

  init(values first: A, _ rest: A...) {
    self.values = [first] + rest
  }
}

NonEmptyArray([1, 2, 3])
NonEmptyArray([])

dump(NonEmptyArray(values: 1, 2, 3))


extension NonEmptyArray: Collection {
  var startIndex: Int {
    return self.values.startIndex
  }

  var endIndex: Int {
    return self.values.endIndex
  }

  func index(after i: Int) -> Int {
    return self.values.index(after: i)
  }

  subscript(index: Int) -> A {
    get { return self.values[index] }
  }
}

NonEmptyArray(values: 1, 2, 3).forEach { print($0) }

let ys = NonEmptyArray(values: 1, 2, 3)

extension NonEmptyArray {
  var first: A {
    return self.values.first!
  }
}

ys.first + 2


//NonEmptyArray<Int>().first


// List(A) = 1 + A + A*A + A*A*A + A*A*A*A + ...
// NonEmptyList(A) = A + A*A + A*A*A + A*A*A*A + ...
//                 = A * (1 + A + A*A + A*A*A + ...)
//                 = A * List(A)
//
//struct NonEmptyList<A> {
//  let head: A
//  let tail: List<A>
//}
//
//let zs = NonEmptyList(head: 1, tail: .cons(2, .cons(3, .empty)))

// NonEmptyList(A) = A + A*A + A*A*A + A*A*A*A + ...
//                 = A + A * (A + A*A + A*A*A + ...)
//                 = A + A * NonEmptyList(A)

enum NonEmptyList<A> {
  case singleton(A)
  indirect case cons(A, NonEmptyList<A>)
}

let zs: NonEmptyList<Int> = .cons(1, .cons(2, .singleton(3)))
let ws: NonEmptyList<Int> = .singleton(3)
// [1, 2, 3]

extension NonEmptyList {
  var first: A {
    switch self {
    case let .singleton(first):
      return first
    case let .cons(head, _):
      return head
    }
  }
}

zs.first
ws.first
//: [See the next page](@next) for exercises!
