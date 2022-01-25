extension Parser where Input: RangeReplaceableCollection {
  /// Transforms the receiver parser into one that can parse streams of input.
  ///
  /// For example, the following parser can parse an integer followed by a newline from a collection
  /// of UTF8 bytes:
  ///
  /// ```swift
  /// Parsers.Integer<ArraySlice<UInt8>, Int>()
  ///   .skip("\n".utf8)
  /// ```
  ///
  /// This parser can be transformed into one that processes an incoming stream of UTF8 bytes:
  ///
  /// ```swift
  /// let newlineSeparatedIntegers = Parsers.Integer<ArraySlice<UInt8>, Int>()
  ///   .skip("\n".utf8)
  ///   .stream
  /// ```
  ///
  /// And then it can be used on a stream, such as values coming from standard in:
  ///
  /// ```swift
  /// var stdin = AnyIterator {
  ///   readLine().map { ArraySlice($0.utf8) }
  /// }
  ///
  /// newlineSeparatedIntegers
  ///   .parse(&stdin)
  /// ```
  @inlinable
  public var stream: Parsers.Stream<Self> {
    .init(upstream: self)
  }
}

extension Parsers {
  /// A parser that can parse streams of input.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/stream`` operation, which constructs this type.
  public struct Stream<Upstream>: Parser
  where
    Upstream: Parser,
    Upstream.Input: RangeReplaceableCollection
  {
    public let upstream: Upstream

    @inlinable
    public init(upstream: Upstream) {
      self.upstream = upstream
    }

    @inlinable
    public func parse(_ input: inout AnyIterator<Upstream.Input>) -> [Upstream.Output]? {
      var buffer = Upstream.Input()
      var outputs: Output = []
      while let chunk = input.next() {
        buffer.append(contentsOf: chunk)
        while let output = self.upstream.parse(&buffer) {
          outputs.append(output)
        }
      }
      return outputs
    }
  }
}
