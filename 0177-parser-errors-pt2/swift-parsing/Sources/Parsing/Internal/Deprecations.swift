// NB: Deprecated after 0.4.1:

extension Parser {
  @_disfavoredOverload
  @available(*, deprecated, message: "Use the 'inout' version of 'parse', instead.")
  @inlinable
  public func parse(_ input: Input) -> (output: Output?, rest: Input) {
    var input = input
    let output: Output? = self.parse(&input)
    return (output, input)
  }
}
//
//extension Many {
//  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
//  @available(macOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @available(iOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @available(watchOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @available(tvOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @inlinable
//  public init(
//    _ element: Element,
//    into initialResult: Result,
//    atLeast minimum: Int = 0,
//    atMost maximum: Int = .max,
//    separator: Separator,
//    _ updateAccumulatingResult: @escaping (inout Result, Element.Output) -> Void
//  ) {
//    self.element = element
//    self.initialResult = initialResult
//    self.maximum = maximum
//    self.minimum = minimum
//    self.separator = separator
//    self.updateAccumulatingResult = updateAccumulatingResult
//  }
//}
//
//extension Many where Separator == Always<Input, Void> {
//  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
//  @available(macOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @available(iOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @available(watchOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @available(tvOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @inlinable
//  public init(
//    _ element: Element,
//    into initialResult: Result,
//    atLeast minimum: Int = 0,
//    atMost maximum: Int = .max,
//    _ updateAccumulatingResult: @escaping (inout Result, Element.Output) -> Void
//  ) {
//    self.element = element
//    self.initialResult = initialResult
//    self.maximum = maximum
//    self.minimum = minimum
//    self.separator = .init(())
//    self.updateAccumulatingResult = updateAccumulatingResult
//  }
//}
//
//extension Many where Result == [Element.Output] {
//  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
//  @available(macOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @available(iOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @available(watchOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @available(tvOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @inlinable
//  public init(
//    _ element: Element,
//    atLeast minimum: Int = 0,
//    atMost maximum: Int = .max,
//    separator: Separator
//  ) {
//    self.init(element, into: [], atLeast: minimum, atMost: maximum, separator: separator) {
//      $0.append($1)
//    }
//  }
//}
//
//extension Many where Result == [Element.Output], Separator == Always<Input, Void> {
//  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
//  @available(macOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @available(iOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @available(watchOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @available(tvOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
//  @inlinable
//  public init(
//    _ element: Element,
//    atLeast minimum: Int = 0,
//    atMost maximum: Int = .max
//  ) {
//    self.init(element, into: [], atLeast: minimum, atMost: maximum) {
//      $0.append($1)
//    }
//  }
//}

extension Parser {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'OneOf' instead.")
  @available(iOS, deprecated: 100000, message: "Use 'OneOf' instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'OneOf' instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'OneOf' instead.")
  @inlinable
  public func orElse<P>(_ parser: P) -> Parsers.OneOf<Self, P> {
    .init(self, parser)
  }
}

@available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
@available(macOS, deprecated: 100000, message: "Use 'OneOf' instead.")
@available(iOS, deprecated: 100000, message: "Use 'OneOf' instead.")
@available(watchOS, deprecated: 100000, message: "Use 'OneOf' instead.")
@available(tvOS, deprecated: 100000, message: "Use 'OneOf' instead.")
public typealias OneOfMany = Parsers.OneOfMany

extension Parsers.OneOfMany {
  @available(*, deprecated, renamed: "Parsers")
  public typealias Upstream = Parsers

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'OneOf' instead.")
  @available(iOS, deprecated: 100000, message: "Use 'OneOf' instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'OneOf' instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'OneOf' instead.")
  @inlinable
  public init(_ parsers: Parsers...) {
    self.init(parsers)
  }
}

extension Parsers {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'OneOf' instead.")
  @available(iOS, deprecated: 100000, message: "Use 'OneOf' instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'OneOf' instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'OneOf' instead.")
  public struct OneOf<A, B>: Parser
  where
    A: Parser,
    B: Parser,
    A.Input == B.Input,
    A.Output == B.Output
  {
    public typealias Input = A.Input
    public typealias Output = A.Output

    public let a: A
    public let b: B

    @inlinable
    public init(_ a: A, _ b: B) {
      self.a = a
      self.b = b
    }

    @inlinable
    @inline(__always)
    public func parse(_ input: inout A.Input) -> A.Output? {
      if let output = self.a.parse(&input) { return output }
      if let output = self.b.parse(&input) { return output }
      return nil
    }
  }
}

