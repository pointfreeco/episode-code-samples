// public func zip<Sequence1, Sequence2>(
//  _ sequence1: Sequence1,                  // A
//  _ sequence2: Sequence2                   // B
//  ) -> Zip2Sequence<Sequence1, Sequence2>  // (A, B)
//  where Sequence1 : Sequence, Sequence2 : Sequence {
//}

Array(zip([1, 2, 3], ["one", "two", "three"]))

let xs = [2, 3, 5, 7, 11]
Array(zip(xs.indices, xs))
Array(xs.enumerated())

let ys = xs.suffix(2)
Array(zip(ys.indices, ys))
Array(ys.enumerated())

Array(zip(xs.dropFirst(1), xs))

zip(xs.dropFirst(1), xs).forEach { p, q in
  p - q == 2
    ? print("\(p) and \(q) are twin primes!")
    : print("\(p) and \(q) are NOT twin primes :(")
}

for idx in xs.indices.dropFirst() {
  let p = xs[idx]
  let q = xs[xs.index(before: idx)]
  p - q == 2
    ? print("\(p) and \(q) are twin primes!")
    : print("\(p) and \(q) are NOT twin primes :(")
}


let titles = [
  "Functions",
  "Side Effects",
  "Styling with Functions",
  "Algebraic Data Types"
]

// 1.) Functions
// 2.) Side Effects
// 3.) Styling with Functions
// 4.) Algebraic Data Types

zip(1..., titles)
  .map { n, title in "\(n).) \(title)" }

func zip2<A, B>(_ xs: [A], _ ys: [B]) -> [(A, B)] {
  var result: [(A, B)] = []
  (0..<min(xs.count, ys.count)).forEach { idx in
    result.append((xs[idx], ys[idx]))
  }
  return result
}

zip2([1, 2, 3], ["one", "two", "three"])

func zip3<A, B, C>(_ xs: [A], _ ys: [B], _ zs: [C]) -> [(A, B, C)] {
  return zip2(xs, zip2(ys, zs)) // [(A, (B, C))]
    .map { a, bc in (a, bc.0, bc.1) }
}

zip3([1, 2, 3], ["one", "two", "three"], [true, false, true])

// zip2: ([A], [B]) -> [(A, B)]

func zip2<A, B, C>(
  with f: @escaping (A, B) -> C
  ) -> ([A], [B]) -> [C] {

  return { zip2($0, $1).map(f) }
}

func zip3<A, B, C, D>(
  with f: @escaping (A, B, C) -> D
  ) -> ([A], [B], [C]) -> [D] {

  return { zip3($0, $1, $2).map(f) }
}

// map:         ((A)       -> B) -> ([A])           -> [B]
// zip2(with:): ((A, B)    -> C) -> ([A], [B])      -> [C]
// zip3(with:): ((A, B, C) -> D) -> ([A], [B], [C]) -> [D]

zip2(with: +)([1, 2, 3], [4, 5, 6])

zip3(
  with: { $0 + $1 + $2 })([1, 2, 3], [4, 5, 6], [7, 8, 9])

func zip2<A, B>(_ a: A?, _ b: B?) -> (A, B)? {
  guard let a = a, let b = b else { return nil }
  return (a, b)
}

func zip3<A, B, C>(_ a: A?, _ b: B?, _ c: C?) -> (A, B, C)? {
  return zip2(a, zip2(b, c))
    .map { a, bc in (a, bc.0, bc.1) }
}

func zip2<A, B, C>(
  with f: @escaping (A, B) -> C
  ) -> (A?, B?) -> C? {

  return { zip2($0, $1).map(f) }
}

func zip3<A, B, C, D>(
  with f: @escaping (A, B, C) -> D
  ) -> (A?, B?, C?) -> D? {

  return { zip3($0, $1, $2).map(f) }
}

// (A?, B?) -> (A, B)?

let a: Int? = 1
let b: Int? = 2
let c: Int? = 3

zip2(a, b)
zip3(a, b, c)

zip2(with: +)(a, b)
zip3(
  with: { $0 + $1 + $2 })(a, b, c)

let d: Int?
if let a = a, let b = b, let c = c {
  d = a + b + c
} else {
  d = nil
}
d
