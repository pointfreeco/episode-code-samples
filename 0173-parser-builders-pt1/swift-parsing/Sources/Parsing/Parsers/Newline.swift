/// A parser that consumes a single newline from the beginning of the input.
///
/// It will consume both line feeds (`"\n"`) and carriage returns with line feeds (`"\r\n"`).
public struct Newline<Input>: Parser
where
  Input: Collection,
  Input.SubSequence == Input,
  Input.Element == UTF8.CodeUnit
{
  @inlinable
  public init() {}

  @inlinable
  public func parse(_ input: inout Input) -> Void? {
    if input.first == .init(ascii: "\n") {
      input.removeFirst()
      return ()
    } else if input.first == .init(ascii: "\r"), input.dropFirst().first == .init(ascii: "\n") {
      input.removeFirst(2)
      return ()
    }
    return nil
  }
}

extension Newline where Input == Substring.UTF8View {
  @_disfavoredOverload
  @inlinable
  public init() {}
}

extension Parsers {
  public typealias Newline = Parsing.Newline  // NB: Convenience type alias for discovery
}
