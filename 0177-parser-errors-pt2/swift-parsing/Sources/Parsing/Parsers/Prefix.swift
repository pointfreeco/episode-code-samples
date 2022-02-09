/// A parser that consumes a subsequence from the beginning of its input.
///
/// This parser is named after `Sequence.prefix`, which it uses under the hood to consume a number
/// of elements and return them as output. It can be configured with minimum and maximum lengths,
/// as well as a predicate.
///
/// For example, to parse as many numbers off the beginning of a substring:
///
/// ```swift
/// var input = "123 hello world"[...]
/// Prefix { $0.isNumber }.parse(&input) // "123"
/// input // " Hello world"
/// ```
///
/// If you wanted this parser to fail if _no_ numbers are consumed, you could introduce a minimum
/// length.
///
/// ```swift
/// var input = "No numbers here"[...]
/// Prefix(1...) { $0.isNumber }).parse(&input) // nil
/// input // "No numbers here"
/// ```
///
/// If a predicate is not provided, the parser will simply consume the prefix within the minimum and
/// maximum lengths provided:
///
/// ```swift
/// var input = "Lorem ipsum dolor"[...]
/// Prefix(2).parse(&input) // "Lo"
/// input // "rem ipsum dolor"
/// ```
public struct Prefix<Input>: Parser
where
  Input: Collection,
  Input.SubSequence == Input
{
  public typealias Input = Input
  public typealias Output = Input

  public let maxLength: Int?
  public let minLength: Int
  public let predicate: ((Input.Element) -> Bool)?

  /// Initializes a parser that consumes a subsequence from the beginning of its input.
  ///
  /// - Parameters:
  ///   - minLength: The minimum number of elements to consume for parsing to be considered
  ///     successful.
  ///   - maxLength: The maximum number of elements to consume before the parser will return its
  ///     output.
  ///   - predicate: A closure that takes an element of the input sequence as its argument and
  ///     returns `true` if the element should be included or `false` if it should be excluded. Once
  ///     the predicate returns `false` it will not be called again.
  @inlinable
  public init(
    minLength: Int = 0,
    maxLength: Int? = nil,
    while predicate: @escaping (Input.Element) -> Bool
  ) {
    self.minLength = minLength
    self.maxLength = maxLength
    self.predicate = predicate
  }

  /// Initializes a parser that consumes a subsequence from the beginning of its input.
  ///
  /// ```swift
  /// Prefix(2...4, while: { $0.isNumber }).parse("123456") // "1234"
  /// Prefix(2...4, while: { $0.isNumber }).parse("123")    // "123"
  /// Prefix(2...4, while: { $0.isNumber }).parse("1")      // nil
  /// ```
  ///
  /// - Parameters:
  ///   - length: A closed range that provides a minimum number and maximum of elements to consume
  ///     for parsing to be considered successful.
  ///   - predicate: An optional closure that takes an element of the input sequence as its argument
  ///     and returns `true` if the element should be included or `false` if it should be excluded.
  ///     Once the predicate returns `false` it will not be called again.
  @inlinable
  public init(
    _ length: ClosedRange<Int>,
    while predicate: ((Input.Element) -> Bool)? = nil
  ) {
    self.minLength = length.lowerBound
    self.maxLength = length.upperBound
    self.predicate = predicate
  }

  /// Initializes a parser that consumes a subsequence from the beginning of its input.
  ///
  ///     Prefix(4, while: { $0.isNumber }).parse("123456") // "1234"
  ///     Prefix(4, while: { $0.isNumber }).parse("123")    // nil
  ///
  /// - Parameters:
  ///   - length: An exact number of elements to consume for parsing to be considered successful.
  ///   - predicate: An optional closure that takes an element of the input sequence as its argument
  ///     and returns `true` if the element should be included or `false` if it should be excluded.
  ///     Once the predicate returns `false` it will not be called again.
  @inlinable
  public init(
    _ length: Int,
    while predicate: ((Input.Element) -> Bool)? = nil
  ) {
    self.minLength = length
    self.maxLength = length
    self.predicate = predicate
  }

  /// Initializes a parser that consumes a subsequence from the beginning of its input.
  ///
  ///     Prefix(4..., while: { $0.isNumber }).parse("123456") // "123456"
  ///     Prefix(4..., while: { $0.isNumber }).parse("123")    // nil
  ///
  /// - Parameters:
  ///   - length: A partial range that provides a minimum number of elements to consume for
  ///     parsing to be considered successful.
  ///   - predicate: An optional closure that takes an element of the input sequence as its argument
  ///     and returns `true` if the element should be included or `false` if it should be excluded.
  ///     Once the predicate returns `false` it will not be called again.
  @inlinable
  public init(
    _ length: PartialRangeFrom<Int>,
    while predicate: ((Input.Element) -> Bool)? = nil
  ) {
    self.minLength = length.lowerBound
    self.maxLength = nil
    self.predicate = predicate
  }

  /// Initializes a parser that consumes a subsequence from the beginning of its input.
  ///
  /// ```swift
  /// Prefix(...4, while: { $0.isNumber }).parse("123456") // "1234"
  /// Prefix(...4, while: { $0.isNumber }).parse("123")    // "123"
  /// ```
  ///
  /// - Parameters:
  ///   - length: A partial, inclusive range that provides a maximum number of elements to consume.
  ///   - predicate: An optional closure that takes an element of the input sequence as its argument
  ///     and returns `true` if the element should be included or `false` if it should be excluded.
  ///     Once the predicate returns `false` it will not be called again.
  @inlinable
  public init(
    _ length: PartialRangeThrough<Int>,
    while predicate: ((Input.Element) -> Bool)? = nil
  ) {
    self.minLength = 0
    self.maxLength = length.upperBound
    self.predicate = predicate
  }

  @inlinable
  @inline(__always)
  public func parse(_ input: inout Input) -> Input? {
    var prefix = maxLength.map(input.prefix) ?? input
    prefix = predicate.map { prefix.prefix(while: $0) } ?? prefix
    let count = prefix.count
    guard count >= self.minLength else { return nil }
    input.removeFirst(count)
    return prefix
  }
}

