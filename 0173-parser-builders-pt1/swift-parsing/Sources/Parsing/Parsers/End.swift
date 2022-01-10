/// A parser that succeeds if the input is empty, and fails otherwise.
///
/// ```swift
/// End<Substring>().parse(""[...]) // (output: (), rest: "")
/// End<Substring>().parse("Hello"[...]) // (output: nil, rest: "Hello")
/// ```
public struct End<Input>: Parser where Input: Collection {
  @inlinable
  public init() {}

  @inlinable
  public func parse(_ input: inout Input) -> Void? {
    guard input.isEmpty else { return nil }
    return ()
  }
}

extension End where Input == Substring {
  @_disfavoredOverload
  @inlinable
  public init() {}
}

extension End where Input == Substring.UTF8View {
  @_disfavoredOverload
  @inlinable
  public init() {}
}

extension Parsers {
  public typealias End = Parsing.End  // NB: Convenience type alias for discovery
}
