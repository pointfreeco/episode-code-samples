extension Optional: Parser where Wrapped: Parser {
  public typealias Input = Wrapped.Input
  public typealias Output = Wrapped.Output?

  public func parse(_ input: inout Wrapped.Input) -> Wrapped.Output?? {
    switch self {
    case let .some(parser):
      guard let output = parser.parse(&input)
      else { return .none }
      return output
    case .none:
      return .some(nil)
    }
  }
}

extension Parsers {
  /// A parser that attempts to run a given void parser, succeeding with void.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// `if` statements in a builder block:
  ///
  /// ```swift
  /// Parse {
  ///   "Hello"
  ///   if useComma {
  ///     ","
  ///   }
  ///   " "
  ///   Rest()
  /// }
  /// ```
  public struct OptionalVoid<Wrapped>: Parser where Wrapped: Parser, Wrapped.Output == Void {
    public typealias Input = Wrapped.Input
    public typealias Output = Void

    let wrapped: Wrapped?

    public init(wrapped: Wrapped?) {
      self.wrapped = wrapped
    }

    public func parse(_ input: inout Wrapped.Input) -> Void? {
      switch self.wrapped {
      case let .some(parser):
        return parser.parse(&input)
      case .none:
        return ()
      }
    }
  }
}
