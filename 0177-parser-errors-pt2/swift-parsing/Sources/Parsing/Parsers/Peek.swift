/// A parser that runs the given parser, but does not consume any input.
///
/// It lets you "peek" to see what output the parser would parse.
///
/// For example, identifiers (variables, functions, etc.) in Swift allow the first character to be a
/// letter or underscore, but not a digit, but subsequent characters can be digits. _E.g._, `foo123`
/// is a valid identifier, but `123foo` is not. We can create an identifier parser by using `Peek`
/// to first check if the input starts with a letter or underscore, and if it does, return the
/// remainder of the input up to the first character that is not a letter, a digit, or an
/// underscore.
///
/// ```swift
/// let identifier = Parse {
///   Skip {
///     Peek { Prefix(1) { $0.isLetter || $0 == "_" } }
///   }
///   Prefix { $0.isNumber || $0.isLetter || $0 == "_" }
/// }
/// ```
public struct Peek<Upstream>: Parser where Upstream: Parser {
  public typealias Input = Upstream.Input
  public typealias Output = Upstream.Output

  public let upstream: Upstream

  /// Construct a parser that runs the given parser, but does not consume any input.
  ///
  /// - Parameter build: A parser this parser wants to inspect.
  @inlinable
  public init(@ParserBuilder _ build: () -> Upstream) {
    self.upstream = build()
  }

  @inlinable
  public func parse(_ input: inout Upstream.Input) -> Upstream.Output? {
    let original = input
    if let result = self.upstream.parse(&input) {
      input = original
      return result
    }
    return nil
  }
}
