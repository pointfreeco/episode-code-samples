import Foundation

extension Double {
  /// A parser that consumes a double from the beginning of a collection of UTF-8 code units.
  ///
  /// ```swift
  /// var input = "123.45 Hello world"[...]
  /// try Double.parser().parse(&input)  // 123.45
  /// input                              // " Hello world"
  /// ```
  ///
  /// - Parameter inputType: The collection type of UTF-8 code units to parse.
  /// - Returns: A parser that consumes a double from the beginning of a collection of UTF-8 code
  ///   units.
  @inlinable
  public static func parser<Input>(
    of inputType: Input.Type = Input.self
  ) -> Parsers.DoubleParser<Input> {
    .init()
  }

  /// A parser that consumes a double from the beginning of a substring's UTF-8 view.
  ///
  /// This overload is provided to allow the `Input` generic to be inferred when it is
  /// `Substring.UTF8View`.
  ///
  /// - Parameter inputType: The `Substring.UTF8View` type. This parameter is included to mirror the
  ///   interface that parses any collection of UTF-8 code units.
  /// - Returns: A parser that consumes a double from the beginning of a substring's UTF-8 view.
  @_disfavoredOverload
  @inlinable
  public static func parser(
    of inputType: Substring.UTF8View.Type = Substring.UTF8View.self
  ) -> Parsers.DoubleParser<Substring.UTF8View> {
    .init()
  }

  /// A parser that consumes a double from the beginning of a substring.
  ///
  /// This overload is provided to allow the `Input` generic to be inferred when it is `Substring`.
  ///
  /// - Parameter inputType: The `Substring` type. This parameter is included to mirror the
  ///   interface that parses any collection of UTF-8 code units.
  /// - Returns: A parser that consumes a double from the beginning of a substring.
  @_disfavoredOverload
  @inlinable
  public static func parser(
    of inputType: Substring.Type = Substring.self
  ) -> FromUTF8View<Substring, Parsers.DoubleParser<Substring.UTF8View>> {
    .init { Parsers.DoubleParser<Substring.UTF8View>() }
  }
}

extension Float {
  /// A parser that consumes a float from the beginning of a collection of UTF-8 code units.
  ///
  /// ```swift
  /// var input = "123.45 Hello world"[...]
  /// try Float.parser().parse(&input)  // 123.45
  /// input                             // " Hello world"
  /// ```
  ///
  /// - Parameter inputType: The collection type of UTF-8 code units to parse.
  /// - Returns: A parser that consumes a float from the beginning of a collection of UTF-8 code
  ///   units.
  @inlinable
  public static func parser<Input>(
    of inputType: Input.Type = Input.self
  ) -> Parsers.FloatParser<Input> {
    .init()
  }

  /// A parser that consumes a float from the beginning of a substring's UTF-8 view.
  ///
  /// This overload is provided to allow the `Input` generic to be inferred when it is
  /// `Substring.UTF8View`.
  ///
  /// - Parameter inputType: The `Substring.UTF8View` type. This parameter is included to mirror the
  ///   interface that parses any collection of UTF-8 code units.
  /// - Returns: A parser that consumes a float from the beginning of a substring's UTF-8 view.
  @_disfavoredOverload
  @inlinable
  public static func parser(
    of inputType: Substring.UTF8View.Type = Substring.UTF8View.self
  ) -> Parsers.FloatParser<Substring.UTF8View> {
    .init()
  }

  /// A parser that consumes a float from the beginning of a substring.
  ///
  /// This overload is provided to allow the `Input` generic to be inferred when it is `Substring`.
  ///
  /// - Parameter inputType: The `Substring` type. This parameter is included to mirror the
  ///   interface that parses any collection of UTF-8 code units.
  /// - Returns: A parser that consumes a float from the beginning of a substring.
  @_disfavoredOverload
  @inlinable
  public static func parser(
    of inputType: Substring.Type = Substring.self
  ) -> FromUTF8View<Substring, Parsers.FloatParser<Substring.UTF8View>> {
    .init { Parsers.FloatParser<Substring.UTF8View>() }
  }
}

#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  extension Float80 {
    /// A parser that consumes an extended-precision, floating-point value from the beginning of a
    /// collection of UTF-8 code units.
    ///
    /// ```swift
    /// var input = "123.45 Hello world"[...]
    /// try Float80.parser().parse(&input)  // 123.45
    /// input                               // " Hello world"
    /// ```
    ///
    /// - Parameter inputType: The collection type of UTF-8 code units to parse.
    /// - Returns: A parser that consumes an extended-precision, floating-point value from the
    ///   beginning of a collection of UTF-8 code units.
    @inlinable
    public static func parser<Input>(
      of inputType: Input.Type = Input.self
    ) -> Parsers.Float80Parser<Input> {
      .init()
    }

    /// A parser that consumes an extended-precision, floating-point value from the beginning of a
    /// substring's UTF-8 view.
    ///
    /// This overload is provided to allow the `Input` generic to be inferred when it is
    /// `Substring.UTF8View`.
    ///
    /// - Parameter inputType: The `Substring.UTF8View` type. This parameter is included to mirror
    ///   the interface that parses any collection of UTF-8 code units.
    /// - Returns: A parser that consumes an extended-precision, floating-point value from the
    ///   beginning of a substring's UTF-8 view.
    @_disfavoredOverload
    @inlinable
    public static func parser(
      of inputType: Substring.UTF8View.Type = Substring.UTF8View.self
    ) -> Parsers.Float80Parser<Substring.UTF8View> {
      .init()
    }

    /// A parser that consumes an extended-precision, floating-point value from the beginning of a
    /// substring.
    ///
    /// This overload is provided to allow the `Input` generic to be inferred when it is
    /// `Substring`.
    ///
    /// - Parameter inputType: The `Substring` type. This parameter is included to mirror the
    ///   interface that parses any collection of UTF-8 code units.
    /// - Returns: A parser that consumes an extended-precision, floating-point value from the
    ///   beginning of a substring.
    @_disfavoredOverload
    @inlinable
    public static func parser(
      of inputType: Substring.Type = Substring.self
    ) -> FromUTF8View<Substring, Parsers.Float80Parser<Substring.UTF8View>> {
      .init { Parsers.Float80Parser<Substring.UTF8View>() }
    }
  }
