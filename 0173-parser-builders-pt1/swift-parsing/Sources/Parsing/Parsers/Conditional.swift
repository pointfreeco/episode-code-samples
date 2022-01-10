/// A parser that can parse output from two types of parsers.
///
/// This parser is useful for situations where you want to run one of two different parsers based on
/// a condition, which typically would force you to perform ``Parser/eraseToAnyParser()`` and incur
/// a performance penalty.
///
/// For example, you can use this parser in a ``Parser/flatMap(_:)`` operation to use the parsed
/// output to determine what parser to run next:
///
/// ```swift
/// versionParser.flatMap { version in
///   version == "2.0"
///     ? Conditional.first(V2Parser())
///     : Conditional.second(LegacyParser())
/// }
/// ```
public enum Conditional<First, Second>: Parser
where
  First: Parser,
  Second: Parser,
  First.Input == Second.Input,
  First.Output == Second.Output
{
  case first(First)
  case second(Second)

  @inlinable
  public func parse(_ input: inout First.Input) -> First.Output? {
    switch self {
    case let .first(first):
      return first.parse(&input)
    case let .second(second):
      return second.parse(&input)
    }
  }
}

extension Parsers {
  public typealias Conditional = Parsing.Conditional  // NB: Convenience type alias for discovery
}
