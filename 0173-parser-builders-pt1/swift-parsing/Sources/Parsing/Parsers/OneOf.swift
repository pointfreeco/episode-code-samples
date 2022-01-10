extension Parser {
  /// A parser that runs this parser and, if it fails, runs the given parser.
  @inlinable
  public func orElse<P>(_ parser: P) -> Parsers.OneOf<Self, P> {
    .init(self, parser)
  }
}

/// A parser that attempts to run a number of parsers till one succeeds.
///
/// This is a more performant version of ``Parser/orElse(_:)`` that can be used when `Upstream` is
/// the same type.
///
/// For example, `OneOfMany` can capture the work of a number of parsers that do similar work and
/// are thus all `Parsers.Map<StartsWith<Input>, Output>`:
///
/// ```swift
/// enum Currency { case eur, gbp, usd }
///
/// let currency = OneOfMany(
///   "€".map { Currency.eur },
///   "£".map { .gbp },
///   "$".map { .usd }
/// )
/// ```
public struct OneOfMany<Upstream>: Parser where Upstream: Parser {
  public let parsers: [Upstream]

  @inlinable
  public init(_ parsers: [Upstream]) {
    self.parsers = parsers
  }

  @inlinable
  public init(_ parsers: Upstream...) {
    self.init(parsers)
  }

  @inlinable
  @inline(__always)
  public func parse(_ input: inout Upstream.Input) -> Upstream.Output? {
    for parser in self.parsers {
      if let output = parser.parse(&input) {
        return output
      }
    }
    return nil
  }
}

extension Parsers {
  /// A parser that runs the first parser and, if it fails, runs the second parser.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/orElse(_:)`` operation, which constructs this type.
  public struct OneOf<A, B>: Parser
  where
    A: Parser,
    B: Parser,
    A.Input == B.Input,
    A.Output == B.Output
  {
    public let a: A
    public let b: B

    @inlinable
    public init(_ a: A, _ b: B) {
      self.a = a
      self.b = b
    }

    @inlinable
    @inline(__always)
    public func parse(_ input: inout A.Input) -> A.Output? {
      if let output = self.a.parse(&input) { return output }
      if let output = self.b.parse(&input) { return output }
      return nil
    }
  }

  public typealias OneOfMany = Parsing.OneOfMany  // NB: Convenience type alias for discovery
}
