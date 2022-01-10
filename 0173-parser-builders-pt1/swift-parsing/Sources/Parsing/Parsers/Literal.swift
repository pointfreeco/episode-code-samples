extension Array: Parser where Element: Equatable {
  @inlinable
  public func parse(_ input: inout ArraySlice<Element>) -> Void? {
    guard input.starts(with: self) else { return nil }
    input.removeFirst(self.count)
    return ()
  }
}

extension String: Parser {
  @inlinable
  public func parse(_ input: inout Substring) -> Void? {
    guard input.starts(with: self) else { return nil }
    input.removeFirst(self.count)
    return ()
  }
}

extension String.UnicodeScalarView: Parser {
  @inlinable
  public func parse(_ input: inout Substring.UnicodeScalarView) -> Void? {
    guard input.starts(with: self) else { return nil }
    input.removeFirst(self.count)
    return ()
  }
}

extension String.UTF8View: Parser {
  @inlinable
  public func parse(_ input: inout Substring.UTF8View) -> Void? {
    guard input.starts(with: self) else { return nil }
    input.removeFirst(self.count)
    return ()
  }
}
