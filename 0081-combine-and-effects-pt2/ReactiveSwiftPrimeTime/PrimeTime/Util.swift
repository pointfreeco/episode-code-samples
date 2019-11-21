func compose<A, B, C>(
  _ f: @escaping (B) -> C,
  _ g: @escaping (A) -> B
  )
  -> (A) -> C {

    return { (a: A) -> C in
      f(g(a))
    }
}

func with<A, B>(_ a: A, _ f: (A) throws -> B) rethrows -> B {
  return try f(a)
}
