/// Declares a type that can parse an `Input` value into an `Output` value.
///
/// * [Getting started](#Getting-started)
/// * [String abstraction levels](#String-abstraction-levels)
/// * [Error messages](#Error-messages)
/// * [Backtracking](#Backtracking)
///
/// ## Getting started
///
/// A parser attempts to parse a nebulous piece of data, represented by the `Input` associated type,
/// into something more well-structured, represented by the `Output` associated type. The parser
/// implements the ``parse(_:)-76tcw`` method, which is handed an `inout Input`, and its job is to
/// turn this into an `Output` if possible, or throw an error if it cannot.
///
/// The argument of the ``parse(_:)-76tcw`` function is `inout` because a parser will usually
/// consume some of the input in order to produce an output. For example, we can use an
/// `Int.parser()` parser to extract an integer from the beginning of a substring and consume that
/// portion of the string:
///
/// ```swift
/// var input: Substring = "123 Hello world"
///
/// try Int.parser().parse(&input)  // 123
/// input                           // " Hello world"
/// ```
///
/// Note that this parser works on `Substring` rather than `String` because substrings expose efficient ways
/// of removing characters from its beginning. Substrings are "views" into a string, specificed by start and
/// end indices. Operations like `removeFirst`, `removeLast` and others can be implemented efficiently on
/// substrings because they simply move the start and end indices, whereas their implementation on strings
/// must make a copy of the string with the characters removed.
///
/// ## String abstraction levels
///
/// It is possible to seamlessly parse on different abstraction levels of strings. Working on high-level and
/// low-level `String` abstractions each have their pros and cons.
///
/// Parsing low-level abstractions, such as `UTF8View` or a collection of UTF-8 code units, has better
/// performance but at the cost of potentially losing correctness. The most canonical example of this is
/// trying to parse the character "é", which can be represented in code units as `[233]` or `[101, 769]`.
/// If you don't remember to always parse both representations you may have a bug where you accidentally
/// fail your parser when it encounters a code unit sequence you don't support.
///
/// On the other hand, parsing high-level inputs, such as `Substring` or `UnicodeScalarView`, can guarantee
/// correctness, but at the cost of performance. For example, `Substring` handles the complexities of extended
/// grapheme clusters and UTF-8 normalization for you, but traversing strings is slower since its elements
/// are variable width.
///
/// The library gives you the tools that allow you to choose which abstraction level you want to work on, as
/// well as the ability to fluidly move between abstraction levels where it makes sense.
///
/// For example, say we want to parse particular city names from the beginning of a string:
///
/// ```swift
/// enum City {
///   case london
///   case newYork
///   case sanJose
/// }
/// ```
///
/// Because "San José" has an accented character, the safest way to parse it is to parse on the `Substring`
/// abstraction level:
///
/// ```swift
/// let city = OneOf {
///   "London".map { City.london }
///   "New York".map { City.newYork }
///   "San José".map { City.sanJose }
/// }
///
/// var input = "San José,123"[...]
/// try city.parse(&input)  // City.sanJose
/// input                   // ",123"
/// ```
///
/// However, we are incurring the cost of parsing `Substring` for this entire parser, even though only the
/// "San José" case needs that power. We can refactor this parser so that "London" and "New York" are parsed
/// on the `UTF8View` level, since they consist of only ASCII characters, and then parse "San José" as
/// `Substring`:
///
/// ```swift
/// let city = OneOf {
///   "London".utf8.map { City.london }
///   "New York".utf8.map { City.newYork }
///   FromSubstring {
///     "San José".map { City.sanJose }
///   }
/// }
/// ```
///
/// The `FromSubstring` parser allows us to temporarily leave the world of parsing UTF-8 and instead work on
/// the higher level `Substring` abstraction, which takes care of normalization of the "é" character.
///
/// If we wanted to be _really_ pedantic we could even parse "San Jos" as UTF-8 and then parse only the "é"
/// character as a substring:
///
/// ```swift
/// let city = OneOf {
///   "London".utf8.map { City.london }
///   "New York".utf8.map { City.newYork }
///   Parse(City.sanJose) {
///     "San Jos".utf8
///     FromSubstring { "é" }
///   }
/// }
/// ```
///
/// This allows you to parse as much as possible on the more performant, low-level `UTF8View`, while still
/// allowing you to parse on the more correct, high-level `Substring` when necessary.
///
/// ## Error messages
///
/// When a parser fails it throws an error containing information about what went wrong. The actual error
/// thrown by the parsers shipped with this library is internal, and so should be considered opaque. To get
/// a human-readable description of the error message you can stringify the error. For example, the following
/// `UInt8` parser fails to parse a string that would cause it to overflow:
///
/// ```swift
/// do {
///   var input = "1234 Hello"[...]
///   let number = try UInt8.parser().parse(&input))
/// } catch {
///   print(error)
///
///   // error: failed to process "UInt8"
///   //  --> input:1:1-4
///   // 1 | 1234 Hello
///   //   | ^^^^ overflowed 255
/// }
/// ```
///
/// ## Backtracking
///
/// Parsers may consume input even if they throw an error, and you should not depend on a parser
/// restoring the input to the original value when failing. The process of restoring the input to the
/// original value is known as "backtracking". Backtracking can be handy when wanting to try many parsers
/// on the same input, and one usually does this by using the ``OneOf`` parser, which automatically backtracks
/// when one of its parsers fails.
///
/// By not requiring backtracking of each individual parser we can greatly simply the logic of parsers and we
/// can coalesce all backtracking logic into just a single parser, the ``OneOf`` parser. If you really need
/// backtracking capabilities then we recommend using the ``OneOf`` parser to control backtracking.
///
/// If used naively, backtracking can lead to less performant parsing code. For example, if we wanted to
/// parse two integers from a string that were separated by either a dash "-" or slash "/", then we could
/// write this as:
///
/// ```swift
/// OneOf {
///   Parser { Int.parser(); "-"; Int.parser() } // 1️⃣
///   Parser { Int.parser(); "/"; Int.parser() } // 2️⃣
/// }
/// ```
///
/// However, parsing slash-separated integers is not going to be performant because it will first run the
/// entire 1️⃣ parser until it fails, then backtrack to the beginning, and run the 2️⃣ parser. In particular,
/// the first integer will get parsed twice, unnecessarily repeating that work. On the other hand, we can
/// factor out the common work of the parser and localize the backtracking `OneOf` work to make a much more
/// performant parser:
///
/// ```swift
/// Parse {
///   Int.parser()
///   OneOf { "-"; "/" }
///   Int.parser()
/// }
/// ```
@rethrows
public protocol Parser {
  /// The kind of values this parser receives.
  associatedtype Input

