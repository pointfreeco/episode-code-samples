extension Parser {
  /// Returns a parser that transforms the output of this parser into a new parser.
  ///
  /// This method is similar to `Sequence.flatMap`, `Optional.flatMap`, and `Result.flatMap` in the
  /// Swift standard library, as well as `Publisher.flatMap` in the Combine framework.
  ///
  /// - Parameter transform: A closure that transforms values of this parser's output and returns a
  ///   new parser.
  /// - Returns: A parser that transforms output from an upstream parser into a new parser.
  @inlinable
  public func flatMap<NewParser>(
    _ transform: @escaping (Output) -> NewParser
  ) -> Parsers.FlatMap<NewParser, Self> {
    .init(upstream: self, transform: transform)
  }
}

extension Parsers {
  /// A parser that transforms the output of another parser into a new parser.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/flatMap(_:)`` operation, which constructs this type.
  public struct FlatMap<NewParser, Upstream>: Parser
  where
    NewParser: Parser,
    Upstream: Parser,
    NewParser.Input == Upstream.Input
  {
    public let upstream: Upstream
    public let transform: (Upstream.Output) -> NewParser

    @inlinable
    public init(upstream: Upstream, transform: @escaping (Upstream.Output) -> NewParser) {
      self.upstream = upstream
      self.transform = transform
    }

    @inlinable
    public func parse(_ input: inout Upstream.Input) -> NewParser.Output? {
      let original = input
      guard let newParser = self.upstream.parse(&input).map(self.transform)
      else { return nil }
      guard let output = newParser.parse(&input)
      else {
        input = original
        return nil
      }
      return output
    }
  }
}
