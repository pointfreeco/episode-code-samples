
struct Pair<A, B> {
  let first: A
  let second: B
}

Pair<Void, Void>.init(first: (), second: ())

Pair<Bool, Void>.init(first: true, second: ())
Pair<Bool, Void>.init(first: false, second: ())

Pair<Bool, Bool>.init(first: true, second: true)
Pair<Bool, Bool>.init(first: true, second: false)
Pair<Bool, Bool>.init(first: false, second: true)
Pair<Bool, Bool>.init(first: false, second: false)

enum Three { case one, two, three }
Pair<Bool, Three>.init(first: true, second: .one)
Pair<Bool, Three>.init(first: false, second: .one)
Pair<Bool, Three>.init(first: true, second: .two)
Pair<Bool, Three>.init(first: false, second: .two)
Pair<Bool, Three>.init(first: true, second: .three)
Pair<Bool, Three>.init(first: false, second: .three)

//Pair<Bool, Never>.init(first: true, second: <#T##Never#>)

enum Either<A, B> {
  case left(A)
  case right(B)
}

Either<Void, Void>.left(())
Either<Void, Void>.right(())

Either<Bool, Void>.left(true)
Either<Bool, Void>.left(false)
Either<Bool, Void>.right(())

Either<Bool, Bool>.left(true)
Either<Bool, Bool>.left(false)
Either<Bool, Bool>.right(true)
Either<Bool, Bool>.right(false)

Either<Bool, Three>.left(true)
Either<Bool, Three>.left(false)
Either<Bool, Three>.right(.one)
Either<Bool, Three>.right(.two)
Either<Bool, Three>.right(.three)

Either<Bool, Never>.left(true)
Either<Bool, Never>.left(false)
//Either<Bool, Never>.right(???)


struct User {
  let id: Int
  let isAdmin: Bool
  let name: String
}

User.init

[1, 2, 3, 4].map(String.init)

["1", "2", "blob", "3"].compactMap(Int.init)

Either<Int, String>.left
Either<Int, String>.right

[1, 2, 3, 4].map(Either<Int, String>.left)

let value = Either<Int, String>.left(42)
switch value {
case let .left(left):
  print(left)
case let .right(right):
  print(right)
}

func compute(_ xs: [Int]) -> (product: Int, sum: Int, average: Double) {
  var product = 1
  var sum = 0
  xs.forEach { x in
    product *= x
    sum += x
  }
  return (product, sum, Double(sum) / Double(xs.count))
}

let result = compute([1, 2, 3, 4, 5])
result.product
result.sum

let (product, sum, average) = compute([1, 2, 3, 4, 5])
product
sum
average


let tuple: (id: Int, name: String) = (42, "Blob")

[1, 2, 3].map { $0 + 1 }

tuple.0
tuple.1
tuple.id
tuple.name

[1, 2, 3, 4, 5].reduce((product: 1, sum: 0)) { accum, x in
  (accum.product * x, accum.sum + x)
}

3 * 4
//3 + 4

//3 `addThreeToFour` 4


let _: (Int, String)

let choice: (Int | String) = .0(42)
let choice: (Int | String) = .1("Blob")

let choice: (id: Int | param: String) = .id(42)
let choice: (id: Int | param: String) = .param("Blob")

switch choice {
case let .0(id):
  print(id)
case let .1(param):
  print(param)
}

switch choice {
case let .id(id):
  print(id)
case let .param(param):
  print(param)
}

//enum Optional<A> {
//  case some(A)
//  case none
//}

enum Loading<A> {
  case some(A)
  case loading
}

enum EmptyCase<A> {
  case some(A)
  case emptyState
}

//Loading<EmptyCase<[User]>>

func render(data: (user: [User] | empty | loading | )) {
  switch data {

  }
}
