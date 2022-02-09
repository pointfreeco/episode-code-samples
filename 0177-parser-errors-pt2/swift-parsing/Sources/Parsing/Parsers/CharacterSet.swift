import Foundation

extension CharacterSet: Parser {
  public typealias Input = Substring
  public typealias Output = Substring

  @inlinable
  public func parse(_ input: inout Substring) -> Substring? {
    let output = input.unicodeScalars.prefix(while: self.contains)
    input.unicodeScalars.removeFirst(output.count)
    return Substring(output)
  }
}
