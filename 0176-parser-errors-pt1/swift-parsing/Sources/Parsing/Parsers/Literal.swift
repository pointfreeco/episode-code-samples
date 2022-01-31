extension Array: Parser where Element: Equatable {
  public typealias Input = SubSequence
  public typealias Output = Void

  @inlinable
  public func parse(_ input: inout ArraySlice<Element>) -> Void? {
    guard input.starts(with: self) else { return nil }
    input.removeFirst(self.count)
    return ()
  }
}

extension String: Parser {
  public typealias Input = SubSequence
  public typealias Output = Void

  @inlinable
  public func parse(_ input: inout Substring) throws {
    guard input.starts(with: self)
    else { throw ParsingError("expected \(self.debugDescription)") }

    input.removeFirst(self.count)
  }
}

func foo() /* -> Void */ {
  return /* () */
}

extension String.UnicodeScalarView: Parser {
  public typealias Input = SubSequence
  public typealias Output = Void

  @inlinable
  public func parse(_ input: inout Substring.UnicodeScalarView) -> Void? {
    guard input.starts(with: self) else { return nil }
    input.removeFirst(self.count)
    return ()
  }
}

extension String.UTF8View: Parser {
  public typealias Input = SubSequence
  public typealias Output = Void

  @inlinable
  public func parse(_ input: inout Substring.UTF8View) -> Void? {
    guard input.starts(with: self) else { return nil }
    input.removeFirst(self.count)
    return ()
  }
}
