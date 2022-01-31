import Foundation

extension UUID {
  /// A parser that consumes a hexadecimal UUID from the beginning of a collection of UTF-8 code
  /// units.
  ///
  /// ```swift
  /// var input = "deadbeef-dead-beef-dead-beefdeadbeef,"[...].utf8
  /// let output = Int.parser().parse(&input)
  /// precondition(output == UUID(uuidString: "deadbeef-dead-beef-dead-beefdeadbeef")!)
  /// precondition(Substring(input) == ",")
  /// ```
  ///
  /// - Parameter inputType: The collection type of UTF-8 code units to parse.
  /// - Returns: A parser that consumes a hexadecimal UUID from the beginning of a collection of
  ///   UTF-8 code units.
  @inlinable
  public static func parser<Input>(
    of inputType: Input.Type = Input.self
  ) -> Parsers.UUIDParser<Input> {
    .init()
  }

  /// A parser that consumes a hexadecimal UUID from the beginning of a substring's UTF-8 view.
  ///
  /// This overload is provided to allow the `Input` generic to be inferred when it is
  /// `Substring.UTF8View`.
  ///
  /// - Parameter inputType: The `Substring` type. This parameter is included to mirror the
  ///   interface that parses any collection of UTF-8 code units.
  /// - Returns: A parser that consumes a hexadecimal UUID from the beginning of a substring's UTF-8
  ///   view.
  @_disfavoredOverload
  @inlinable
  public static func parser(
    of inputType: Substring.UTF8View.Type = Substring.UTF8View.self
  ) -> Parsers.UUIDParser<Substring.UTF8View> {
    .init()
  }

  /// A parser that consumes a hexadecimal UUID from the beginning of a substring.
  ///
  /// This overload is provided to allow the `Input` generic to be inferred when it is `Substring`.
  ///
  /// - Parameter inputType: The `Substring` type. This parameter is included to mirror the
  ///   interface that parses any collection of UTF-8 code units.
  /// - Returns: A parser that consumes a hexadecimal UUID from the beginning of a substring.
  @_disfavoredOverload
  @inlinable
  public static func parser(
    of inputType: Substring.Type = Substring.self
  ) -> FromUTF8View<Substring, Parsers.UUIDParser<Substring.UTF8View>> {
    .init { Parsers.UUIDParser<Substring.UTF8View>() }
  }
}

extension Parsers {
  /// A parser that consumes a UUID from the beginning of a collection of UTF8 code units.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// `UUID.parser()`, which constructs this type.
  public struct UUIDParser<Input>: Parser
  where
    Input: Collection,
    Input.SubSequence == Input,
    Input.Element == UTF8.CodeUnit
  {
    public typealias Input = Input
    public typealias Output = UUID

    @inlinable
    public init() {}

    @inlinable
    public func parse(_ input: inout Input) -> UUID? {
      var prefix = input.prefix(36)
      guard prefix.count == 36
      else { return nil }

      @inline(__always)
      func digit(for n: UTF8.CodeUnit) -> UTF8.CodeUnit? {
        let output: UTF8.CodeUnit
        switch n {
        case .init(ascii: "0") ... .init(ascii: "9"):
          output = UTF8.CodeUnit(n - .init(ascii: "0"))
        case .init(ascii: "A") ... .init(ascii: "F"):
          output = UTF8.CodeUnit(n - .init(ascii: "A") + 10)
        case .init(ascii: "a") ... .init(ascii: "f"):
          output = UTF8.CodeUnit(n - .init(ascii: "a") + 10)
        default:
          return nil
        }
        return output
      }

      @inline(__always)
      func nextByte() -> UInt8? {
        guard
          let n = digit(for: prefix.removeFirst()),
          let m = digit(for: prefix.removeFirst())
        else { return nil }
        return n * 16 + m
      }

      guard
        let _00 = nextByte(),
        let _01 = nextByte(),
        let _02 = nextByte(),
        let _03 = nextByte(),
        prefix.removeFirst() == .init(ascii: "-"),
        let _04 = nextByte(),
        let _05 = nextByte(),
        prefix.removeFirst() == .init(ascii: "-"),
        let _06 = nextByte(),
        let _07 = nextByte(),
        prefix.removeFirst() == .init(ascii: "-"),
        let _08 = nextByte(),
        let _09 = nextByte(),
        prefix.removeFirst() == .init(ascii: "-"),
        let _10 = nextByte(),
        let _11 = nextByte(),
        let _12 = nextByte(),
        let _13 = nextByte(),
        let _14 = nextByte(),
        let _15 = nextByte()
      else { return nil }

      input.removeFirst(36)
      return UUID(
        uuid: (
          _00, _01, _02, _03,
          _04, _05,
          _06, _07,
          _08, _09,
          _10, _11, _12, _13, _14, _15
        )
      )
    }
  }
}
