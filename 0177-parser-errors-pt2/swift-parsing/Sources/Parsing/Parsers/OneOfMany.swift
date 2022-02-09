extension Parsers {
  /// A parser that attempts to run a number of parsers till one succeeds.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually loop
  /// over each parser in a builder block:
  ///
  /// ```swift
  /// enum Role: String, CaseIterable {
  ///   case admin
  ///   case guest
  ///   case member
  /// }
  ///
  /// Parse {
  ///   for role in Role.allCases {
  ///     status.rawValue.map { role }
  ///   }
  /// }
  /// ```
  public struct OneOfMany<Parsers>: Parser where Parsers: Parser {
    public typealias Input = Parsers.Input
    public typealias Output = Parsers.Output

    public let parsers: [Parsers]

    @inlinable
    public init(_ parsers: [Parsers]) {
      self.parsers = parsers
    }

    @inlinable
    @inline(__always)
    public func parse(_ input: inout Parsers.Input) -> Parsers.Output? {
      for parser in self.parsers {
        if let output = parser.parse(&input) {
          return output
        }
      }
      return nil
    }
  }
}
