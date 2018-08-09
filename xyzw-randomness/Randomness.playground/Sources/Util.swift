
precedencegroup ForwardCompose {
  associativity: left
}
infix operator >>>: ForwardCompose
public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
  return { g(f($0)) }
}
