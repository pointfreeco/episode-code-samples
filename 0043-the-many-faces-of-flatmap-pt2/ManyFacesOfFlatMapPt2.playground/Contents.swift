import Foundation

func combos<A, B>(_ xs: [A], _ ys: [B]) -> [(A, B)] {
//  var result: [(A, B)] = []
//  xs.forEach { x in
//    ys.forEach { y in
//      result.append((x, y))
//    }
//  }
//  return result

  return xs.flatMap { x in
    ys.map { y in
      (x, y)
    }
  }

//  return Array(zip(xs, ys))
}


combos([1, 2, 3], ["a", "b"])
// [(1, "a"), (1, "b"), (2, "a"), (2, "b"), (3, "a"), (3, "b")]


let scores = """
1,2,3,4
5,6
7,8,9
"""

var allScores: [Int] = []
scores.split(separator: "\n").forEach { line in
  line.split(separator: "," ).forEach { value in
    allScores.append(Int(value) ?? 0)
  }
}
allScores

scores.split(separator: "\n").map { line in
  line.split(separator: "," ).map { value in
    Int(value) ?? 0
  }
}

scores.split(separator: "\n").flatMap { line in
  line.split(separator: "," ).map { value in
    Int(value) ?? 0
  }
}

//extension Sequence {
//  func flatMap<SegmentOfResult>(_ transform: (Self.Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence {
//  }
//}

extension Array {
  func flatMap<NewElement>(_ f: (Element) -> [NewElement]) -> [NewElement] {
    var result: [NewElement] = []
    for element in self {
      result.append(contentsOf: f(element))
    }
    return result
  }
}


//extension Optional {
//  public func flatMap<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U?
//}
extension Optional {
  public func flatMap<U>(_ transform: (Wrapped) -> U?) -> U? {
    switch self {
    case let .some(wrapped):
      return transform(wrapped)
    case .none:
      return Optional<U>.none
    }
  }
}



let strings = ["42", "Blob", "functions"]

strings.first
type(of: strings.first)

strings.first.map(Int.init)
type(of: strings.first.map(Int.init))

strings.first.flatMap(Int.init)
type(of: strings.first.flatMap(Int.init))

// ((A) -> B) -> (A?) -> B?
// Int.init: (String) -> Int?
// A = String
// B = Int?
// ((String) -> Int?) -> (String?) -> Int??


if let x = strings.first.map(Int.init), let y = x {
  type(of: y)
}

if case let .some(.some(x)) = strings.first.map(Int.init) {
  type(of: x)
}
if case let x?? = strings.first.map(Int.init) {
  type(of: x)
}

switch strings.first.map(Int.init) {
case let .some(.some(value)):
  print(value)
case .some(.none):
  print(".some(.none)")
case .none:
  print(".none")
}


enum Result<A, E> {
  case success(A)
  case failure(E)

  func map<B>(_ f: @escaping (A) -> B) -> Result<B, E> {
    switch self {
    case let .success(a):
      return .success(f(a))
    case let .failure(e):
      return .failure(e)
    }
  }

  public func flatMap<B>(_ transform: (A) -> Result<B, E>) -> Result<B, E> {
    switch self {
    case let .success(value):
      return transform(value)
    case let .failure(error):
      return .failure(error)
    }
  }
}

Result<Double, String>.success(42.0)
  .map { $0 + 1 }

func compute(_ a: Double, _ b: Double) -> Result<Double, String> {
  guard a >= 0 else { return .failure("First argument must be non-negative.") }
  guard b != 0 else { return .failure("Second argument must be non-zero.") }
  return .success(sqrt(a) / b)
}

compute(-1, 1729)
compute(42, 0)
print(type(of:
  compute(42, 1729)
    .map { compute($0, $0) }
  ))

compute(42, 1729)
  .flatMap { compute($0, $0) }
  .flatMap { compute($0, $0) }
  .flatMap { compute($0, $0) }
  .flatMap { compute($0, $0) }


switch compute(42, 1729).map({ compute($0, $0) }) {
case let .success(.success(value)):
  print(value)
case let .success(.failure(error)):
  print(error)
case let .failure(error):
  print(error)
}


import NonEmpty

enum Validated<A, E> {
  case valid(A)
  case invalid(NonEmptyArray<E>)

  func map<B>(_ f: @escaping (A) -> B) -> Validated<B, E> {
    switch self {
    case let .valid(a):
      return .valid(f(a))
    case let .invalid(e):
      return .invalid(e)
    }
  }


  public func flatMap<B>(_ transform: (A) -> Validated<B, E>) -> Validated<B, E> {
    switch self {
    case let .valid(value):
      return transform(value)
    case let .invalid(error):
      return .invalid(error)
    }
  }
}

struct Func<A, B> {
  let run: (A) -> B

  func map<C>(_ f: @escaping (B) -> C) -> Func<A, C> {
//    return Func<A, C> { a in
//      f(self.run(a))
//    }
    return Func<A, C>(run: self.run >>> f)
  }

  func flatMap<C>(_ f: @escaping (B) -> Func<A, C>) -> Func<A, C> {
    return Func<A, C> { a -> C in
      f(self.run(a)).run(a)
    }
  }
}

