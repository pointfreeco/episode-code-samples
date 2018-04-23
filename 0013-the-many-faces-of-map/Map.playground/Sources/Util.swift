@_exported import Foundation

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

public func incr(_ x: Int) -> Int { return x + 1 }
public func square(_ x: Int) -> Int { return x * x }
