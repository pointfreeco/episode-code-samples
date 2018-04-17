@_exported import Foundation
@_exported import UIKit

precedencegroup ForwardApplication {
  associativity: left
}
infix operator |>: ForwardApplication
public func |> <A, B>(x: A, f: (A) -> B) -> B {
  return f(x)
}
public func |> <A: AnyObject>(x: A, f: (A) -> Void) -> Void {
  f(x)
}

precedencegroup EffectfulComposition {
  associativity: left
  higherThan: ForwardApplication
}
infix operator >=>: EffectfulComposition
public func >=> <A, B, C>(
  _ f: @escaping (A) -> (B, [String]),
  _ g: @escaping (B) -> (C, [String])
  ) -> ((A) -> (C, [String])) {

  return { a in
    let (b, logs) = f(a)
    let (c, moreLogs) = g(b)
    return (c, logs + moreLogs)
  }
}

precedencegroup ForwardComposition {
  associativity: left
  higherThan: EffectfulComposition
}
infix operator >>>: ForwardComposition
public func >>> <A, B, C>(
  f: @escaping (A) -> B,
  g: @escaping (B) -> C
  ) -> ((A) -> C) {

  return { a in g(f(a)) }
}

precedencegroup SingleTypeComposition {
  associativity: left
  higherThan: ForwardApplication
}
infix operator <>: SingleTypeComposition
public func <> <A: AnyObject>(f: @escaping (A) -> Void, g: @escaping (A) -> Void) -> (A) -> Void {
  return { a in
    f(a)
    g(a)
  }
}

public func incr(_ x: Int) -> Int {
  return x + 1
}
public func square(_ x: Int) -> Int {
  return x * x
}
