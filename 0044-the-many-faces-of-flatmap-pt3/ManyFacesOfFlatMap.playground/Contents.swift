import Foundation

func combos<A, B>(_ xs: [A], _ ys: [B]) -> [(A, B)] {
  return xs.flatMap { x in
    ys.map { y in
      (x, y)
    }
  }
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
    return Func<A, C>(run: self.run >>> f)
  }

  func flatMap<C>(_ f: @escaping (B) -> Func<A, C>) -> Func<A, C> {
    return Func<A, C> { a -> C in
      f(self.run(a)).run(a)
    }
  }
}

let randomNumber = Func<Void, Int> {
  let number = try! String(contentsOf: URL(string: "https://www.random.org/integers/?num=1&min=1&max=235866&col=1&base=10&format=plain&rnd=new")!)
    .trimmingCharacters(in: .newlines)
  return Int(number)!
}

let words = Func<Void, [String]> {
  (try! String(contentsOf: URL(fileURLWithPath: "/usr/share/dict/words")))
    .split(separator: "\n")
    .map(String.init)
}

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
      print("Finished line \(line)")
      callback(())
    }
  }
}



struct User: Codable {
  let email: String
  let id: Int
  let name: String
}

//let user: User?
//if let path = Bundle.main.path(forResource: "user", ofType:  "json"),
//  case let url = URL.init(fileURLWithPath: path),
//  let data = try? Data.init(contentsOf: url) {
//
//  user = try? JSONDecoder().decode(User.self, from: data)
//} else {
//  user = nil
//}

let newUser = Bundle.main.path(forResource: "user", ofType: "json")
  .map(URL.init(fileURLWithPath:))
  .flatMap { try? Data.init(contentsOf: $0) }
  .flatMap { try? JSONDecoder().decode(User.self, from: $0) }


struct Invoice: Codable {
  let amountDue: Int
  let amountPaid: Int
  let closed: Bool
  let id: Int
}

let invoices = Bundle.main.path(forResource: "invoices", ofType: "json")
  .map(URL.init(fileURLWithPath:))
  .flatMap { try? Data.init(contentsOf: $0) }
  .flatMap { try? JSONDecoder().decode([Invoice].self, from: $0) }

if let newUser = newUser, let invoices = invoices {
  //
}

func zip<A, B>(_ a: A?, _ b: B?) -> (A, B)? {
  if let a = a, let b = b { return (a, b) }
  return nil
}

zip(newUser, invoices)

struct UserEnvelope {
  let user: User
  let invoices: [Invoice]
}

func zip<A, B, C>(with f: @escaping (A, B) -> C) -> (A?, B?) -> C? {
  return { zip($0, $1).map(f) }
}

struct SomeExpected: Error {}

func requireSome<A>(_ a: A?) throws -> A {
  guard let a = a else { throw SomeExpected() }
  return a
}

do {
  let path = try requireSome(Bundle.main.path(forResource: "user", ofType:  "json"))
  let url = URL.init(fileURLWithPath: path)
  let data = try Data.init(contentsOf: url)
  let user = try JSONDecoder().decode(User.self, from: data)
} catch {

}


extension Result where E == Swift.Error {
  init(catching f: () throws -> A) {
    do {
      self = .success(try f())
    } catch {
      self = .failure(error)
    }
  }
}

extension Validated where E == Swift.Error {
  init(catching f: () throws -> A) {
    do {
      self = .valid(try f())
    } catch {
      self = .invalid(NonEmptyArray(error))
    }
  }
}



func zip<A, B, E>(_ a: Result<A, E>, _ b: Result<B, E>) -> Result<(A, B), E> {
  switch (a, b) {
  case let (.success(a), .success(b)):
    return .success((a, b))
  case let (.failure(e), _):
    return .failure(e)
  case let (.success, .failure(e)):
    return .failure(e)
  }
}


func zip<A, B, C, E>(with f: @escaping (A, B) -> C) -> (Result<A, E>, Result<B, E>) -> Result<C, E> {
  return { zip($0, $1).map(f) }
}


