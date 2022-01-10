extension Optional {
  /// A parser that parses `nil` when this parser fails.
  ///
  /// Use this parser when you are parsing into an output data model that contains `nil`.
  ///
  /// If you are optionally parsing input that should coalesce into some default, you can skip the
  /// optionality and instead use ``Parser/orElse(_:)`` with an ``Always`` parser, given a default.
  @inlinable
  public static func parser<P>(of parser: P) -> Parsers.OptionalParser<P>
  where P: Parser, P.Output == Wrapped {
    .init(parser)
  }
}

extension Parsers {
  /// A parser that parses `nil` when its wrapped parser fails.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// `Optional.parser(of:)`, which constructs this type.
  public struct OptionalParser<Wrapped>: Parser where Wrapped: Parser {
    public let wrapped: Wrapped

    @inlinable
    public init(_ wrapped: Wrapped) {
      self.wrapped = wrapped
    }

    @inlinable
    public func parse(_ input: inout Wrapped.Input) -> Wrapped.Output?? {
      .some(self.wrapped.parse(&input))
    }
  }
}
