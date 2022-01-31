/// A parser that attempts to run a number of parsers to accumulate their outputs.
public struct Parse<Parsers>: Parser where Parsers: Parser {
  public typealias Input = Parsers.Input
  public typealias Output = Parsers.Output

  public let parsers: Parsers

  @inlinable
  public init(@ParserBuilder _ build: () -> Parsers) {
    self.parsers = build()
  }

  @inlinable
  public init<Upstream, NewOutput>(
    _ transform: @escaping (Upstream.Output) -> NewOutput,
    @ParserBuilder with build: () -> Upstream
  ) where Parsers == Parsing.Parsers.Map<Upstream, NewOutput> {
    self.parsers = build().map(transform)
  }

  @inlinable
  public init<Upstream, NewOutput>(
    _ output: NewOutput,
    @ParserBuilder with build: () -> Upstream
  ) where Upstream.Output == Void, Parsers == Parsing.Parsers.Map<Upstream, NewOutput> {
    self.parsers = build().map { output }
  }

  @inlinable
  public func parse(_ input: inout Parsers.Input) throws -> Parsers.Output {
    try self.parsers.parse(&input)
  }
}