extension Prefix where Input == Substring {
  @_disfavoredOverload
  @inlinable
  public init(
    minLength: Int = 0,
    maxLength: Int? = nil,
    while predicate: @escaping (Input.Element) -> Bool
  ) {
    self.init(minLength: minLength, maxLength: maxLength, while: predicate)
  }

  @_disfavoredOverload
  @inlinable
  public init(
    _ length: ClosedRange<Int>,
    while predicate: ((Input.Element) -> Bool)? = nil
  ) {
    self.init(length, while: predicate)
  }

  @_disfavoredOverload
  @inlinable
  public init(
    _ length: Int,
    while predicate: ((Input.Element) -> Bool)? = nil
  ) {
    self.init(length, while: predicate)
  }

  @_disfavoredOverload
  @inlinable
  public init(
    _ length: PartialRangeFrom<Int>,
    while predicate: ((Input.Element) -> Bool)? = nil
  ) {
    self.init(length, while: predicate)
  }

  @_disfavoredOverload
  @inlinable
  public init(
    _ length: PartialRangeThrough<Int>,
    while predicate: ((Input.Element) -> Bool)? = nil
  ) {
    self.init(length, while: predicate)
  }
}

extension Prefix where Input == Substring.UTF8View {
  @_disfavoredOverload
  @inlinable
  public init(
    minLength: Int = 0,
    maxLength: Int? = nil,
    while predicate: @escaping (Input.Element) -> Bool
  ) {
    self.init(minLength: minLength, maxLength: maxLength, while: predicate)
  }

  @_disfavoredOverload
  @inlinable
  public init(
    _ length: ClosedRange<Int>,
    while predicate: ((Input.Element) -> Bool)? = nil
  ) {
    self.init(length, while: predicate)
  }

  @_disfavoredOverload
  @inlinable
  public init(
    _ length: Int,
    while predicate: ((Input.Element) -> Bool)? = nil
  ) {
    self.init(length, while: predicate)
  }

  @_disfavoredOverload
  @inlinable
  public init(
    _ length: PartialRangeFrom<Int>,
    while predicate: ((Input.Element) -> Bool)? = nil
  ) {
    self.init(length, while: predicate)
  }

  @_disfavoredOverload
  @inlinable
  public init(
    _ length: PartialRangeThrough<Int>,
    while predicate: ((Input.Element) -> Bool)? = nil
  ) {
    self.init(length, while: predicate)
  }
}

extension Parsers {
  public typealias Prefix = Parsing.Prefix  // NB: Convenience type alias for discovery
}