extension Optional {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Optionally' instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Optionally' instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Optionally' instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Optionally' instead.")
  @inlinable
  public static func parser<P>(of parser: P) -> Parsers.OptionalParser<P>
  where P: Parser, P.Output == Wrapped {
    .init(parser)
  }
}

extension Parsers {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Optionally' instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Optionally' instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Optionally' instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Optionally' instead.")
  public struct OptionalParser<Wrapped>: Parser where Wrapped: Parser {
    public typealias Input = Wrapped.Input
    public typealias Output = Wrapped.Output?

    public let wrapped: Wrapped

    @inlinable
    public init(_ wrapped: Wrapped) {
      self.wrapped = wrapped
    }

    @inlinable
    public func parse(_ input: inout Wrapped.Input) -> Wrapped.Output?? {
      .some(self.wrapped.parse(&input))
    }
  }
}

extension Parser {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use the '@ParserBuilder' method instead.")
  @available(iOS, deprecated: 100000, message: "Use the '@ParserBuilder' method instead.")
  @available(watchOS, deprecated: 100000, message: "Use the '@ParserBuilder' method instead.")
  @available(tvOS, deprecated: 100000, message: "Use the '@ParserBuilder' method instead.")
  @inlinable
  public func pipe<Downstream>(_ downstream: Downstream) -> Parsers.Pipe<Self, Downstream> {
    .init(upstream: self, downstream: downstream)
  }
}

