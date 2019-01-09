
struct Pair<A, B> {
  let first: A
  let second: B
}

Pair<Bool, Bool>.init(first: true, second: true)
Pair<Bool, Bool>.init(first: true, second: false)
Pair<Bool, Bool>.init(first: false, second: true)
Pair<Bool, Bool>.init(first: false, second: false)

enum Three {
  case one
  case two
  case three
}

Pair<Bool, Three>.init(first: true, second: .one)
Pair<Bool, Three>.init(first: true, second: .two)
Pair<Bool, Three>.init(first: true, second: .three)
Pair<Bool, Three>.init(first: false, second: .one)
Pair<Bool, Three>.init(first: false, second: .two)
Pair<Bool, Three>.init(first: false, second: .three)

let _: Void = Void()
let _: Void = ()
let _: () = ()

func foo(_ x: Int) /* -> Void */ {
  // return ()
}

Pair<Bool, Void>.init(first: true, second: ())
Pair<Bool, Void>.init(first: false, second: ())

Pair<Void, Void>.init(first: (), second: ())

enum Never {}

//let _: Never = ???

//Pair<Bool, Never>.init(first: true, second: ???)


// Pair<Bool, Bool>  = 4 = 2 * 2
// Pair<Bool, Three> = 6 = 2 * 3
// Pair<Bool, Void>  = 2 = 2 * 1
// Pair<Void, Void>  = 1 = 1 * 1
// Pair<Bool, Never> = 0 = 2 * 0


enum Theme {
  case light
  case dark
}

enum State {
  case highlighted
  case normal
  case selected
}

struct Component {
  let enabled: Bool
  let state: State
  let theme: Theme
}

// 2 * 3 * 2 = 12

// Pair<A, B> = A * B
// Pair<Bool, Bool> = Bool * Bool
// Pair<Bool, Three> = Bool * Three
// Pair<Bool, Void> = Bool * Void
// Pair<Bool, Never> = Bool * Never

// Pair<Bool, String> = Bool * String
// String * [Int]
// [String] * [[Int]]
// Never = 0
// Void = 1
// Bool = 2
// 2 * String

enum Either<A, B> {
  case left(A)
  case right(B)
}

Either<Bool, Bool>.left(true)
Either<Bool, Bool>.left(false)
Either<Bool, Bool>.right(true)
Either<Bool, Bool>.right(false)
// Either<Bool, Bool> = 4 = 2 + 2
// 2 + 2

Either<Bool, Three>.left(true)
Either<Bool, Three>.left(false)
Either<Bool, Three>.right(.one)
Either<Bool, Three>.right(.two)
Either<Bool, Three>.right(.three)
// Either<Bool, Three> = 5 = 2 + 3
// Bool + Three
// 2 + Three

Either<Bool, Void>.left(true)
Either<Bool, Void>.left(false)
Either<Bool, Void>.right(())
// Either<Bool, Void> = 3 = 2 + 1
// 2 + 1

Either<Bool, Never>.left(true)
Either<Bool, Never>.left(false)
//Either<Bool, Never>.right(???)
// Either<Bool, Never> = 2 = 2 + 0
// 2 + 0

struct Unit {}
// enum Never {}

let unit = Unit()

extension Unit: Equatable {
  static func == (lhs: Unit, rhs: Unit) -> Bool {
    return true
  }
}

//extension Void {}



func sum(_ xs: [Int]) -> Int {
  var result: Int = 0
  for x in xs {
    result += x
  }
  return result
}

func product(_ xs: [Int]) -> Int {
  var result: Int = 1
  for x in xs {
    result *= x
  }
  return result
}

let xs = [Int]()
sum(xs)
product(xs)

sum([1, 2]) + 0 == sum([1, 2])
product([1, 2]) * 1 == product([1, 2])

// Void = 1
// A * 1 = A = 1 * A

// Never = 0
// A * 0 = 0 = 0 * A

// A + 0 = A = 0 + A

// A + 1 = 1 + A = A?

//Either<A, Void>

//Either<Pair<A, B>, Pair<A, C>>

// A * B + A * C = A * (B + C)

//Pair<A, Either<B, C>>


// Pair<Either<A, B>, Either<A, C>>

// (A + B) * (A + C)
// A * A + A * C + B * A + B * C

import Foundation

//URLSession.shared
//  .dataTask(with: <#T##URL#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)

// (Data + 1) * (URLResponse + 1) * (Error + 1)
//   = Data * URLResponse * Error
//     + Data * URLResponse
//     + URLResponse * Error
//     + Data * Error
//     + Data
//     + URLResponse
//     + Error
//     + 1

// NB: It was brought to our attention by one of our viewers, [Ole Begemann](https://twitter.com/olebegemann),
//     that it is in fact possible for `URLResponse` and `Error` to be non-`nil` at the same time.
//     He wrote a great [blog post](https://oleb.net/blog/2018/03/making-illegal-states-unrepresentable/) about this,
//     and we discuss this correction at the beginning of our follow up episode,
//     [Algebraic Data Types: Exponents](https://www.pointfree.co/episodes/ep9-algebraic-data-types-exponents).

// Data * URLResponse + Error

//Either<Pair<Data, URLResponse>, Error>
//Result<(Data, URLResponse), Error>
//Result<Date, Never>
//Result<A, Error>?
//: [See the next page](@next) for exercises!
