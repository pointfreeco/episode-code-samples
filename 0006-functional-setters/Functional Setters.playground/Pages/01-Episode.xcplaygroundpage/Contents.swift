
let pair = (42, "Swift")

(incr(pair.0), pair.1)

func incrFirst<A>(_ pair: (Int, A)) -> (Int, A) {
  return (incr(pair.0), pair.1)
}

incrFirst(pair)

func first<A, B, C>(_ f: @escaping (A) -> C) -> ((A, B)) -> (C, B) {
  return { pair in
    (f(pair.0), pair.1)
  }
}

pair
  |> first(incr)
  |> first(String.init)

func second<A, B, C>(_ f: @escaping (B) -> C) -> ((A, B)) -> (A, C) {
  return { pair in
    (pair.0, f(pair.1))
  }
}

pair
  |> first(incr)
  |> first(String.init)
  |> second { $0 + "!" }


pair
  |> first(incr)
  |> first(String.init)
  |> second(zurry(flip(String.uppercased)))

pair
  |> first(incr >>> String.init)
  |> second(zurry(flip(String.uppercased)))

first(incr)
  >>> first(String.init)
  >>> second(zurry(flip(String.uppercased)))

var copyPair = pair
copyPair.0 += 1
//copyPair.0 = String(copyPair.0)
copyPair.1 = copyPair.1.uppercased()

let nested = ((1, true), "Swift")

nested
  |> first { $0 |> second { !$0 } }

nested
  |> (second >>> first) { !$0 }

precedencegroup BackwardsComposition {
  associativity: left
}
infix operator <<<: BackwardsComposition
func <<< <A, B, C>(_ f: @escaping (B) -> C, _ g: @escaping (A) -> B) -> (A) -> C {
  return { f(g($0)) }
}

nested
  |> (first <<< second) { !$0 }

nested
  |> (first <<< first)(incr)
  |> (first <<< second) { !$0 }
  |> second { $0 + "!" }

//let transformation = (first <<< first)(incr)
//  <> (first <<< second) { !$0 }
//  <> second { $0 + "!" }
//
//nested |> transformation

// ((A) -> B) -> (S) -> T

// ((A) -> B) -> ((A, C)) -> (B, C)
// ((A) -> B) -> ((C, A)) -> (C, B)

// ((A) -> B) -> ([A]) -> [B]

public func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
  return { xs in xs.map(f) }
}

(42, ["Swift", "Objective-C"])
  |> (second <<< map) { $0 + "!" }
  |> first(incr)

dump(
[(42, ["Swift", "Objective-C"]), (1729, ["Haskell", "PureScript"])]
  |> (map <<< second <<< map) { $0 + "!" }
)

//

let data = [(42, ["Swift", "Objective-C"]), (1729, ["Haskell", "PureScript"])]

data
  .map { ($0.0, $0.1.map { $0 + "!" }) }
//: [See the next page](@next) for exercises!