#endif

extension Parsers {
  /// A parser that consumes a double from the beginning of a collection of UTF-8 code units.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// `Double.parser()`, which constructs this type.
  ///
  /// ```swift
  /// var input = "123.45 Hello world"[...]
  /// try Double.parser().parse(&input)  // 123.45
  /// input                              // " Hello world"
  /// ```
  public struct DoubleParser<Input>: Parser
  where
    Input: Collection,
    Input.SubSequence == Input,
    Input.Element == UTF8.CodeUnit
  {
    @inlinable
    public init() {}

    @inlinable
    public func parse(_ input: inout Input) throws -> Double {
      let original = input
      let s = try input.parseFloat("double")
      guard let n = Double(String(decoding: s, as: UTF8.self))
      else {
        throw ParsingError.failed(
          summary: "failed to process double from \(formatValue(s))",
          from: original,
          to: input
        )
      }
      return n
    }
  }

  /// A parser that consumes a float from the beginning of a collection of UTF-8 code units.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// `Float.parser()`, which constructs this type.
  ///
  /// ```swift
  /// var input = "123.45 Hello world"[...]
  /// try Float.parser().parse(&input)  // 123.45
  /// input                              // " Hello world"
  /// ```
  public struct FloatParser<Input>: Parser
  where
    Input: Collection,
    Input.SubSequence == Input,
    Input.Element == UTF8.CodeUnit
  {
    @inlinable
    public init() {}

    @inlinable
    public func parse(_ input: inout Input) throws -> Float {
      let original = input
      let s = try input.parseFloat("float")
      guard let n = Float(String(decoding: s, as: UTF8.self))
      else {
        throw ParsingError.failed(
          summary: "failed to process float from \(formatValue(s))",
          from: original,
          to: input
        )
      }
      return n
    }
  }

  #if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
    /// A parser that consumes a float from the beginning of a collection of UTF-8 code units.
    ///
    /// You will not typically need to interact with this type directly. Instead you will usually
    /// use `Float80.parser()`, which constructs this type.
    ///
    /// ```swift
    /// var input = "123.45 Hello world"[...]
    /// try Float80.parser().parse(&input)  // 123.45
    /// input                              // " Hello world"
    /// ```
    public struct Float80Parser<Input>: Parser
    where
      Input: Collection,
      Input.SubSequence == Input,
      Input.Element == UTF8.CodeUnit
    {
      @inlinable
      public init() {}

      @inlinable
      public func parse(_ input: inout Input) throws -> Float80 {
        let original = input
        let s = try input.parseFloat("extended-precision float")
        guard let n = Float80(String(decoding: s, as: UTF8.self))
        else {
          throw ParsingError.failed(
            summary: "failed to process extended-precision float from \(formatValue(s))",
            from: original,
            to: input
          )
        }
        return n
      }
    }
  #endif
}

extension Collection where SubSequence == Self, Element == UTF8.CodeUnit {
  @inlinable
  @inline(__always)
  mutating func parseFloat(_ label: String) throws -> SubSequence {
    let original = self
    if self.first == .init(ascii: "-") || self.first == .init(ascii: "+") {
      self.removeFirst()
    }
    let integer = self.prefix(while: (.init(ascii: "0") ... .init(ascii: "9")).contains)
    guard !integer.isEmpty else { throw ParsingError.expectedInput(label, at: self) }
    self.removeFirst(integer.count)
    if self.first == .init(ascii: ".") {
      let fractional =
        self
        .dropFirst()
        .prefix(while: (.init(ascii: "0") ... .init(ascii: "9")).contains)
      guard !fractional.isEmpty else { return original[..<self.startIndex] }
      self.removeFirst(1 + fractional.count)
    }
    if self.first == .init(ascii: "e") || self.first == .init(ascii: "E") {
      var n = 1
      if self.dropFirst().first == .init(ascii: "-") || self.dropFirst().first == .init(ascii: "+")
      {
        n += 1
      }
      let exponent =
        self
        .dropFirst(n)
        .prefix(while: (.init(ascii: "0") ... .init(ascii: "9")).contains)
      guard !exponent.isEmpty else { return original[..<self.startIndex] }
      self.removeFirst(n + exponent.count)
    }
    return original[..<self.startIndex]
  }
}
