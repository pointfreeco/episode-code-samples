
func incr(_ x: Int) -> Int {
  return x + 1
}

incr(2)

func square(_ x: Int) -> Int {
  return x * x
}

square(incr(2))

extension Int {
  func incr() -> Int {
    return self + 1
  }

  func square() -> Int {
    return self * self
  }
}

2.incr()
2.incr().square()

precedencegroup ForwardApplication {
  associativity: left
}

infix operator |>: ForwardApplication

func |> <A, B>(x: A, f: (A) -> B) -> B {
  return f(x)
}

2 |> incr |> square

extension Int {
  func incrAndSquare() -> Int {
    return self.incr().square()
  }
}

precedencegroup ForwardComposition {
  higherThan: ForwardApplication
  associativity: right
}
infix operator >>>: ForwardComposition

func >>> <A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> ((A) -> C) {
  return { a in g(f(a)) }
}

2 |> incr >>> square

[1, 2, 3]
  .map(square)
  .map(incr)

[1, 2, 3]
  .map(square >>> incr)
