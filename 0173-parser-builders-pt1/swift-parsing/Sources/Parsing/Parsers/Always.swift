/// A parser that always succeeds by returning the provided value, but does not consume any of its
/// input.
///
/// ```swift
/// var input = "Hello"[...]
/// let output = Always(1).parse(&hello)
/// precondition(output == 1)
/// precondition(input == "Hello")
/// ```
public struct Always<Input, Output>: Parser {
  public let output: Output

  @inlinable
  public init(_ output: Output) {
    self.output = output
  }

  @inlinable
  public func parse(_ input: inout Input) -> Output? {
    self.output
  }

  @inlinable
  public func map<NewOutput>(
    _ transform: @escaping (Output) -> NewOutput
  ) -> Always<Input, NewOutput> {
    .init(transform(self.output))
  }
}

extension Parsers {
  public typealias Always = Parsing.Always  // NB: Convenience type alias for discovery
}
