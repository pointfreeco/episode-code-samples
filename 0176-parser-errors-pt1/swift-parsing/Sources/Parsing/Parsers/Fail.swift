/// A parser that always fails, no matter the input.
///
/// Useful for conditionally causing parsing to fail when used with `Parser.flatMap`.
///
/// ```swift
/// let evens = Int.parser().flatMap {
///   if $0.isMultiple(of: 2) {
///     Always($0)
///   } else {
///     Fail()
///   }
/// }
///
/// evens.parse("42")  // 42
/// evens.parse("123") // nil
/// ```
public struct Fail<Input, Output>: Parser {
  public typealias Input = Input
  public typealias Output = Output

  @inlinable
  public init() {}

  @inlinable
  public func parse(_ input: inout Input) -> Output? {
    nil
  }
}

extension Fail where Input == Substring {
  @_disfavoredOverload
  @inlinable
  public init() {}
}

extension Fail where Input == Substring.UTF8View {
  @_disfavoredOverload
  @inlinable
  public init() {}
}

extension Parsers {
  public typealias Fail = Parsing.Fail  // NB: Convenience type alias for discovery
}
