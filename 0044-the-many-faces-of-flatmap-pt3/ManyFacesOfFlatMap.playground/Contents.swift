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


















