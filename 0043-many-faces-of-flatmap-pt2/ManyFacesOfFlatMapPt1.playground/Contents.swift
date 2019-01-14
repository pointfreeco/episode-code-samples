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


//extension Optional {
//  public func flatMap<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U?
//}


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
}

struct Func<A, B> {
  let run: (A) -> B

  func map<C>(_ f: @escaping (B) -> C) -> Func<A, C> {
//    return Func<A, C> { a in
//      f(self.run(a))
//    }
    return Func<A, C>(run: self.run >>> f)
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
//words
//  .run(())
//
//randomNumber.map { number in
//  words.map { words in
//    words[number]
//  }
//}
//
//randomNumber.map { number in
//  words.map { words in
//    words[number]
//  }
//}.run(()).run(())


struct Parallel<A> {
  let run: (@escaping (A) -> Void) -> Void

  func map<B>(_ f: @escaping (A) -> B) -> Parallel<B> {
    return Parallel<B> { callback in
      self.run { a in callback(f(a)) }
    }
  }

  func flatMap<B>(_ f: @escaping (A) -> Parallel<B>) -> Parallel<B> {
    return Parallel<B> { callback in
      self.run { a in f(a).run(callback) }
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


//delay(by: 1).run { print("Executed after 1 second") }
//delay(by: 2).run { print("Executed after 2 seconds") }
//
//let aDelayedInt = delay(by: 3).map { 42 }
//aDelayedInt.run { value in print("We got \(value)") }
//
//aDelayedInt.map { value in
//  delay(by: 1).map { value + 1729 }
//}
//
//aDelayedInt.map { value in
//  delay(by: 1).map { value + 1729 }
//  }.run { innerParallel in
//    innerParallel.run { value in
//      print("We got \(value)")
//    }
//}


// extension Sequence {
//   public func flatMap<SegmentOfResult>(
//     _ transform: (Self.Element) throws -> SegmentOfResult
//   ) rethrows -> [SegmentOfResult.Element]
//   where SegmentOfResult : Sequence {
//   }
// }


extension Result {
  func flatMap<B>(_ transform: (A) -> Result<B, E>) -> Result<B, E> {
    switch self {
    case let .success(value):
      return transform(value)
    case let .failure(error):
      return .failure(error)
    }
  }
}

struct RequireSomeError: Error {
  let message = "Value is nil"
}

func requireSome<A>(_ value: A?) -> Result<A, Swift.Error> {
  return value.map(Result.success)
    ?? Result.failure(RequireSomeError())
}
func requireSome<A>(_ value: A?) throws -> A {
  guard let value = value else { throw RequireSomeError() }
  return value
}

extension Result where E == Swift.Error {
  init(catching: () throws -> A) {
    do {
      self = .success(try catching())
    } catch let error {
      self = .failure(error)
    }
  }

  func `try`<B>(_ f: @escaping (A) throws -> B) -> Result<B, E> {
    return self.flatMap { a in Result<B, E> { try f(a) } }
  }
}

struct User: Codable {
  let id: Int
  let email: String
  let name: String
  let invoicesUrl: String
}


Bundle.main.path(forResource: "user", ofType: "json")
  .map(URL.init(fileURLWithPath:))
  .flatMap { try? Data.init(contentsOf: $0) }
  .flatMap { try? JSONDecoder().decode(User.self, from: $0) }

requireSome(Bundle.main.path(forResource: "user", ofType: "json"))
  .map(URL.init(fileURLWithPath:))
  .flatMap { url in Result { try Data(contentsOf: url) } }
  .flatMap { data in Result { try JSONDecoder().decode(User.self, from: data) } }

func request(_ urlString: String) -> Parallel<Data> {
  return Parallel { callback in
    URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
      callback(data!)
    }.resume()
  }
}

extension Parallel {
  init(_ work: @escaping () -> A) {
    self = Parallel { callback in
      DispatchQueue.global().async {
        callback(work())
      }
    }
  }
}

//https://s3.amazonaws.com/pointfreeco-episodes-processed/0044-the-many-faces-of-flatmap-pt3/episode-assets/user.json

//requireSome(Bundle.main.path(forResource: "user", ofType: "json"))
//  .map(URL.init(fileURLWithPath:))
//  .flatMap { url in Result { try Data(contentsOf: url) } }

struct Invoices: Codable {
  let invoices: [Invoice]
  struct Invoice: Codable {
    let id: Int
    let amountPaid: Int
    let amountDue: Int
  }
}

request("https://s3.amazonaws.com/pointfreeco-episodes-processed/0044-the-many-faces-of-flatmap-pt3/episode-assets/users/42.json")
  .flatMap { data in Parallel { try! JSONDecoder().decode(User.self, from: data) } }
  .map { $0.invoicesUrl }
  .flatMap(request)
  .flatMap { data in Parallel { try! JSONDecoder().decode(Invoices.self, from: data) } }
  .run { user in
    print(user)
}

try JSONDecoder().decode(
  User.self,
  from: Data(
    contentsOf: URL(fileURLWithPath:
      requireSome(Bundle.main.path(forResource: "user", ofType: "json"))
    )
  )
)

//Data.init
String.init(contentsOf:)
Data.init(contentsOf:options:)
//fromThrowing(Data.init(contentsOf:))

2
//
//func compute(_ a: Double, _ b: Double) -> Validated<Double, String> {
//  if a < 0 && b == 0 {
//    return .invalid(NonEmptyArray("First argument must be non-negative", "Second argument must be non-zero."))
//  } else if a < 0 {
//    return .invalid(NonEmptyArray("First argument must be non-negative"))
//  } else if b == 0 {
//    return .invalid(NonEmptyArray("Second argument must be non-zero."))
//  }
//  return .valid(sqrt(a) / b)
//}
