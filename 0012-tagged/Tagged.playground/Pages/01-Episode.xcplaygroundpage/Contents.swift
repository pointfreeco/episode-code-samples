
public struct Tagged<Tag, RawValue> {
  public var rawValue: RawValue

  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }
}

extension Tagged: CustomStringConvertible {
  public var description: String {
    return String(describing: self.rawValue)
  }
}

extension Tagged: RawRepresentable {
}
