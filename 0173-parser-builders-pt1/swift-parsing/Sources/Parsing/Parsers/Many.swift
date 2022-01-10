import Foundation

/// A parser that attempts to run another parser as many times as specified, accumulating the result
/// of the outputs.
///
/// For example, given a comma-separated string of numbers, one could parse out an array of
/// integers:
///
/// ```swift
/// var input = "1,2,3"[...]
/// let output = Many(Int.parser(), separator: ",").parse(&input)
/// precondition(input == "")
/// precondition(output == [1, 2, 3])
/// ```
///
/// The most general version of `Many` takes a closure that can customize how outputs accumulate,
/// much like `Sequence.reduce(into:_)`. We could, for example, sum the numbers as we parse them
/// instead of accumulating each value in an array:
///
/// ```
/// let sumParser = Many(
///   Int.parser(of: Substring.self),
///   into: 0,
///   separator: ",",
///   +=
/// )
/// var input = "1,2,3"[...]
/// let output = Many(Int.parser(), into: 0, separator: ",").parse(&input)
/// precondition(input == "")
/// precondition(output == 6)
/// ```
public struct Many<Element, Result, Separator>: Parser
where
  Element: Parser,
  Separator: Parser,
  Element.Input == Separator.Input
{
  public let initialResult: Result
  public let maximum: Int
  public let minimum: Int
  public let separator: Separator?
  public let updateAccumulatingResult: (inout Result, Element.Output) -> Void
  public let element: Element

  /// Initializes a parser that attempts to run the given parser at least and at most the given
  /// number of times, accumulating the outputs into a result with a given closure.
  ///
  /// - Parameters:
  ///   - element: A parser to run multiple times to accumulate into a result.
  ///   - minimum: The minimum number of times to run this parser and consider parsing to be
  ///     successful.
  ///   - maximum: The maximum number of times to run this parser before returning the output.
  ///   - separator: A parser that consumes input between each parsed output.
  ///   - updateAccumulatingResult: A closure that updates the accumulating result with each output
  ///     of the element parser.
  @inlinable
  public init(
    _ element: Element,
    into initialResult: Result,
    atLeast minimum: Int = 0,
    atMost maximum: Int = .max,
    separator: Separator,
    _ updateAccumulatingResult: @escaping (inout Result, Element.Output) -> Void
  ) {
    self.initialResult = initialResult
    self.maximum = maximum
    self.minimum = minimum
    self.separator = separator
    self.updateAccumulatingResult = updateAccumulatingResult
    self.element = element
  }

  @inlinable
  public func parse(_ input: inout Element.Input) -> Result? {
    let original = input
    var rest = input
    #if DEBUG
      var previous = input
    #endif
    var result = self.initialResult
    var count = 0
    while count < self.maximum,
      let output = self.element.parse(&input)
    {
      #if DEBUG
        defer { previous = input }
      #endif
      count += 1
      self.updateAccumulatingResult(&result, output)
      rest = input
      if self.separator != nil, self.separator?.parse(&input) == nil {
        break
      }
      #if DEBUG
        if memcmp(&input, &previous, MemoryLayout<Element.Input>.size) == 0 {
          var description = ""
          debugPrint(output, terminator: "", to: &description)
          breakpoint(
            """
            ---
            A "Many" parser succeeded in parsing a value of "\(Element.Output.self)" \
            (\(description)), but no input was consumed.

            This is considered a logic error that leads to an infinite loop, and is typically \
            introduced by parsers that always succeed, even though they don't consume any input. \
            This includes "Prefix" and "CharacterSet" parsers, which return an empty string when \
            their predicate immediately fails.

            To work around the problem, require that some input is consumed (for example, use \
            "Prefix(minLength: 1)"), or introduce a "separator" parser to "Many".
            ---
            """
          )
        }
      #endif
    }
    guard count >= self.minimum else {
      input = original
      return nil
    }
    input = rest
    return result
  }
}

extension Many where Result == [Element.Output], Separator == Always<Input, Void> {
  /// Initializes a parser that attempts to run the given parser at least and at most the given
  /// number of times, accumulating the outputs in an array.
  ///
  /// - Parameters:
  ///   - element: A parser to run multiple times to accumulate into an array.
  ///   - minimum: The minimum number of times to run this parser and consider parsing to be
  ///     successful.
  ///   - maximum: The maximum number of times to run this parser before returning the output.
  @inlinable
  public init(
    _ element: Element,
    atLeast minimum: Int = 0,
    atMost maximum: Int = .max
  ) {
    self.init(element, into: [], atLeast: minimum, atMost: maximum) {
      $0.append($1)
    }
  }
}

extension Many where Result == [Element.Output] {
  /// Initializes a parser that attempts to run the given parser at least and at most the given
  /// number of times, accumulating the outputs in an array.
  ///
  /// - Parameters:
  ///   - element: A parser to run multiple times to accumulate into an array.
  ///   - minimum: The minimum number of times to run this parser and consider parsing to be
  ///     successful.
  ///   - maximum: The maximum number of times to run this parser before returning the output.
  ///   - separator: A parser that consumes input between each parsed output.
  @inlinable
  public init(
    _ element: Element,
    atLeast minimum: Int = 0,
    atMost maximum: Int = .max,
    separator: Separator
  ) {
    self.init(element, into: [], atLeast: minimum, atMost: maximum, separator: separator) {
      $0.append($1)
    }
  }
}

extension Many where Separator == Always<Input, Void> {

  /// Initializes a parser that attempts to run the given parser at least and at most the given
  /// number of times, accumulating the outputs into a result with a given closure.
  ///
  /// - Parameters:
  ///   - element: A parser to run multiple times to accumulate into a result.
  ///   - minimum: The minimum number of times to run this parser and consider parsing to be
  ///     successful.
  ///   - maximum: The maximum number of times to run this parser before returning the output.
  ///   - updateAccumulatingResult: A closure that updates the accumulating result with each output
  ///     of the element parser.
  @inlinable
  public init(
    _ element: Element,
    into initialResult: Result,
    atLeast minimum: Int = 0,
    atMost maximum: Int = .max,
    _ updateAccumulatingResult: @escaping (inout Result, Element.Output) -> Void
  ) {
    self.initialResult = initialResult
    self.maximum = maximum
    self.minimum = minimum
    self.separator = nil
    self.updateAccumulatingResult = updateAccumulatingResult
    self.element = element
  }
}

extension Parsers {
  public typealias Many = Parsing.Many  // NB: Convenience type alias for discovery
}
