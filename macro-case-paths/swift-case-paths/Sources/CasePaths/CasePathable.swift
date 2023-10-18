public protocol CasePathable {
  associatedtype Cases
  static var cases: Cases { get }
}

public typealias CaseKeyPath<Root: CasePathable, Value> =
  KeyPath<Root.Cases, CasePath<Root, Value>>

