precedencegroup EffectfulComposition {
  associativity: left
  higherThan: AssignmentPrecedence
}

infix operator >=>: EffectfulComposition

precedencegroup ForwardComposition {
  associativity: left
  higherThan: EffectfulComposition
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
  return { a in g(f(a)) }
}