func zip<A, B, E>(_ a: Validated<A, E>, _ b: Validated<B, E>) -> Validated<(A, B), E> {
  switch (a, b) {
  case let (.valid(a), .valid(b)):
    return .valid((a, b))
  case let (.valid, .invalid(e)):
    return .invalid(e)
  case let (.invalid(e), .valid):
    return .invalid(e)
  case let (.invalid(e1), .invalid(e2)):
    return .invalid(e1 + e2)
  }
}

func zip<A, B, C, E>(with f: @escaping (A, B) -> C) -> (Validated<A, E>, Validated<B, E>) -> Validated<C, E> {
  return { zip($0, $1).map(f) }
}


zip(with: UserEnvelope.init)(
  Bundle.main.path(forResource: "user", ofType: "json")
    .map(URL.init(fileURLWithPath:))
    .flatMap { try? Data.init(contentsOf: $0) }
    .flatMap { try? JSONDecoder().decode(User.self, from: $0) },

  Bundle.main.path(forResource: "invoices", ofType: "json")
    .map(URL.init(fileURLWithPath:))
    .flatMap { try? Data.init(contentsOf: $0) }
    .flatMap { try? JSONDecoder().decode([Invoice].self, from: $0) }
)

// failure(Swift.DecodingError.typeMismatch(Swift.Int, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "id", intValue: nil)], debugDescription: "Expected to decode Int but found a string/data instead.", underlyingError: nil)))
zip(with: UserEnvelope.init)(
  Result { try requireSome(Bundle.main.path(forResource: "user", ofType:  "json")) }
    .map(URL.init(fileURLWithPath:))
    .flatMap { url in Result { try Data.init(contentsOf: url) } }
    .flatMap { data in Result { try JSONDecoder().decode(User.self, from: data) } },

  Result { try requireSome(Bundle.main.path(forResource: "invoices", ofType:  "json")) }
    .map(URL.init(fileURLWithPath:))
    .flatMap { url in Result { try Data.init(contentsOf: url) } }
    .flatMap { data in Result { try JSONDecoder().decode([Invoice].self, from: data) } }
)

// invalid(typeMismatch(Swift.Int, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "id", intValue: nil)], debugDescription: "Expected to decode Int but found a string/data instead.", underlyingError: nil))[Swift.DecodingError.typeMismatch(Swift.Int, Swift.DecodingError.Context(codingPath: [_JSONKey(stringValue: "Index 0", intValue: 0), CodingKeys(stringValue: "amountDue", intValue: nil)], debugDescription: "Expected to decode Int but found a string/data instead.", underlyingError: nil))])
zip(with: UserEnvelope.init)(
  Validated { try requireSome(Bundle.main.path(forResource: "user", ofType:  "json")) }
    .map(URL.init(fileURLWithPath:))
    .flatMap { url in Validated { try Data.init(contentsOf: url) } }
    .flatMap { data in Validated { try JSONDecoder().decode(User.self, from: data) } },

  Validated { try requireSome(Bundle.main.path(forResource: "invoices", ofType:  "json")) }
    .map(URL.init(fileURLWithPath:))
    .flatMap { url in Validated { try Data.init(contentsOf: url) } }
    .flatMap { data in Validated { try JSONDecoder().decode([Invoice].self, from: data) } }
)

let lazyUser = Func { Bundle.main.path(forResource: "user", ofType:  "json")! }
  .map(URL.init(fileURLWithPath:))
  .flatMap { url in Func { try! Data.init(contentsOf: url) } }
  .flatMap { data in Func { try! JSONDecoder().decode(User.self, from: data) } }

lazyUser.run(())


func zip<A, B, C>(_ ab: Func<A, B>, _ ac: Func<A, C>) -> Func<A, (B, C)> {
  return Func<A, (B, C)> { a in
    (ab.run(a), ac.run(a))
  }
}

