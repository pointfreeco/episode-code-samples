/// A parser that consumes a subsequence from the beginning of its input up to a given sequence of
/// elements.
///
/// This parser is named after `Sequence.prefix(upTo:)`, and uses similar logic under the hood to
/// consume and return input up to a particular subsequence.
///
/// ```swift
/// let lineParser = PrefixUpTo<Substring>("\n")
///
/// var input = "Hello\nworld\n"[...]
/// line.parse(&input) // "Hello"
/// input // "\nworld\n"
/// ```
public struct PrefixUpTo<Input>: Parser
where
  Input: Collection,
  Input.SubSequence == Input
{
  public typealias Input = Input
  public typealias Output = Input

  public let possibleMatch: Input
  public let areEquivalent: (Input.Element, Input.Element) -> Bool

  @inlinable
  public init(
    _ possibleMatch: Input,
    by areEquivalent: @escaping (Input.Element, Input.Element) -> Bool
  ) {
    self.possibleMatch = possibleMatch
    self.areEquivalent = areEquivalent
  }

  @inlinable
  @inline(__always)
  public func parse(_ input: inout Input) -> Input? {
    guard let first = self.possibleMatch.first else { return self.possibleMatch }
    let count = self.possibleMatch.count
    let original = input
    while let index = input.firstIndex(where: { self.areEquivalent(first, $0) }) {
      input = input[index...]
      if input.count >= count,
        zip(input[index...], self.possibleMatch).allSatisfy(self.areEquivalent)
      {
        return original[..<index]
      }
      input.removeFirst()
    }
    input = original
    return nil
  }
}

extension PrefixUpTo where Input.Element: Equatable {
  @inlinable
  public init(_ possibleMatch: Input) {
    self.init(possibleMatch, by: ==)
  }
}

extension PrefixUpTo where Input == Substring {
  @_disfavoredOverload
  @inlinable
  public init(_ possiblePrefix: String) {
    self.init(possiblePrefix[...])
  }
}

extension PrefixUpTo where Input == Substring.UTF8View {
  @_disfavoredOverload
  @inlinable
  public init(_ possibleMatch: String.UTF8View) {
    self.init(String(possibleMatch)[...].utf8)
  }
}

extension Parsers {
  public typealias PrefixUpTo = Parsing.PrefixUpTo  // NB: Convenience type alias for discovery
}
