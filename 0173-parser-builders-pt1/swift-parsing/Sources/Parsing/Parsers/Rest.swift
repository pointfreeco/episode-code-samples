/// A parser that consumes everything to the end of the collection and returns it as its output.
public struct Rest<Input>: Parser
where
  Input: Collection,
  Input.SubSequence == Input
{
  @inlinable
  public init() {}

  @inlinable
  public func parse(_ input: inout Input) -> Input? {
    let output = input
    input.removeFirst(input.count)
    return output
  }
}

extension Rest where Input == Substring {
  @_disfavoredOverload
  @inlinable
  public init() {}
}

extension Rest where Input == Substring.UTF8View {
  @_disfavoredOverload
  @inlinable
  public init() {}
}

extension Parsers {
  public typealias Rest = Parsing.Rest  // NB: Convenience type alias for discovery
}
