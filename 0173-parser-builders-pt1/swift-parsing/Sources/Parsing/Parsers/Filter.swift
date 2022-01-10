extension Parser {
  /// Returns a parser that filters output from this parser when its output does not satisfy the
  /// given predicate.
  ///
  /// This method is similar to `Sequence.filter` in the Swift standard library, as well as
  /// `Publisher.filter` in the Combine framework.
  ///
  /// - Parameter predicate: A closure that takes an output from this parser and returns a Boolean
  ///   value indicating whether the output should be returned.
  /// - Returns: A parser that filters its output.
  @_disfavoredOverload
  @inlinable
  public func filter(_ predicate: @escaping (Output) -> Bool) -> Parsers.Filter<Self> {
    .init(upstream: self, predicate: predicate)
  }
}

extension Parsers {
  /// A parser that filters the output of an upstream parser when it does not satisfy a predicate.
  ///
  /// Returned from the ``Parser/filter(_:)`` method.
  public struct Filter<Upstream>: Parser where Upstream: Parser {
    public let upstream: Upstream
    public let predicate: (Upstream.Output) -> Bool

    @inlinable
    public init(upstream: Upstream, predicate: @escaping (Upstream.Output) -> Bool) {
      self.upstream = upstream
      self.predicate = predicate
    }

    @inlinable
    public func parse(_ input: inout Upstream.Input) -> Upstream.Output? {
      let original = input
      guard
        let output = self.upstream.parse(&input),
        self.predicate(output)
      else {
        input = original
        return nil
      }
      return output
    }
  }
}
