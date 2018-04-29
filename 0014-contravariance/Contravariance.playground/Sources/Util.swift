@_exported import Foundation
@_exported import UIKit

precedencegroup ForwardApplication {
  associativity: left
  higherThan: AssignmentPrecedence
}

infix operator |>: ForwardApplication

precedencegroup ForwardComposition {
  associativity: left
  higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

public func |> <A, B>(x: A, f: (A) -> B) -> B {
  return f(x)
}

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
  return { g(f($0)) }
}

public func zurry<A>(_ f: () -> A) -> A {
  return f()
}

public func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {

  return { b in { a in f(a)(b) } }
}

public func flip<A, C>(_ f: @escaping (A) -> () -> C) -> () -> (A) -> C {

  return { { a in f(a)() } }
}


precedencegroup SingleTypeComposition {
  associativity: left
  higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition

public func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
  return f >>> g
}

public func <> <A>(f: @escaping (inout A) -> Void, g: @escaping (inout A) -> Void) -> (inout A) -> Void {
  return { a in
    f(&a)
    g(&a)
  }
}

public func incr(_ x: Int) -> Int {
  return x + 1
}

public func square(_ x: Int) -> Int {
  return x * x
}

precedencegroup BackwardsComposition {
  associativity: left
}
infix operator <<<: BackwardsComposition
public func <<< <A, B, C>(_ f: @escaping (B) -> C, _ g: @escaping (A) -> B) -> (A) -> C {
  return { f(g($0)) }
}

public func first<A, B, C>(_ f: @escaping (A) -> C) -> ((A, B)) -> (C, B) {
  return { pair in
    return (f(pair.0), pair.1)
  }
}

public func second<A, B, C>(_ f: @escaping (B) -> C) -> ((A, B)) -> (A, C) {
  return { pair in
    return (pair.0, f(pair.1))
  }
}

public func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
  return { $0.map(f) }
}

public func map<A, B>(_ f: @escaping (A) -> B) -> (A?) -> B? {
  return { $0.map(f) }
}

public func with<A, B>(_ a: A, _ f: (A) -> B) -> B {
  return f(a)
}

public func with<A>(_ a: inout A, _ f: (inout A) -> Void) -> Void {
  f(&a)
}

public func concat<A>(
  _ f1: @escaping (A) -> A,
  _ f2: @escaping (A) -> A,
  _ fs: ((A) -> A)...
  )
  -> (A) -> A {

    return { a in
      fs.reduce(f2(f1(a))) { a, f in f(a) }
    }
}

public func concat<A: AnyObject>(
  _ f1: @escaping (inout A) -> Void,
  _ f2: @escaping (inout A) -> Void,
  _ fs: ((inout A) -> Void)...
  )
  -> (inout A) -> Void {

    return { a in
      f1(&a)
      f2(&a)
      fs.forEach { f in f(&a) }
    }
}

prefix operator ^

public prefix func ^ <Root, Value>(kp: KeyPath<Root, Value>) -> (Root) -> Value {
  return { $0[keyPath: kp] }
}