func zip<A, B, C, D>(with f: @escaping (B, C) -> D) -> (Func<A, B>, Func<A, C>) -> Func<A, D> {
  return { zip($0, $1).map(f) }
}

zip(with: UserEnvelope.init)(
  Func { Bundle.main.path(forResource: "user", ofType:  "json")! }
    .map(URL.init(fileURLWithPath:))
    .flatMap { url in Func { try! Data.init(contentsOf: url) } }
    .flatMap { data in Func { try! JSONDecoder().decode(User.self, from: data) } },

  Func { Bundle.main.path(forResource: "invoices", ofType:  "json")! }
    .map(URL.init(fileURLWithPath:))
    .flatMap { url in Func { try! Data.init(contentsOf: url) } }
    .flatMap { data in Func { try! JSONDecoder().decode([Invoice].self, from: data) } }
)

extension Parallel {
  init(_ work: @autoclosure @escaping () -> A) {
    self = Parallel { callback in
      DispatchQueue.global().async {
        callback(work())
      }
    }
  }
}

Parallel(Bundle.main.path(forResource: "user", ofType:  "json")!)
  .map(URL.init(fileURLWithPath:))
  .flatMap { url in Parallel(try! Data.init(contentsOf: url)) }
  .flatMap { data in Parallel(try! JSONDecoder().decode(User.self, from: data)) }

func zip<A, B>(_ pa: Parallel<A>, _ pb: Parallel<B>) -> Parallel<(A, B)> {
  return Parallel<(A, B)> { callback in
    var optionalA: A?
    var optionalB: B?
    pa.run { a in
      optionalA = a
      if let b = optionalB { callback((a, b)) }
    }
    pb.run { b in
      optionalB = b
      if let a = optionalA { callback((a, b)) }
    }
  }
}

func zip<A, B, C>(with f: @escaping (A, B) -> C) -> (Parallel<A>, Parallel<B>) -> Parallel<C> {
  return { zip($0, $1).map(f) }
}

zip(with: UserEnvelope.init)(
  Parallel(Bundle.main.path(forResource: "user", ofType:  "json")!)
    .map(URL.init(fileURLWithPath:))
    .flatMap { url in Parallel(try! Data.init(contentsOf: url)) }
    .flatMap { data in Parallel(try! JSONDecoder().decode(User.self, from: data)) },

  Parallel(Bundle.main.path(forResource: "invoices", ofType:  "json")!)
    .map(URL.init(fileURLWithPath:))
    .flatMap { url in Parallel(try! Data.init(contentsOf: url)) }
    .flatMap { data in Parallel(try! JSONDecoder().decode([Invoice].self, from: data)) }
  ).run { env in
//    print(env)
}

//
//do {
//  let user = try JSONDecoder().decode(
//    User.self,
//    from: Data.init(
//      contentsOf: URL.init(
//        fileURLWithPath: requireSome(
//          Bundle.main.path(
//            forResource: "user",
//            ofType:  "json"
//          )
//        )
//      )
//    )
//  )
//} catch {
//
//}


//extension Sequence {
//  public func flatMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
//}

// flatMap: ((A) -> B?) -> ((F<A>) -> F<B>)


//func fromThrowing<A, B>(_ f: @escaping (A) throws -> B) -> (A) -> Result<B, Swift.Error> {
//  return { a in
//    do {
//      return .success(try f(a))
//    } catch let error {
//      return .failure(error)
//    }
//  }
//}
//
//func toThrowing<A, B>(_ f: @escaping (A) -> Result<B, Swift.Error>) -> ((A) throws -> B) {
//  return { a in
//    switch f(a) {
//    case let .success(value):
//      return value
//    case let .failure(error):
//      throw error
//    }
//  }
//}
//
//extension Result {
//  func map<B>(_ f: @escaping (A) -> Result<B, Swift.Error>) -> Result<B, Swift.Error> {
//    fatalError()
//  }
//
//  func flatMap<B>(_ f: @escaping (A) -> Result<Result<B, E>, Swift.Error>) -> Result<B, Swift.Error> {
//    fatalError()
//  }
//}

