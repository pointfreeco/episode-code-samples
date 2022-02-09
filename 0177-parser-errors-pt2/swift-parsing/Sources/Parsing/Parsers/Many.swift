import Foundation

/// A parser that attempts to run another parser as many times as specified, accumulating the result
/// of the outputs.
///
/// For example, given a comma-separated string of numbers, one could parse out an array of
/// integers:
///
/// ```swift
/// var input = "1,2,3"[...]
/// let output = Many {
///   Int.parser()
/// } separator: {
///   ","
/// }.parse(&input)
/// precondition(input == "")
/// precondition(output == [1, 2, 3])
/// ```
///
/// The most general version of `Many` takes a closure that can customize how outputs accumulate,
/// much like `Sequence.reduce(into:_)`. We could, for example, sum the numbers as we parse them
/// instead of accumulating each value in an array:
///
/// ```
/// let sumParser = Many(into: 0, +=) {
///   Int.parser()
/// } separator: {
///   ","
/// }
/// var input = "1,2,3"[...]
/// let output = Many(Int.parser(), into: 0, separator: ",").parse(&input)
/// precondition(input == "")
/// precondition(output == 6)
/// ```
public struct Many<Element, Result, Separator, Terminator>: Parser
where
  Element: Parser,
  Separator: Parser,
  Element.Input == Separator.Input,
  Terminator: Parser,
  Terminator.Input == Element.Input
{
  public typealias Input = Element.Input
  public typealias Output = Result

//  public let doesConsumeAll: Bool

  public let element: Element
  public let initialResult: Result
  public let maximum: Int
  public let minimum: Int
  public let separator: Separator
  public let terminator: Terminator
  public let updateAccumulatingResult: (inout Result, Element.Output) -> Void

  /// Initializes a parser that attempts to run the given parser at least and at most the given
  /// number of times, accumulating the outputs into a result with a given closure.
  ///
  /// - Parameters:
  ///   - initialResult: The value to use as the initial accumulating value.
  ///   - minimum: The minimum number of times to run this parser and consider parsing to be
  ///     successful.
  ///   - maximum: The maximum number of times to run this parser before returning the output.
  ///   - updateAccumulatingResult: A closure that updates the accumulating result with each output
  ///     of the element parser.
  ///   - element: A parser to run multiple times to accumulate into a result.
  ///   - separator: A parser that consumes input between each parsed output.
  @inlinable
  public init(
    into initialResult: Result,
    atLeast minimum: Int = 0,
    atMost maximum: Int = .max,
    _ updateAccumulatingResult: @escaping (inout Result, Element.Output) -> Void,
    @ParserBuilder element: () -> Element,
    @ParserBuilder separator: () -> Separator,
    @ParserBuilder terminator: () -> Terminator
  ) {

//    print(<#T##items: Any...##Any#>, separator: <#T##String#>, terminator: <#T##String#>)

    self.element = element()
    self.initialResult = initialResult
    self.maximum = maximum
    self.minimum = minimum
    self.separator = separator()
    self.terminator = terminator()
    self.updateAccumulatingResult = updateAccumulatingResult
  }

  @inlinable
  public func parse(_ input: inout Element.Input) throws -> Result {
    let original = input
    var rest = input
    var result = self.initialResult
    var count = 0
    var loopError: Error?
    while count < self.maximum {
      let output: Element.Output
      do {
        output = try self.element.parse(&input)
      } catch {
        loopError = error
        break
      }

      count += 1
      self.updateAccumulatingResult(&result, output)
      rest = input
      do {
        _ = try self.separator.parse(&input) as Separator.Output
      } catch {
        loopError = error
        break
      }
    }
    guard count >= self.minimum else {
      defer { input = original }
      throw ParsingError(
        expected: "\(self.minimum) values of \(Element.Output.self)",
        remainingInput: input
      )
    }
    input = rest
    do {
      _ = try self.terminator.parse(&input) as Terminator.Output
    } catch {
      input = original
      throw loopError ?? error
    }
    return result
  }
}

extension Many where Separator == Always<Input, Void> {
  /// Initializes a parser that attempts to run the given parser at least and at most the given
  /// number of times, accumulating the outputs into a result with a given closure.
  ///
  /// - Parameters:
  ///   - initialResult: The value to use as the initial accumulating value.
  ///   - minimum: The minimum number of times to run this parser and consider parsing to be
  ///     successful.
  ///   - maximum: The maximum number of times to run this parser before returning the output.
  ///   - updateAccumulatingResult: A closure that updates the accumulating result with each output
  ///     of the element parser.
  ///   - element: A parser to run multiple times to accumulate into a result.
  @inlinable
  public init(
    into initialResult: Result,
    atLeast minimum: Int = 0,
    atMost maximum: Int = .max,
    _ updateAccumulatingResult: @escaping (inout Result, Element.Output) -> Void,
    @ParserBuilder element: () -> Element,
    @ParserBuilder terminator: () -> Terminator
  ) {
    self.element = element()
    self.initialResult = initialResult
    self.maximum = maximum
    self.minimum = minimum
    self.separator = .init(())
    self.terminator = terminator()
    self.updateAccumulatingResult = updateAccumulatingResult
  }
}

extension Many where Result == [Element.Output] {
  /// Initializes a parser that attempts to run the given parser at least and at most the given
  /// number of times, accumulating the outputs in an array.
  ///
  /// - Parameters:
  ///   - minimum: The minimum number of times to run this parser and consider parsing to be
  ///     successful.
  ///   - maximum: The maximum number of times to run this parser before returning the output.
  ///   - element: A parser to run multiple times to accumulate into an array.
  ///   - separator: A parser that consumes input between each parsed output.
  @inlinable
  public init(
    atLeast minimum: Int = 0,
    atMost maximum: Int = .max,
    @ParserBuilder element: () -> Element,
    @ParserBuilder separator: () -> Separator,
    @ParserBuilder terminator: () -> Terminator
  ) {
    self.init(
      into: [],
      atLeast: minimum,
      atMost: maximum,
      { $0.append($1) },
      element: element,
      separator: separator,
      terminator: terminator
    )
  }
}

extension Many where Result == [Element.Output], Separator == Always<Input, Void> {
  /// Initializes a parser that attempts to run the given parser at least and at most the given
  /// number of times, accumulating the outputs in an array.
  ///
  /// - Parameters:
  ///   - minimum: The minimum number of times to run this parser and consider parsing to be
  ///     successful.
  ///   - maximum: The maximum number of times to run this parser before returning the output.
  ///   - element: A parser to run multiple times to accumulate into an array.
  @inlinable
  public init(
    atLeast minimum: Int = 0,
    atMost maximum: Int = .max,
    @ParserBuilder element: () -> Element,
    @ParserBuilder terminator: () -> Terminator
  ) {
    self.init(
      into: [],
      atLeast: minimum,
      atMost: maximum,
      { $0.append($1) },
      element: element,
      terminator: terminator
    )
  }
}

extension Parsers {
  public typealias Many = Parsing.Many  // NB: Convenience type alias for discovery
}
