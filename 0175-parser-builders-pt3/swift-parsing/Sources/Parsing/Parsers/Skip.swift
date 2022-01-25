extension Parser {
  /// Returns a parser that discards the output of this parser by returning `Void` instead.
  ///
  /// - Returns: A parser that discards its output.
  @inlinable
  public func ignoreOutput() -> Skip<Self> {
    .init(self)
  }

  /// Returns a parser that runs this parser and the given parser, taking only the output of the
  /// given parser.
  ///
  /// - Parameter parser: A parser to run immediately after this parser.
  /// - Returns: A parser that runs two parsers, ignoring the first's output.
  @inlinable
  public func take<P>(_ parser: P) -> Parsers.SkipFirst<Self, P>
  where P: Parser, P.Input == Input, Output == Void {
    .init(self, parser)
  }

  /// Returns a parser that runs this parser and the given parser, taking only the output of this
  /// parser.
  ///
  /// - Parameter parser: A parser to run immediately after this parser.
  /// - Returns: A parser that runs two parsers, ignoring the second's output.
  @inlinable
  public func skip<P>(_ parser: P) -> Parsers.SkipSecond<Self, P>
  where P: Parser, P.Input == Input {
    .init(self, parser)
  }
}

/// A parser that discards the output of another parser.
public struct Skip<Upstream>: Parser where Upstream: Parser {
  /// The parser from which this parser receives output.
  public let upstream: Upstream

  @inlinable
  public init(_ upstream: Upstream) {
    self.upstream = upstream
  }

  @inlinable
  public func parse(_ input: inout Upstream.Input) -> Void? {
    guard self.upstream.parse(&input) != nil else { return nil }
    return ()
  }
}

extension Parsers {
  /// A parser that runs two parsers, one after the other, taking only the output of the second
  /// parser.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/take(_:)-1fw8y`` operation, which constructs this type.
  public struct SkipFirst<A, B>: Parser where A: Parser, B: Parser, A.Input == B.Input {
    public let a: A
    public let b: B

    @inlinable
    public init(_ a: A, _ b: B) {
      self.a = a
      self.b = b
    }

    @inlinable
    public func parse(_ input: inout A.Input) -> B.Output? {
      let original = input

      guard self.a.parse(&input) != nil
      else { return nil }

      guard let b = self.b.parse(&input)
      else {
        input = original
        return nil
      }

      return b
    }
  }

  /// A parser that runs two parsers, one after the other, taking only the output of the first
  /// parser.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/skip(_:)`` operation, which constructs this type.
  public struct SkipSecond<A, B>: Parser where A: Parser, B: Parser, A.Input == B.Input {
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
      let original = input

      guard let a = self.a.parse(&input)
      else { return nil }

      guard self.b.parse(&input) != nil
      else {
        input = original
        return nil
      }

      return a
    }
  }

  public typealias Skip = Parsing.Skip  // NB: Convenience type alias for discovery
}
