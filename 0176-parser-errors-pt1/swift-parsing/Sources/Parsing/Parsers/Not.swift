/// A parser that succeeds if the given parser fails, and does not consume any input.
///
/// For example:
///
/// ```swift
/// let uncommentedLine = Parse {
///   Not { "//" }
///   PrefixUpTo("\n")
/// }
/// ```
///
/// This will check the input doesn't start with `"//"`, and if it doesn't, it will return the whole
/// input up to the first newline.
public struct Not<Upstream>: Parser where Upstream: Parser {
  public typealias Input = Upstream.Input
  public typealias Output = Void

  public let upstream: Upstream

  /// Creates a parser that succeeds if the given parser fails, and does not consume any input.
  ///
  /// - Parameter build: A parser that causes this parser to fail if it succeeds, or succeed if it
  ///   fails.
  @inlinable
  public init(@ParserBuilder _ build: () -> Upstream) {
    self.upstream = build()
  }

  @inlinable
  public func parse(_ input: inout Upstream.Input) -> Void? {
    let original = input
    if self.upstream.parse(&input) != nil {
      input = original
      return nil
    }
    return ()
  }
}
