/// A custom parameter attribute that constructs a parser that attempts to run a number of parsers,
/// one after the other, and accumulates their outputs.
///
/// See ``Parse`` for an entry point into this builder.
@resultBuilder
public enum ParserBuilder {
  /// Provides support for specifying a parser in ``ParserBuilder`` blocks.
  @inlinable
  public static func buildBlock<P: Parser>(_ parser: P) -> P {
    parser
  }

  /// Provides support for `if`-`else` statements in ``ParserBuilder`` blocks, producing a
  /// conditional parser for the `if` branch.
  ///
  /// ```swift
  /// Parse {
  ///   "Hello"
  ///   if shouldParseComma {
  ///     ", "
  ///   } else {
  ///     " "
  ///   }
  ///   Rest()
  /// }
  /// ```
  @inlinable
  public static func buildEither<TrueParser, FalseParser>(
    first parser: TrueParser
  ) -> Parsers.Conditional<TrueParser, FalseParser> {
    .first(parser)
  }

  /// Provides support for `if`-`else` statements in ``ParserBuilder`` blocks, producing a
  /// conditional parser for the `else` branch.
  ///
  /// ```swift
  /// Parse {
  ///   "Hello"
  ///   if shouldParseComma {
  ///     ", "
  ///   } else {
  ///     " "
  ///   }
  ///   Rest()
  /// }
  /// ```
  @inlinable
  public static func buildEither<TrueParser, FalseParser>(
    second parser: FalseParser
  ) -> Parsers.Conditional<TrueParser, FalseParser> {
    .second(parser)
  }

  /// Provides support for `if` statements in ``ParserBuilder`` blocks, producing an optional
  /// parser.
  @inlinable
  public static func buildIf<P: Parser>(_ parser: P?) -> P? {
    parser
  }

  /// Provides support for `if` statements in ``ParserBuilder`` blocks, producing a void parser for
  /// a given void parser.
  ///
  /// ```swift
  /// Parse {
  ///   "Hello"
  ///   if shouldParseComma {
  ///     ","
  ///   }
  ///   " "
  ///   Rest()
  /// }
  /// ```
  @inlinable
  public static func buildIf<P>(_ parser: P?) -> Parsers.OptionalVoid<P> {
    .init(wrapped: parser)
  }

  /// Provides support for `if #available` statements in ``ParserBuilder`` blocks, producing an
  /// optional parser.
  @inlinable
  public static func buildLimitedAvailability<P: Parser>(_ parser: P?) -> P? {
    parser
  }

  /// Provides support for `if #available` statements in ``ParserBuilder`` blocks, producing a void
  /// parser for a given void parser.
  @inlinable
  public static func buildLimitedAvailability<P>(_ parser: P?) -> Parsers.OptionalVoid<P> {
    .init(wrapped: parser)
  }
}
