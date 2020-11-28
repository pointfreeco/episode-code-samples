protocol ParserProtocol {
  associatedtype Input
  associatedtype Output

  func parse(_ input: inout Input) -> Output?
}

import Foundation

// extension Parser where Input == Substring.UTF8View, Output == Int
struct IntParser: ParserProtocol {
  typealias Input = Substring.UTF8View
  typealias Output = Int

  init() {}

  func parse(_ input: inout Substring.UTF8View) -> Int? {
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

struct SkipSecond<A, B>: ParserProtocol
where
  A: ParserProtocol,
  B: ParserProtocol,
  A.Input == B.Input
{
  typealias Input = A.Input
  typealias Output = A.Output

  let a: A
  let b: B

  init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  func parse(_ input: inout Input) -> Output? {
    let original = input

    guard let a = self.a.parse(&input)
    else { return nil }

    guard self.b.parse(&input) != nil
    else {
      input = original
      return nil
    }

    return a
  }
}

struct Take2<A, B>: ParserProtocol
where
  A: ParserProtocol,
  B: ParserProtocol,
  A.Input == B.Input
{
  typealias Input = A.Input
  typealias Output = (A.Output, B.Output)

  let a: A
  let b: B

  init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  func parse(_ input: inout Input) -> Output? {
    let original = input
    guard let a = self.a.parse(&input)
    else { return nil }
    guard let b = self.b.parse(&input)
    else {
      input = original
      return nil
    }
    return (a, b)
  }
}

extension ParserProtocol {
  func take<P>(_ other: P) -> Take2<Self, P>
  where P: ParserProtocol, P.Input == Input {
    Take2(self, other)
  }
}

struct First<Collection>: ParserProtocol
where
  Collection: Swift.Collection,
  Collection.SubSequence == Collection {

  typealias Input = Collection
  typealias Output = Collection.Element

  func parse(_ input: inout Collection) -> Collection.Element? {
    guard !input.isEmpty else { return nil }
    return input.removeFirst()
  }
}

struct PrefixWhile<Collection>: ParserProtocol
where
  Collection: Swift.Collection,
  Collection.SubSequence == Collection,
  Collection.Element: Equatable
{
  typealias Input = Collection
  typealias Output = Collection

  let predicate: (Collection.Element) -> Bool

  func parse(_ input: inout Input) -> Output? {
    let output = input.prefix(while: self.predicate)
    input.removeFirst(output.count)
    return output
  }
}

struct Prefix<Collection>: ParserProtocol
where
  Collection: Swift.Collection,
  Collection.SubSequence == Collection,
  Collection.Element: Equatable
{
  typealias Input = Collection
  typealias Output = Void

  let possiblePrefix: Collection

  init(
    _ possiblePrefix: Collection
  ) {
    self.possiblePrefix = possiblePrefix
  }

  func parse(_ input: inout Input) -> Output? {
    guard input.starts(with: self.possiblePrefix)
    else { return nil }

    input.removeFirst(self.possiblePrefix.count)
    return ()
  }
}

extension ParserProtocol {
  func skip<P>(_ parser: P) -> SkipSecond<Self, P>
  where P: ParserProtocol, P.Input == Input {
    .init(self, parser)
  }
}

extension ParserProtocol where Output == Void {
  func take<P>(_ parser: P) -> SkipFirst<Self, P>
  where P: ParserProtocol, P.Input == Input, Output == Void {
    .init(self, parser)
  }
}

struct OneOf<A, B>: ParserProtocol
where
  A: ParserProtocol,
  B: ParserProtocol,
  A.Input == B.Input,
  A.Output == B.Output
{
  typealias Input = A.Input
  typealias Output = A.Output

  let a: A
  let b: B

  init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  func parse(_ input: inout Input) -> Output? {
    if let output = self.a.parse(&input) { return output }
    if let output = self.b.parse(&input) { return output }
    return nil
  }
}

struct SkipFirst<A, B>: ParserProtocol
where
  A: ParserProtocol,
  B: ParserProtocol,
  A.Input == B.Input
{
  typealias Input = A.Input
  typealias Output = B.Output

  let a: A
  let b: B
  init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  func parse(_ input: inout Input) -> Output? {
    let original = input

    guard self.a.parse(&input) != nil
    else { return nil }

    guard let b = self.b.parse(&input)
    else {
      input = original
      return nil
    }

    return b
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

  init(
    _ upstream: Upstream,
    separatedBy separator: Separator
  ) {
    self.upstream = upstream
    self.separator = separator
  }

  func parse(_ input: inout Input) -> Output? {
    var rest = input
    var outputs = Output()
    while let output = self.upstream.parse(&input) {
      rest = input
      outputs.append(output)
      if self.separator.parse(&input) == nil {
        return outputs
      }
    }
    input = rest
    return outputs
  }
}



extension ParserProtocol {
  func map<NewOutput>(
    _ transform: @escaping (Output) -> NewOutput
  ) -> Map<Self, NewOutput> {
    .init(upstream: self, transform: transform)
  }
}

struct Map<Upstream, Output>: ParserProtocol where Upstream: ParserProtocol {
  typealias Input = Upstream.Input
  let upstream: Upstream
  let transform: (Upstream.Output) -> Output

  init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output) {
    self.upstream = upstream
    self.transform = transform
  }

  func parse(_ input: inout Input) -> Output? {
    self.upstream.parse(&input).map(self.transform)
  }
}