//extension Func /* <A, B> */ {
//  func flatMap<C>(_ f: @escaping (A) -> Func<C, B>) -> Func<C, B> {
//
//  }
//}

import XCTest
struct Diffing<Value> {
  let toData: (Value) -> Data
  let fromData: (Data) -> Value
  let diff: (Value, Value) -> (String, [XCTAttachment])?

  func flatMap<NewValue>(_ f: @escaping (Value) -> Diffing<NewValue>) -> Diffing<NewValue> {
    fatalError("Not possible to implement.")
  }
}

struct Snapshotting<Value, Format> {
  var pathExtension: String?
  let diffing: Diffing<Format>
  let snapshot: (Value) -> Format

  func flatMap<NewValue>(_ f: @escaping (Value) -> Snapshotting<NewValue, Format>) -> Snapshotting<NewValue, Format> {
    fatalError("Not possible to implement.")
  }

  func flatMap<NewFormat>(_ f: @escaping (Format) -> Snapshotting<Value, NewFormat>) -> Snapshotting<Value, NewFormat> {
    fatalError("Not possible to implement.")
  }
}


extension Parallel {
  func then<B>(_ f: @escaping (A) -> Parallel<B>) -> Parallel<B> {
    return self.flatMap(f)
  }
}

extension Parallel {
  func then<B>(_ f: @escaping (A) -> B) -> Parallel<B> {
    return self.map(f)
  }
}

Parallel(Bundle.main.path(forResource: "user", ofType:  "json")!)
  .then(URL.init(fileURLWithPath:))
  .then { url in Parallel(try! Data.init(contentsOf: url)) }
  .then { data in Parallel(try! JSONDecoder().decode(User.self, from: data)) }

Parallel(Bundle.main.path(forResource: "user", ofType:  "json")!)
  .map(URL.init(fileURLWithPath:))
  .flatMap { url in Parallel(try! Data.init(contentsOf: url)) }
  .flatMap { data in Parallel(try! JSONDecoder().decode(User.self, from: data)) }




func pipe<A, B, C>(
  _ lhs: @escaping (A) -> B,
  _ rhs: @escaping (B) -> C
  ) -> (A) -> C {
  return lhs >>> rhs
}

pipe({ $0 + 1 }, { $0 * $0 })
pipe({ $0 + 1 }, String.init)

let f = { $0 + 1 }
  >>> { $0 * $0 }
  >>> { $0 + 1 }


//_ = { try? Data.init(contentsOf: $0) }
//  >>> { try? JSONDecoder().decode(User.self, from: $0) }

func chain<A, B, C>(
  _ lhs: @escaping (A) -> B?,
  _ rhs: @escaping (B) -> C?
  ) -> (A) -> C? {
  return { a in
    lhs(a).flatMap(rhs)
  }
}

func >=> <A, B, C>(
  _ lhs: @escaping (A) -> B?,
  _ rhs: @escaping (B) -> C?
  ) -> (A) -> C? {
  return { a in
    lhs(a).flatMap(rhs)
  }
}


pipe(
  URL.init(fileURLWithPath:),
  chain(
    { try? Data.init(contentsOf: $0) },
    { try? JSONDecoder().decode(User.self, from: $0) }
  )
)

let loadUser = URL.init(fileURLWithPath:)
  >>> { try? Data.init(contentsOf: $0) }
  >=> { try? JSONDecoder().decode(User.self, from: $0) }

Bundle.main.path(forResource: "user", ofType: "json")
  .map(URL.init(fileURLWithPath:))
  .flatMap { try? Data.init(contentsOf: $0) }
  .flatMap { try? JSONDecoder().decode(User.self, from: $0) }

Bundle.main.path(forResource: "user", ofType: "json")
  .flatMap(loadUser)


// Parallel<Result<A, E>>

