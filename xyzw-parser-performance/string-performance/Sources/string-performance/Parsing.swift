import Foundation

struct Parser<Input, Output> {
  let run: (inout Input) -> Output?
}

extension Parser where Input == Substring {
  var utf8: Parser<Substring.UTF8View, Output> {
    .init { input in
      var substring = Substring(input)
      let output = self.run(&substring)
      input = substring.utf8
      return output
    }
  }
}

extension Parser {
  func run(_ input: Input) -> (match: Output?, rest: Input) {
    var input = input
    let match = self.run(&input)
    return (match, input)
  }
}

extension Parser where Input == Substring, Output == Int {
  static let int = Self { input in
    let original = input

    var isFirstCharacter = true
    let intPrefix = input.prefix { c in
      defer { isFirstCharacter = false }
      return (c == "-" || c == "+") && isFirstCharacter
        || c.isNumber
    }

    guard let match = Int(intPrefix)
    else {
      input = original
      return nil
    }
    input.removeFirst(intPrefix.count)
    return match
  }
}

extension Parser where Input == Substring.UnicodeScalarView, Output == Int {
  static let int = Self { input in
    let original = input

    var isFirstCharacter = true
    let intPrefix = input.prefix { c in
      defer { isFirstCharacter = false }
      return (c == "-" || c == "+") && isFirstCharacter
        || ("0"..."9").contains(c)
    }

    guard let match = Int(String(intPrefix))
    else {
      input = original
      return nil
    }
    input.removeFirst(intPrefix.count)
    return match
  }
}

extension Parser where Input == Substring.UTF8View, Output == Int {
  static let int = Self { input in
    let original = input

    var isFirstCharacter = true
    let intPrefix = input.prefix { c in
      defer { isFirstCharacter = false }
      return (c == UTF8.CodeUnit(ascii: "-") || c == UTF8.CodeUnit(ascii: "+")) && isFirstCharacter
        || (UTF8.CodeUnit(ascii: "0")...UTF8.CodeUnit(ascii: "9")).contains(c)
    }

    guard let match = Int(String(Substring(intPrefix)))
    else {
      input = original
      return nil
    }
    input.removeFirst(intPrefix.count)
    return match
  }
}


extension Parser where Input == Substring, Output == Double {
  static let double = Self { input in
    let original = input
    let sign: Double
    if input.first == "-" {
      sign = -1
      input.removeFirst()
    } else if input.first == "+" {
      sign = 1
      input.removeFirst()
    } else {
      sign = 1
    }

    var decimalCount = 0
    let prefix = input.prefix { c in
      if c == "." { decimalCount += 1 }
      return c.isNumber || (c == "." && decimalCount <= 1)
    }

    guard let match = Double(prefix)
    else {
      input = original
      return nil
    }

    input.removeFirst(prefix.count)
    return match * sign
  }
}

extension Parser
where
  Input: Collection,
  Input.SubSequence == Input,
  Output == Input.Element
{
  static var first: Self {
    .init { input in
      guard !input.isEmpty else { return nil }
      return input.removeFirst()
    }
  }
}

extension Parser where Input == Substring.UTF8View, Output == Double {
  static let double = Self { input in
    let original = input
    let sign: Double
    if input.first == .init(ascii: "-") {
      sign = -1
      input.removeFirst()
    } else if input.first == .init(ascii: "+") {
      sign = 1
      input.removeFirst()
    } else {
      sign = 1
    }

    var decimalCount = 0
    let prefix = input.prefix { c in
      if c == .init(ascii: ".") { decimalCount += 1 }
      return (.init(ascii: "0") ... .init(ascii: "9")).contains(c) || (c == .init(ascii: ".") && decimalCount <= 1)
    }

    guard let match = Double(String(Substring(prefix)))
    else {
      input = original
      return nil
    }

    input.removeFirst(prefix.count)
    return match * sign
  }
}


extension Parser where Input == Substring, Output == Character {
  static let char = first
//  static let char = Self { input in
//    guard !input.isEmpty else { return nil }
//    return input.removeFirst()
//  }
}

extension Parser {
  static func always(_ output: Output) -> Self {
    Self { _ in output }
  }

  static var never: Self {
    Self { _ in nil }
  }
}

extension Parser {
  func map<NewOutput>(_ f: @escaping (Output) -> NewOutput) -> Parser<Input, NewOutput> {
    .init { input in
      self.run(&input).map(f)
    }
  }
}

