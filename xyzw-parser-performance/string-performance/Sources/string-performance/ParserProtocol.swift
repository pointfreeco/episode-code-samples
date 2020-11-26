public protocol ParserProtocol {
  associatedtype Input
  associatedtype Output

  func parse(_ input: inout Input) -> Output?
}

import Foundation

// extension Parser where Input == Substring.UTF8View, Output == Int
public struct IntParser: ParserProtocol {
  public typealias Input = Substring.UTF8View
  public typealias Output = Int

  public init() {}

  public func parse(_ input: inout Substring.UTF8View) -> Int? {
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

public struct SkipSecond<A, B>: ParserProtocol where A: ParserProtocol, B: ParserProtocol, A.Input == B.Input {
  public typealias Input = A.Input
  public typealias Output = A.Output

  public let a: A
  public let b: B

  public init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  public func parse(_ input: inout Input) -> Output? {
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

public struct Take2<A, B>: ParserProtocol
where
  A: ParserProtocol,
  B: ParserProtocol,
  A.Input == B.Input
{
  public typealias Input = A.Input
  public typealias Output = (A.Output, B.Output)

  public let a: A
  public let b: B

  public init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  public func parse(_ input: inout Input) -> Output? {
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
