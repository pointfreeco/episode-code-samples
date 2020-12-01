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
