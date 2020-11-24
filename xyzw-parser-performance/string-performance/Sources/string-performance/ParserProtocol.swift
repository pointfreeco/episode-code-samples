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

  @inlinable
  public init() {}

  @inlinable
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

  @inlinable
  public init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  @inlinable
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

  @inlinable
  public init(_ a: A, _ b: B) {
    self.a = a
    self.b = b
  }

  @inlinable
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

public struct Prefix<Collection>: ParserProtocol
where
  Collection: Swift.Collection,
  Collection.SubSequence == Collection,
  Collection.Element: Equatable
{
  public typealias Input = Collection
  public typealias Output = Void

  public let possiblePrefix: Collection

  @inlinable
  public init(_ possiblePrefix: Collection) {
    self.possiblePrefix = possiblePrefix
  }

  @inlinable
  public func parse(_ input: inout Input) -> Output? {
    guard input.starts(with: self.possiblePrefix)
    else { return nil }

    input.removeFirst(self.possiblePrefix.count)
    return ()
  }
}

public struct ZeroOrMore<Upstream, Separator>: ParserProtocol
where
  Upstream: ParserProtocol,
  Separator: ParserProtocol,
  Upstream.Input == Separator.Input
{
  public typealias Input = Upstream.Input
  public typealias Output = [Upstream.Output]

  public let upstream: Upstream
  public let separator: Separator?

  @inlinable
  public init(
    _ upstream: Upstream,
    separatedBy separator: Separator
  ) {
    self.upstream = upstream
    self.separator = separator
  }

  @inlinable
  public func parse(_ input: inout Input) -> Output? {
    var rest = input
    var outputs = Output()
    while let output = self.upstream.parse(&input) {
      rest = input
      outputs.append(output)
      if self.separator != nil, self.separator?.parse(&input) == nil {
        return outputs
      }
    }
    input = rest
    return outputs
  }
}
