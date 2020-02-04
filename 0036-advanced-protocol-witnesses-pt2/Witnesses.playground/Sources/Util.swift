
infix operator >>>

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
  return { g(f($0)) }
}

open class UITableViewCell {}

infix operator |>
public func |> <A, B>(_ a: A, f: (A) -> B) -> B {
  return f(a)
}

infix operator <|
public func <| <A, B>(f: (A) -> B, _ a: A) -> B {
  return f(a)
}