  /// The kind of values parsed by this parser.
  associatedtype Output

  /// Attempts to parse a nebulous piece of data into something more well-structured.
  ///
  /// - Parameter input: A nebulous, mutable piece of data to be incrementally parsed.
  /// - Returns: A more well-structured value parsed from the given input.
  func parse(_ input: inout Input) throws -> Output
}

extension Parser {
  /// Attempts to parse a nebulous piece of data into something more well-structured.
  ///
  /// - Parameter input: A nebulous piece of data to be parsed.
  /// - Returns: A more well-structured value parsed from the given input.
  @inlinable
  public func parse(_ input: Input) rethrows -> Output {
    var input = input
    return try self.parse(&input)
  }

  /// Attempts to parse a nebulous collection of data into something more well-structured.
  ///
  /// - Parameter input: A nebulous collection of data to be parsed.
  /// - Returns: A more well-structured value parsed from the given input.
  @inlinable
  public func parse<C: Collection>(_ input: C) rethrows -> Output
  where Input == C.SubSequence {
    try self.parse(input[...])
  }

  /// Attempts to parse a nebulous collection of data into something more well-structured.
  ///
  /// - Parameter input: A nebulous collection of data to be parsed.
  /// - Returns: A more well-structured value parsed from the given input.
  @_disfavoredOverload
  @inlinable
  public func parse<S: StringProtocol>(_ input: S) rethrows -> Output
  where Input == S.SubSequence.UTF8View {
    try self.parse(input[...].utf8)
  }
}