// >>>


let randomNumber = Func<Void, Int> {
  let number = try! String(contentsOf: URL(string: "https://www.random.org/integers/?num=1&min=1&max=235866&col=1&base=10&format=plain&rnd=new")!)
    .trimmingCharacters(in: .newlines)
  return Int(number)!
}

randomNumber.map { $0 + 1 }
randomNumber
  .map { $0 + 1 }
  .run(())


let words = Func<Void, [String]> {
  (try! String(contentsOf: URL(fileURLWithPath: "/usr/share/dict/words")))
    .split(separator: "\n")
    .map(String.init)
}

words
words
  .run(())

randomNumber.map { number in
  words.map { words in
    words[number]
  }
}

randomNumber.map { number in
  words.map { words in
    words[number]
  }
}.run(()).run(())

randomNumber.flatMap { number in
  words.map { words in
    words[number]
  }
  }.run(())


struct Parallel<A> {
  let run: (@escaping (A) -> Void) -> Void

  func map<B>(_ f: @escaping (A) -> B) -> Parallel<B> {
    return Parallel<B> { callback in
      self.run { a in callback(f(a)) }
    }
  }

  func flatMap<B>(_ f: @escaping (A) -> Parallel<B>) -> Parallel<B> {
    return Parallel<B> { callback in
      self.run { a in
        f(a).run(callback)
      }
    }
  }
}


func delay(by duration: TimeInterval, line: UInt = #line) -> Parallel<Void> {
  return Parallel { callback in
    print("Delaying line \(line) by \(duration)")
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      callback(())
      print("Executed line \(line)")
    }
  }
}


delay(by: 1).run { print("Executed after 1 second") }
delay(by: 2).run { print("Executed after 2 seconds") }

let aDelayedInt = delay(by: 3).map { 42 }
aDelayedInt.run { value in print("We got \(value)") }

aDelayedInt.map { value in
  delay(by: 1).map { value + 1729 }
}

aDelayedInt.map { value in
  delay(by: 1).map { value + 1729 }
  }.run { innerParallel in
    innerParallel.run { value in
      print("We got \(value)")
    }
}

aDelayedInt
  .flatMap { value in delay(by: 1).map { value + 1729 } }
  .flatMap { value in delay(by: 1).map { value + 1729 } }
  .flatMap { value in delay(by: 1).map { value + 1729 } }
  .flatMap { value in delay(by: 1).map { value + 1729 } }
  .run { value in
    print("We got \(value)")
}



// extension Sequence {
//   public func flatMap<SegmentOfResult>(
//     _ transform: (Self.Element) throws -> SegmentOfResult
//   ) rethrows -> [SegmentOfResult.Element]
//   where SegmentOfResult : Sequence {
//   }
// }


// map:        ((A)    ->  C ) -> (([A])      -> [C])
// zip(with:): ((A, B) ->  C ) -> (([A], [B]) -> [C])
// flatMap:    ((A)    -> [C]) -> (([A])      -> [C])

// map:        ((A)    -> C ) -> ((A?)     -> C?)
// zip(with:): ((A, B) -> C ) -> ((A?, B?) -> C?)
// flatMap:    ((A)    -> C?) -> ((A?)     -> C?)

// map:        ((A)    ->        C    ) -> ((Result<A, E>)               -> Result<C, E>)
// zip(with:): ((A, B) ->        C    ) -> ((Result<A, E>, Result<B, E>) -> Result<C, E>)
// flatMap:    ((A)    -> Result<C, E>) -> ((Result<A, E>)               -> Result<C, E>)

// map:        ((A)    ->           C    ) -> ((Validated<A, E>)                  -> Validated<C, E>)
// zip(with:): ((A, B) ->           C    ) -> ((Validated<A, E>, Validated<B, E>) -> Validated<C, E>)
// flatMap:    ((A)    -> Validated<C, E>) -> ((Validated<A, E>)                  -> Validated<C, E>)

// map:        ((B)    ->         D ) -> ((Func<A, B>)             -> Func<A, D>)
// zip(with:): ((B, C) ->         D ) -> ((Func<A, B>, Func<A, C>) -> Func<A, D>)
// flatMap:    ((B)    -> Func<A, D>) -> ((Func<A, B>)             -> Func<A, D>)

// map:        ((A)    ->          C ) -> ((Parallel<A>)              -> Parallel<C>)
// zip(with:): ((A, B) ->          C ) -> ((Parallel<A>, Parallel<B>) -> Parallel<C>)
// flatMap:    ((A)    -> Parallel<C>) -> ((Parallel<A>)              -> Parallel<C>)




// map:        ((A)    ->   C ) -> ((F<A>)       -> F<C>)
// zip(with:): ((A, B) ->   C ) -> ((F<A>, F<B>) -> F<C>)
// flatMap:    ((A)    -> F<C>) -> ((F<A>)       -> F<C>)

// F<A> = Array<A>
// F<A> = Optional<A>
// F<A> = Result<A, E>
// F<A> = Validated<A, E>
// F<A> = Func<A0, A>
// F<A> = Parallel<A>
