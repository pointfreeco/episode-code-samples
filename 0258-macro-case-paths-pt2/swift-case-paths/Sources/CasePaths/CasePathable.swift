public protocol CasePathable {
  associatedtype Cases
  static var cases: Cases { get }
}

public typealias CaseKeyPath<Root: CasePathable, Value> =
  KeyPath<Root.Cases, CasePath<Root, Value>>

extension CasePathable {
  public subscript<Value>(
    dynamicMember keyPath: CaseKeyPath<Self, Value>
  ) -> Value? {
    Self.cases[keyPath: keyPath].extract(from: self)
  }

  public func `is`<Value>(_ keyPath: CaseKeyPath<Self, Value>) -> Bool {
    Self.cases[keyPath: keyPath].extract(from: self) != nil
  }
}
