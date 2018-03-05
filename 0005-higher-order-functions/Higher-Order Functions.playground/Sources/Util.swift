// NB: `@_exported` will make foundation available in our playgrounds
@_exported import Foundation

precedencegroup ForwardApplication {
  associativity: left
}
infix operator |>: ForwardApplication
public func |> <A, B>(x: A, f: (A) -> B) -> B {
  return f(x)
}

precedencegroup ForwardComposition {
  associativity: left
  higherThan: ForwardApplication
}
infix operator >>>: ForwardComposition
public func >>> <A, B, C>(
  f: @escaping (A) -> B,
  g: @escaping (B) -> C
  ) -> ((A) -> C) {

  return { a in g(f(a)) }
}

public func incr(_ x: Int) -> Int {
  return x + 1
}
public func square(_ x: Int) -> Int {
  return x * x
}