extension Parser {
  func flatMap<NewOutput>(
    _ f: @escaping (Output) -> Parser<Input, NewOutput>
  ) -> Parser<Input, NewOutput> {
    .init { input in
      let original = input
      let output = self.run(&input)
      let newParser = output.map(f)
      guard let newOutput = newParser?.run(&input) else {
        input = original
        return nil
      }
      return newOutput
    }
  }
}

func zip<Input, Output1, Output2>(
  _ p1: Parser<Input, Output1>,
  _ p2: Parser<Input, Output2>
) -> Parser<Input, (Output1, Output2)> {

  .init { input -> (Output1, Output2)? in
    let original = input
    guard let output1 = p1.run(&input) else { return nil }
    guard let output2 = p2.run(&input) else {
      input = original
      return nil
    }
    return (output1, output2)
  }
}

extension Parser {
  static func oneOf(_ ps: [Self]) -> Self {
    .init { input in
      for p in ps {
        if let match = p.run(&input) {
          return match
        }
      }
      return nil
    }
  }

  static func oneOf(_ ps: Self...) -> Self {
    self.oneOf(ps)
  }
}

extension Parser {
  func zeroOrMore(
    separatedBy separator: Parser<Input, Void> = .always(())
  ) -> Parser<Input, [Output]> {
    Parser<Input, [Output]> { input in
      var rest = input
      var matches: [Output] = []
      while let match = self.run(&input) {
        rest = input
        matches.append(match)
        if separator.run(&input) == nil {
          return matches
        }
      }
      input = rest
      return matches
    }
  }
}

extension Parser
where Input: Collection,
      Input.SubSequence == Input,
      Output == Void,
      Input.Element: Equatable {
  static func prefix(_ p: Input.SubSequence) -> Self {
    Self { input in
      guard input.starts(with: p) else { return nil }
      input.removeFirst(p.count)
      return ()
    }
  }
}

extension Parser
where
  Input: Collection,
  Input.SubSequence == Input,
  Output == Input
{
  static func prefix(while p: @escaping (Input.Element) -> Bool) -> Self {
    Self { input in
      let output = input.prefix(while: p)
      input.removeFirst(output.count)
      return output
    }
  }
}

extension Parser
where
  Input: Collection,
  Input.SubSequence == Input,
  Input.Element: Equatable,
  Output == Input
{
  static func prefix(upTo subsequence: Input) -> Self {
    Self { input in
      guard !subsequence.isEmpty else { return subsequence }
      let original = input
      while !input.isEmpty {
        if input.starts(with: subsequence) {
          return original[..<input.startIndex]
        }
        input.removeFirst()
      }
      input = original
      return nil
    }
  }
}

extension Parser
where
  Input: Collection,
  Input.SubSequence == Input,
  Input.Element: Equatable,
  Output == Input
{
  static func prefix(through subsequence: Input) -> Self {
    Self { input in
      guard !subsequence.isEmpty else { return subsequence }
      let original = input
      while !input.isEmpty {
        if input.starts(with: subsequence) {
          let index = input.index(input.startIndex, offsetBy: subsequence.count)
          input = input[index...]
          return original[..<index]
        }
        input.removeFirst()
      }
      input = original
      return nil
    }
  }
}


extension Parser: ExpressibleByUnicodeScalarLiteral where Input == Substring, Output == Void {
  typealias UnicodeScalarLiteralType = StringLiteralType
}

extension Parser: ExpressibleByExtendedGraphemeClusterLiteral where Input == Substring, Output == Void {
  typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
}

extension Parser: ExpressibleByStringLiteral where Input == Substring, Output == Void {
  typealias StringLiteralType = String

  init(stringLiteral value: String) {
    self = .prefix(value[...])
  }
}

extension Parser {
  static func skip(_ p: Self) -> Parser<Input, Void> {
    p.map { _ in () }
  }

  func skip<OtherOutput>(_ p: Parser<Input, OtherOutput>) -> Self {
    zip(self, p).map { a, _ in a }
  }

  func take<NewOutput>(_ p: Parser<Input, NewOutput>) -> Parser<Input, (Output, NewOutput)> {
    zip(self, p)
  }

  func take<A>(_ p: Parser<Input, A>) -> Parser<Input, A>
  where Output == Void {
    zip(self, p).map { _, a in a }
  }

  func take<A, B, C>(_ p: Parser<Input, C>) -> Parser<Input, (A, B, C)>
  where Output == (A, B) {
    zip(self, p).map { ab, c in
      (ab.0, ab.1, c)
    }
  }
}
