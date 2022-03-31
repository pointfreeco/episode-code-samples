extension Bool {
  /// A parser that consumes a Boolean value from the beginning of a collection of UTF-8 code units.
  ///
  /// This parser only recognizes the literal "true" and "false" characters:
  ///
  /// ```swift
  /// // Parses "true":
  /// var input = "true Hello"[...]
  /// try Bool.parser().parse(&input)  // true
  /// input                            // " Hello"
  ///
  /// // Parses "false":
  /// input = "false Hello"[...]
  /// try Bool.parser().parse(&input)  // false
  /// input                            // " Hello"
  ///
  /// // Otherwise fails:
  /// input = "1 Hello"[...]
  /// try Bool.parser().parse(&input)
  /// // error: unexpected input
  /// //  --> input:1:1
  /// // 1 | 1 Hello
  /// //     ^ expected "true" or "false"
  /// ```
  ///
  /// - Parameter inputType: The collection type of UTF-8 code units to parse.
  /// - Returns: A parser that consumes a Boolean value from the beginning of a collection of UTF-8
  ///   code units.
  @inlinable
  public static func parser<Input>(
    of inputType: Input.Type = Input.self
  ) -> Parsers.BoolParser<Input> {
    .init()
  }

  /// A parser that consumes a Boolean value from the beginning of a substring's UTF-8 view.
  ///
  /// This overload is provided to allow the `Input` generic to be inferred when it is
  /// `Substring.UTF8View`.
  ///
  /// - Parameter inputType: The `Substring.UTF8View` type. This parameter is included to mirror the
  ///   interface that parses any collection of UTF-8 code units.
  /// - Returns: A parser that consumes a Boolean value from the beginning of a substring's UTF-8
  ///   view.
  @inlinable
  public static func parser(
    of inputType: Substring.UTF8View.Type = Substring.UTF8View.self
  ) -> Parsers.BoolParser<Substring.UTF8View> {
    .init()
  }

  /// A parser that consumes a Boolean value from the beginning of a substring.
  ///
  /// This overload is provided to allow the `Input` generic to be inferred when it is `Substring`.
  ///
  /// - Parameter inputType: The `Substring` type. This parameter is included to mirror the
  ///   interface that parses any collection of UTF-8 code units.
  /// - Returns: A parser that consumes a Boolean value from the beginning of a substring.
  @inlinable
  public static func parser(
    of inputType: Substring.Type = Substring.self
  ) -> FromUTF8View<Substring, Parsers.BoolParser<Substring.UTF8View>> {
    .init { Parsers.BoolParser<Substring.UTF8View>() }
  }
}

extension Parsers {
  /// A parser that consumes a Boolean value from the beginning of a collection of UTF-8 code units.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// `Bool.parser()`, which constructs this type.
  public struct BoolParser<Input: Collection>: Parser
  where
    Input.SubSequence == Input,
    Input.Element == UTF8.CodeUnit
  {
    @inlinable
    public init() {}

    @inlinable
    public func parse(_ input: inout Input) throws -> Bool {
      if input.starts(with: [116, 114, 117, 101] /*"true".utf8*/) {
        input.removeFirst(4)
        return true
      } else if input.starts(with: [102, 97, 108, 115, 101] /*"false".utf8*/) {
        input.removeFirst(5)
        return false
      }
      throw ParsingError.expectedInput("\"true\" or \"false\"", at: input)
    }
  }
}
