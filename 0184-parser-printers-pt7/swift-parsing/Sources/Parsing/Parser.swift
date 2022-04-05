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
/// try Int.parser().parse(&input) // 123
/// input // " Hello world"
/// ```
///
/// Note that this parser works on `Substring` rather than `String` because substrings expose
/// efficient ways of removing characters from its beginning. Substrings are "views" into a string,
/// specificed by start and end indices. Operations like `removeFirst`, `removeLast` and others can
/// be implemented efficiently on substrings because they simply move the start and end indices,
/// whereas their implementation on strings must make a copy of the string with the characters
/// removed.
///
/// To explore the concepts of parsers more deeply read the following articles:
///
/// * <doc:GettingStarted>
/// * <doc:Design>
/// * <doc:StringAbstractions>
/// * <doc:ErrorMessages>
/// * <doc:Backtracking>
@rethrows public protocol Parser {
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
    try Parse {
      self
      End<Input>()
    }.parse(input[...])
  }

  /// Attempts to parse a nebulous collection of data into something more well-structured.
  ///
  /// - Parameter input: A nebulous collection of data to be parsed.
  /// - Returns: A more well-structured value parsed from the given input.
  @_disfavoredOverload
  @inlinable
  public func parse<S: StringProtocol>(_ input: S) rethrows -> Output
  where Input == S.SubSequence.UTF8View {
    try Parse {
      self
      End<Input>()
    }.parse(input[...].utf8)
  }
}
