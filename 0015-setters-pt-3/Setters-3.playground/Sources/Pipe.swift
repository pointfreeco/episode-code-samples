
public func |> <A>(_ a: A, _ f: (inout A) -> Void) -> A {
  var a = a
  f(&a)
  return a
}
