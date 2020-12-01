protocol ParserProtocol {
  associatedtype Input
  associatedtype Output
  
  func run(_ input: inout Input) -> Output?
}

struct IntParser: ParserProtocol {
  typealias Input = Substring.UTF8View
  typealias Output = Int

  func run(_ input: inout Substring.UTF8View) -> Int? {
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

struct First<Input>: ParserProtocol
where
  Input: Collection,
  Input.SubSequence == Input
{
  typealias Output = Input.Element
  
  func run(_ input: inout Input) -> Input.Element? {
    guard !input.isEmpty else { return nil }
    return input.removeFirst()
  }
}

struct Zip<Parser1, Parser2>: ParserProtocol
where
  Parser1: ParserProtocol,
  Parser2: ParserProtocol,
  Parser1.Input == Parser2.Input
{
  typealias Input = Parser1.Input
  typealias Output = (Parser1.Output, Parser2.Output)
  
  let p1: Parser1
  let p2: Parser2
  
  func run(_ input: inout Parser1.Input) -> (Parser1.Output, Parser2.Output)? {
    let original = input
    guard let output1 = self.p1.run(&input) else { return nil }
    guard let output2 = self.p2.run(&input) else {
      input = original
      return nil
    }
    return (output1, output2)
  }
}

extension ParserProtocol {
  func take<P: ParserProtocol>(_ other: P) -> Zip<Self, P>
  where P.Input == Input {
    Zip(p1: self, p2: other)
  }
}

// Zip(parser1, parser2)

struct PrefixWhile<Input>: ParserProtocol
where
  Input: Collection,
  Input.SubSequence == Input
{
  typealias Output = Input
  
  let predicate: (Input.Element) -> Bool
  
  func run(_ input: inout Input) -> Input? {
    let output = input.prefix(while: self.predicate)
    input.removeFirst(output.count)
    return output
  }
}

struct Prefix<Input>: ParserProtocol
where
  Input: Collection,
  Input.SubSequence == Input,
  Input.Element: Equatable
{
  typealias Output = Void

  let possiblePrefix: Input

  init(_ possiblePrefix: Input) {
    self.possiblePrefix = possiblePrefix
  }

  func run(_ input: inout Input) -> Output? {
    guard input.starts(with: self.possiblePrefix)
    else { return nil }
    input.removeFirst(self.possiblePrefix.count)
    return ()
  }
}

struct SkipSecond<Parser1, Parser2>: ParserProtocol
where
  Parser1: ParserProtocol,
  Parser2: ParserProtocol,
  Parser1.Input == Parser2.Input
{
  typealias Input = Parser1.Input
  typealias Output = Parser1.Output

  let p1: Parser1
  let p2: Parser2

  func run(_ input: inout Input) -> Output? {
    let original = input

    guard let output1 = self.p1.run(&input)
    else { return nil }

    guard self.p2.run(&input) != nil
    else {
      input = original
      return nil
    }

    return output1
  }
}

extension ParserProtocol {
  func skip<P>(_ parser: P) -> SkipSecond<Self, P>
  where P: ParserProtocol, P.Input == Input {
    .init(p1: self, p2: parser)
  }
}

struct SkipFirst<Parser1, Parser2>: ParserProtocol
where
  Parser1: ParserProtocol,
  Parser2: ParserProtocol,
  Parser1.Input == Parser2.Input
{
  typealias Input = Parser1.Input
  typealias Output = Parser2.Output

  let p1: Parser1
  let p2: Parser2

  func run(_ input: inout Input) -> Output? {
    let original = input

    guard self.p1.run(&input) != nil
    else { return nil }

    guard let b = self.p2.run(&input)
    else {
      input = original
      return nil
    }

    return b
  }
}

extension ParserProtocol where Output == Void {
  func take<P>(_ parser: P) -> SkipFirst<Self, P>
  where P: ParserProtocol, P.Input == Input {
    .init(p1: self, p2: parser)
  }
}

struct OneOf<Parser1, Parser2>: ParserProtocol
where
  Parser1: ParserProtocol,
  Parser2: ParserProtocol,
  Parser1.Input == Parser2.Input,
  Parser1.Output == Parser2.Output
{
  typealias Input = Parser1.Input
  typealias Output = Parser1.Output

  let p1: Parser1
  let p2: Parser2

  init(_ p1: Parser1, _ p2: Parser2) {
    self.p1 = p1
    self.p2 = p2
  }

  func run(_ input: inout Input) -> Output? {
    if let output = self.p1.run(&input) { return output }
    if let output = self.p2.run(&input) { return output }
    return nil
  }
}

struct ZeroOrMore<Upstream, Separator>: ParserProtocol
where
  Upstream: ParserProtocol,
  Separator: ParserProtocol,
  Upstream.Input == Separator.Input
{
  typealias Input = Upstream.Input
  typealias Output = [Upstream.Output]

  let upstream: Upstream
  let separator: Separator

  func run(_ input: inout Input) -> Output? {
    var rest = input
    var outputs = Output()
    while let output = self.upstream.run(&input) {
      rest = input
      outputs.append(output)
      if self.separator.run(&input) == nil {
        return outputs
      }
    }
    input = rest
    return outputs
  }
}

extension ParserProtocol {
  func zeroOrMore<Separator>(
    separatedBy separator: Separator
  ) -> ZeroOrMore<Self, Separator> {
    .init(upstream: self, separator: separator)
  }
}

struct Map<Upstream, Output>: ParserProtocol where Upstream: ParserProtocol {
  typealias Input = Upstream.Input
  let upstream: Upstream
  let transform: (Upstream.Output) -> Output

  func run(_ input: inout Input) -> Output? {
    self.upstream.run(&input).map(self.transform)
  }
}

extension ParserProtocol {
  func map<NewOutput>(
    _ transform: @escaping (Output) -> NewOutput
  ) -> Map<Self, NewOutput> {
    .init(upstream: self, transform: transform)
  }
}