func map<A, B, E>(
  _ f: @escaping (A) -> B
  ) -> (Parallel<Result<A, E>>) -> Parallel<Result<B, E>> {

  return { parallelResultA in
    parallelResultA.map { resultA in
      resultA.map { a in
        f(a)
      }
    }
  }
}

func zip<A, B, E>(
  _ lhs: Parallel<Result<A, E>>,
  _ rhs: Parallel<Result<B, E>>
  ) -> Parallel<Result<(A, B), E>> {

  return zip(with: zip)(lhs, rhs)

//  return zip(lhs, rhs).map { resultA, resultB in
//    zip(resultA, resultB)
//  }
}

func flatMap<A, B, E>(
  _ f: @escaping (A) -> Parallel<Result<B, E>>
  ) -> (Parallel<Result<A, E>>) -> Parallel<Result<B, E>> {

  return { parallelResultA in
    parallelResultA.flatMap { resultA in
      Parallel<Result<B, E>> { callback in
        switch resultA {
        case let .success(a):
          f(a).run { resultB in callback(resultB) }
        case let .failure(error):
          callback(.failure(error))
        }
      }
    }
  }
}


extension Optional {
  func newMap<NewWrapped>(_ f: (Wrapped) -> NewWrapped) -> NewWrapped? {
    return self.flatMap { Optional<NewWrapped>.some(f($0)) }
  }
}

extension Array {
  func newMap<NewElement>(_ f: (Element) -> NewElement) -> [NewElement] {
    return self.flatMap { [f($0)] }
  }
}

extension Result {
  func newMap<B>(_ f: (A) -> B) -> Result<B, E> {
    return self.flatMap { .success(f($0)) }
  }
}

extension Validated {
  func newMap<B>(_ f: (A) -> B) -> Validated<B, E> {
    return self.flatMap { .valid(f($0)) }
  }
}

extension Func {
  func newMap<C>(_ f: @escaping (B) -> C) -> Func<A, C> {
    return self.flatMap { b in Func<A, C> { _ in f(b) } }
  }
}

extension Parallel {
  func newMap<B>(_ f: @escaping (A) -> B) -> Parallel<B> {
    return self.flatMap { a in Parallel<B> { callback in callback(f(a)) } }
  }
}

func newZip<A, B>(_ a: A?, _ b: B?) -> (A, B)? {
  return a.flatMap { a in
    b.flatMap { b in
      Optional.some((a, b))
    }
  }
}

func newZip<A, B>(_ a: [A], _ b: [B]) -> [(A, B)] {
  return a.flatMap { a in
    b.flatMap { b in
      [(a, b)]
    }
  }
}

newZip(["a", "b"], [1, 2])

func newZip<A, B, E>(_ a: Result<A, E>, _ b: Result<B, E>) -> Result<(A, B), E> {
  return a.flatMap { a in
    b.flatMap { b in
      Result.success((a, b))
    }
  }
}

func newZip<A, B, E>(_ a: Validated<A, E>, _ b: Validated<B, E>) -> Validated<(A, B), E> {
  return a.flatMap { a in
    b.flatMap { b in
      Validated.valid((a, b))
    }
  }
}

newZip(Validated<Int, String>.valid(1), .valid("Two"))


newZip(Validated<Int, String>.invalid(NonEmptyArray("Something went wrong.")), .valid(2))

newZip(
  Validated<Int, String>.invalid(NonEmptyArray("Something went wrong.")),
  Validated<Int, String>.invalid(NonEmptyArray("Something else went wrong."))
)

func newZip<A, B, C>(_ a: Func<A, B>, _ b: Func<A, C>) -> Func<A, (B, C)> {
  return a.flatMap { a in
    b.flatMap { b in
      Func { _ in (a, b) }
    }
  }
}

func newZip<A, B>(_ a: Parallel<A>, _ b: Parallel<B>) -> Parallel<(A, B)> {
  return a.flatMap { a in
    b.flatMap { b in
      Parallel { callback in callback((a, b)) }
    }
  }
}

newZip(delay(by: 2).map { 2 }, delay(by: 3).map { 3 }).run {
  print($0)
}