extension Parser {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Skip' instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Skip' instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Skip' instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Skip' instead.")
  @inlinable
  public func ignoreOutput() -> Skip<Self> {
    .init(self)
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @inlinable
  public func take<P>(_ parser: P) -> Parsers.SkipFirst<Self, P>
  where P: Parser, P.Input == Input, Output == Void {
    .init(self, parser)
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @inlinable
  public func skip<P>(_ parser: P) -> Parsers.SkipSecond<Self, P>
  where P: Parser, P.Input == Input {
    .init(self, parser)
  }
}

extension Skip {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @available(iOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @available(watchOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @available(tvOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @inlinable
  public init(_ parsers: Parsers) {
    self.parsers = parsers
  }
}

extension Parsers {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  public struct SkipFirst<A, B>: Parser where A: Parser, B: Parser, A.Input == B.Input {
    public typealias Input = A.Input
    public typealias Output = B.Output

    public let a: A
    public let b: B

    @inlinable
    public init(_ a: A, _ b: B) {
      self.a = a
      self.b = b
    }

    @inlinable
    public func parse(_ input: inout A.Input) -> B.Output? {
      let original = input

      guard self.a.parse(&input) != nil
      else { return nil }

      guard let b = self.b.parse(&input)
      else {
        input = original
        return nil
      }

      return b
    }
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  public struct SkipSecond<A, B>: Parser where A: Parser, B: Parser, A.Input == B.Input {
    public typealias Input = A.Input
    public typealias Output = A.Output

    public let a: A
    public let b: B

    @inlinable
    public init(_ a: A, _ b: B) {
      self.a = a
      self.b = b
    }

    @inlinable
    @inline(__always)
    public func parse(_ input: inout A.Input) -> A.Output? {
      let original = input

      guard let a = self.a.parse(&input)
      else { return nil }

      guard self.b.parse(&input) != nil
      else {
        input = original
        return nil
      }

      return a
    }
  }
}

extension Parser where Input: RangeReplaceableCollection {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Stream' instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Stream' instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Stream' instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Stream' instead.")
  @inlinable
  public var stream: Parsers.Stream<Self> {
    .init(upstream: self)
  }
}

extension Stream {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @available(iOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @available(watchOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @available(tvOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @inlinable
  public init(upstream: Parsers) {
    self.parsers = upstream
  }
}

extension Parser where Input == Substring {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'FromSubstring' instead.")
  @available(iOS, deprecated: 100000, message: "Use 'FromSubstring' instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'FromSubstring' instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'FromSubstring' instead.")
  @inlinable
  public var utf8: FromSubstring<Substring.UTF8View, Self> {
    .init(upstream: self)
  }
}

extension Parser where Input == Substring.UnicodeScalarView {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'FromUnicodeScalarView' instead.")
  @available(iOS, deprecated: 100000, message: "Use 'FromUnicodeScalarView' instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'FromUnicodeScalarView' instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'FromUnicodeScalarView' instead.")
  @inlinable
  public var utf8: FromUnicodeScalarView<Substring.UTF8View, Self> {
    .init(upstream: self)
  }
}

extension Parsers {
  @available(*, deprecated, renamed: "FromUnicodeScalarView")
  public typealias UnicodeScalarViewToUTF8View = FromUnicodeScalarView

  @available(*, deprecated, renamed: "FromUTF8View")
  public typealias SubstringToUTF8View = FromUTF8View
}

extension FromSubstring where Input == Substring.UTF8View {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @available(iOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @available(watchOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @available(tvOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @inlinable
  public init(upstream: SubstringParser) {
    self.init { upstream }
  }
}

extension FromUnicodeScalarView where Input == Substring.UTF8View {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @available(iOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @available(watchOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @available(tvOS, deprecated: 100000, message: "Use the '@ParserBuilder' initializer instead.")
  @inlinable
  public init(upstream: UnicodeScalarsParser) {
    self.init { upstream }
  }
}

extension Parser where Input == Substring {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'FromUnicodeScalars' instead.")
  @available(iOS, deprecated: 100000, message: "Use 'FromUnicodeScalars' instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'FromUnicodeScalars' instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'FromUnicodeScalars' instead.")
  @inlinable
  public var unicodeScalars: Parsers.SubstringToUnicodeScalars<Self> {
    .init(upstream: self)
  }
}

extension Parsers {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'FromUnicodeScalars' instead.")
  @available(iOS, deprecated: 100000, message: "Use 'FromUnicodeScalars' instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'FromUnicodeScalars' instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'FromUnicodeScalars' instead.")
  public struct SubstringToUnicodeScalars<Upstream>: Parser
  where
    Upstream: Parser,
    Upstream.Input == Substring
  {
    public typealias Input = Substring.UnicodeScalarView
    public typealias Output = Upstream.Output

    public let upstream: Upstream

    @inlinable
    public init(upstream: Upstream) {
      self.upstream = upstream
    }

    @inlinable
    public func parse(_ input: inout Substring.UnicodeScalarView) -> Upstream.Output? {
      var substring = Substring(input)
      defer { input = substring.unicodeScalars }
      return self.upstream.parse(&substring)
    }
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'FromUTF8View' instead.")
  @available(iOS, deprecated: 100000, message: "Use 'FromUTF8View' instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'FromUTF8View' instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'FromUTF8View' instead.")
  public struct UTF8ViewToSubstring<UTF8ViewParser>: Parser
  where
    UTF8ViewParser: Parser,
    UTF8ViewParser.Input == Substring.UTF8View
  {
    public typealias Input = Substring
    public typealias Output = UTF8ViewParser.Output

    public let utf8ViewParser: UTF8ViewParser

    @inlinable
    public init(_ utf8ViewParser: UTF8ViewParser) {
      self.utf8ViewParser = utf8ViewParser
    }

    @inlinable
    public func parse(_ input: inout Substring) -> UTF8ViewParser.Output? {
      self.utf8ViewParser.parse(&input.utf8)
    }
  }
}

extension Parser {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @inlinable
  public func take<P>(
    _ parser: P
  ) -> Parsers.Take2<Self, P>
  where P: Parser, P.Input == Input {
    .init(self, parser)
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @inlinable
  public func take<A, B, P>(
    _ parser: P
  ) -> Parsers.Take3<Self, A, B, P>
  where P: Parser, P.Input == Input, Output == (A, B) {
    .init(self, parser)
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @inlinable
  public func take<A, B, C, P>(
    _ parser: P
  ) -> Parsers.Take4<Self, A, B, C, P>
  where P: Parser, P.Input == Input, Output == (A, B, C) {
    .init(self, parser)
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @inlinable
  public func take<A, B, C, D, P>(
    _ parser: P
  ) -> Parsers.Take5<Self, A, B, C, D, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D) {
    .init(self, parser)
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @inlinable
  public func take<A, B, C, D, E, P>(
    _ parser: P
  ) -> Parsers.Take6<Self, A, B, C, D, E, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D, E) {
    .init(self, parser)
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @inlinable
  public func take<A, B, C, D, E, F, P>(
    _ parser: P
  ) -> Parsers.Take7<Self, A, B, C, D, E, F, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D, E, F) {
    .init(self, parser)
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @inlinable
  public func take<A, B, C, D, E, F, G, P>(
    _ parser: P
  ) -> Parsers.Take8<Self, A, B, C, D, E, F, G, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D, E, F, G) {
    .init(self, parser)
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @inlinable
  public func take<A, B, C, D, E, F, G, H, P>(
    _ parser: P
  ) -> Parsers.Take9<Self, A, B, C, D, E, F, G, H, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D, E, F, G, H) {
    .init(self, parser)
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @inlinable
  public func take<A, B, C, D, E, F, G, H, I, P>(
    _ parser: P
  ) -> Parsers.Take10<Self, A, B, C, D, E, F, G, H, I, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D, E, F, G, H, I) {
    .init(self, parser)
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @inlinable
  public func take<A, B, C, D, E, F, G, H, I, J, P>(
    _ parser: P
  ) -> Parsers.Take11<Self, A, B, C, D, E, F, G, H, I, J, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D, E, F, G, H, I, J) {
    .init(self, parser)
  }
}

extension Parsers {
  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  public struct Take2<A, B>: Parser
  where
    A: Parser,
    B: Parser,
    A.Input == B.Input
  {
    public typealias Input = A.Input
    public typealias Output = (A.Output, B.Output)

    public let a: A
    public let b: B

    @inlinable
    public init(_ a: A, _ b: B) {
      self.a = a
      self.b = b
    }

    @inlinable
    public func parse(_ input: inout A.Input) -> (A.Output, B.Output)? {
      let original = input
      guard let a = self.a.parse(&input)
      else { return nil }
      guard let b = self.b.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b)
    }
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  public struct Take3<AB, A, B, C>: Parser
  where
    AB: Parser,
    AB.Output == (A, B),
    C: Parser,
    AB.Input == C.Input
  {
    public typealias Input = AB.Input
    public typealias Output = (A, B, C.Output)

    public let ab: AB
    public let c: C

    @inlinable
    public init(
      _ ab: AB,
      _ c: C
    ) {
      self.ab = ab
      self.c = c
    }

    @inlinable
    public func parse(_ input: inout AB.Input) -> (A, B, C.Output)? {
      let original = input
      guard let (a, b) = self.ab.parse(&input)
      else { return nil }
      guard let c = self.c.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c)
    }
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  public struct Take4<ABC, A, B, C, D>: Parser
  where
    ABC: Parser,
    ABC.Output == (A, B, C),
    D: Parser,
    ABC.Input == D.Input
  {
    public typealias Input = ABC.Input
    public typealias Output = (A, B, C, D.Output)

    public let abc: ABC
    public let d: D

    @inlinable
    public init(
      _ abc: ABC,
      _ d: D
    ) {
      self.abc = abc
      self.d = d
    }

    @inlinable
    public func parse(_ input: inout ABC.Input) -> (A, B, C, D.Output)? {
      let original = input
      guard let (a, b, c) = self.abc.parse(&input)
      else { return nil }
      guard let d = self.d.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d)
    }
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  public struct Take5<ABCD, A, B, C, D, E>: Parser
  where
    ABCD: Parser,
    ABCD.Output == (A, B, C, D),
    E: Parser,
    ABCD.Input == E.Input
  {
    public typealias Input = ABCD.Input
    public typealias Output = (A, B, C, D, E.Output)

    public let abcd: ABCD
    public let e: E

    @inlinable
    public init(
      _ abcd: ABCD,
      _ e: E
    ) {
      self.abcd = abcd
      self.e = e
    }

    @inlinable
    public func parse(_ input: inout ABCD.Input) -> (A, B, C, D, E.Output)? {
      let original = input
      guard let (a, b, c, d) = self.abcd.parse(&input)
      else { return nil }
      guard let e = self.e.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e)
    }
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  public struct Take6<ABCDE, A, B, C, D, E, F>: Parser
  where
    ABCDE: Parser,
    ABCDE.Output == (A, B, C, D, E),
    F: Parser,
    ABCDE.Input == F.Input
  {
    public typealias Input = ABCDE.Input
    public typealias Output = (A, B, C, D, E, F.Output)

    public let abcde: ABCDE
    public let f: F

    @inlinable
    public init(
      _ abcde: ABCDE,
      _ f: F
    ) {
      self.abcde = abcde
      self.f = f
    }

    @inlinable
    public func parse(_ input: inout ABCDE.Input) -> (A, B, C, D, E, F.Output)? {
      let original = input
      guard let (a, b, c, d, e) = self.abcde.parse(&input)
      else { return nil }
      guard let f = self.f.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e, f)
    }
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  public struct Take7<ABCDEF, A, B, C, D, E, F, G>: Parser
  where
    ABCDEF: Parser,
    ABCDEF.Output == (A, B, C, D, E, F),
    G: Parser,
    ABCDEF.Input == G.Input
  {
    public typealias Input = ABCDEF.Input
    public typealias Output = (A, B, C, D, E, F, G.Output)

    public let abcdef: ABCDEF
    public let g: G

    @inlinable
    public init(
      _ abcdef: ABCDEF,
      _ g: G
    ) {
      self.abcdef = abcdef
      self.g = g
    }

    @inlinable
    public func parse(_ input: inout ABCDEF.Input) -> (A, B, C, D, E, F, G.Output)? {
      let original = input
      guard let (a, b, c, d, e, f) = self.abcdef.parse(&input)
      else { return nil }
      guard let g = self.g.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e, f, g)
    }
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  public struct Take8<ABCDEFG, A, B, C, D, E, F, G, H>: Parser
  where
    ABCDEFG: Parser,
    ABCDEFG.Output == (A, B, C, D, E, F, G),
    H: Parser,
    ABCDEFG.Input == H.Input
  {
    public typealias Input = ABCDEFG.Input
    public typealias Output = (A, B, C, D, E, F, G, H.Output)

    public let abcdefg: ABCDEFG
    public let h: H

    @inlinable
    public init(
      _ abcdefg: ABCDEFG,
      _ h: H
    ) {
      self.abcdefg = abcdefg
      self.h = h
    }

    @inlinable
    public func parse(_ input: inout ABCDEFG.Input) -> (A, B, C, D, E, F, G, H.Output)? {
      let original = input
      guard let (a, b, c, d, e, f, g) = self.abcdefg.parse(&input)
      else { return nil }
      guard let h = self.h.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e, f, g, h)
    }
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  public struct Take9<ABCDEFGH, A, B, C, D, E, F, G, H, I>: Parser
  where
    ABCDEFGH: Parser,
    ABCDEFGH.Output == (A, B, C, D, E, F, G, H),
    I: Parser,
    ABCDEFGH.Input == I.Input
  {
    public typealias Input = ABCDEFGH.Input
    public typealias Output = (A, B, C, D, E, F, G, H, I.Output)

    public let abcdefgh: ABCDEFGH
    public let i: I

    @inlinable
    public init(
      _ abcdefgh: ABCDEFGH,
      _ i: I
    ) {
      self.abcdefgh = abcdefgh
      self.i = i
    }

    @inlinable
    public func parse(_ input: inout ABCDEFGH.Input) -> (A, B, C, D, E, F, G, H, I.Output)? {
      let original = input
      guard let (a, b, c, d, e, f, g, h) = self.abcdefgh.parse(&input)
      else { return nil }
      guard let i = self.i.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e, f, g, h, i)
    }
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  public struct Take10<ABCDEFGHI, A, B, C, D, E, F, G, H, I, J>: Parser
  where
    ABCDEFGHI: Parser,
    ABCDEFGHI.Output == (A, B, C, D, E, F, G, H, I),
    J: Parser,
    ABCDEFGHI.Input == J.Input
  {
    public typealias Input = ABCDEFGHI.Input
    public typealias Output = (A, B, C, D, E, F, G, H, I, J.Output)

    public let abcdefghi: ABCDEFGHI
    public let j: J

    @inlinable
    public init(
      _ abcdefghi: ABCDEFGHI,
      _ j: J
    ) {
      self.abcdefghi = abcdefghi
      self.j = j
    }

    @inlinable
    public func parse(_ input: inout ABCDEFGHI.Input) -> (A, B, C, D, E, F, G, H, I, J.Output)? {
      let original = input
      guard let (a, b, c, d, e, f, g, h, i) = self.abcdefghi.parse(&input)
      else { return nil }
      guard let j = self.j.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e, f, g, h, i, j)
    }
  }

  @available(macOS 0, iOS 0, watchOS 0, tvOS 0, *)
  @available(macOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(iOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(watchOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  @available(tvOS, deprecated: 100000, message: "Use 'Parse' (and 'Skip') instead.")
  public struct Take11<ABCDEFGHIJ, A, B, C, D, E, F, G, H, I, J, K>: Parser
  where
    ABCDEFGHIJ: Parser,
    ABCDEFGHIJ.Output == (A, B, C, D, E, F, G, H, I, J),
    K: Parser,
    ABCDEFGHIJ.Input == K.Input
  {
    public typealias Input = ABCDEFGHIJ.Input
    public typealias Output = (A, B, C, D, E, F, G, H, I, J, K.Output)

    public let abcdefghij: ABCDEFGHIJ
    public let k: K

    @inlinable
    public init(
      _ abcdefghij: ABCDEFGHIJ,
      _ k: K
    ) {
      self.abcdefghij = abcdefghij
      self.k = k
    }

    @inlinable
    public func parse(_ input: inout ABCDEFGHIJ.Input) -> (A, B, C, D, E, F, G, H, I, J, K.Output)?
    {
      let original = input
      guard let (a, b, c, d, e, f, g, h, i, j) = self.abcdefghij.parse(&input)
      else { return nil }
      guard let k = self.k.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e, f, g, h, i, j, k)
    }
  }
}

// NB: Deprecated after 0.4.0:

extension Many {
  @available(*, deprecated, renamed: "Element")
  public typealias Upstream = Element

  @available(*, deprecated, renamed: "element")
  public var upstream: Upstream { self.element }
}

extension Parsers.OptionalParser {
  @available(*, deprecated, renamed: "Wrapped")
  public typealias Upstream = Wrapped

  @available(*, deprecated, renamed: "wrapped")
  public var upstream: Upstream { self.wrapped }
}

// NB: Deprecated after 0.3.1:

extension Parsers {
  @available(
    *, deprecated,
    message:
      "'Bool.parser(of: Substring.self)' now returns 'Parsers.UTF8ViewToSubstring<Parsers.BoolParser<Substring.UTF8View>>'"
  )
  public typealias SubstringBoolParser = UTF8ViewToSubstring<BoolParser<Substring.UTF8View>>

  @available(
    *, deprecated,
    message:
      "'Double.parser(of: Substring.self)' now returns 'Parsers.UTF8ViewToSubstring<Parsers.DoubleParser<Substring.UTF8View>>'"
  )
  public typealias SubstringDoubleParser = UTF8ViewToSubstring<DoubleParser<Substring.UTF8View>>

  #if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
    @available(
      *, deprecated,
      message:
        "'Float80.parser(of: Substring.self)' now returns 'Parsers.UTF8ViewToSubstring<Parsers.Float80Parser<Substring.UTF8View>>'"
    )
    public typealias SubstringFloat80Parser = UTF8ViewToSubstring<Float80Parser<Substring.UTF8View>>
  #endif

  @available(
    *, deprecated,
    message:
      "'Float.parser(of: Substring.self)' now returns 'Parsers.UTF8ViewToSubstring<Parsers.FloatParser<Substring.UTF8View>>'"
  )
  public typealias SubstringFloatParser = UTF8ViewToSubstring<FloatParser<Substring.UTF8View>>

  @available(
    *, deprecated,
    message:
      "'FixedWidthInteger.parser(of: Substring.self)' now returns 'Parsers.UTF8ViewToSubstring<Parsers.IntParser<Substring.UTF8View, FixedWidthInteger>>'"
  )
  public typealias SubstringIntParser<Output> = UTF8ViewToSubstring<
    IntParser<Substring.UTF8View, Output>
  > where Output: FixedWidthInteger

  @available(
    *, deprecated,
    message:
      "'UUID.parser(of: Substring.self)' now returns 'Parsers.UTF8ViewToSubstring<Parsers.UUIDParser<Substring.UTF8View>>'"
  )
  public typealias SubstringUUIDParser<Output> = UTF8ViewToSubstring<UUIDParser<Substring.UTF8View>>
}

// NB: Deprecated after 0.1.2:

@available(*, deprecated, message: "Use 'First().filter(predicate) instead")
public struct FirstWhere<Input>: Parser
where
  Input: Collection,
  Input.SubSequence == Input
{
  public typealias Input = Input
  public typealias Output = Input.Element

  public let predicate: (Input.Element) -> Bool

  @inlinable
  public init(_ predicate: @escaping (Input.Element) -> Bool) {
    self.predicate = predicate
  }

  @inlinable
  public func parse(_ input: inout Input) -> Input.Element? {
    guard let first = input.first, self.predicate(first) else { return nil }
    input.removeFirst()
    return first
  }
}

@available(*, deprecated, message: "Use 'First().filter(predicate) instead")
extension Parsers {
  public typealias FirstWhere = Parsing.FirstWhere  // NB: Convenience type alias for discovery
}
