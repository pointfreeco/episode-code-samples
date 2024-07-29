import Perception

#if canImport(Observation)
  import Observation
#endif

@dynamicMemberLookup
@propertyWrapper
@MainActor
public struct UIBindable<Value>: Sendable {
  private let objectIdentifier: ObjectIdentifier

  public var wrappedValue: Value

  init(objectIdentifier: ObjectIdentifier, wrappedValue: Value) {
    self.objectIdentifier = objectIdentifier
    self.wrappedValue = wrappedValue
  }

  @_disfavoredOverload
  public init(_ wrappedValue: Value) where Value: AnyObject & Perceptible {
    self.init(objectIdentifier: ObjectIdentifier(wrappedValue), wrappedValue: wrappedValue)
  }

  @_disfavoredOverload
  public init(wrappedValue: Value) where Value: AnyObject & Perceptible {
    self.init(objectIdentifier: ObjectIdentifier(wrappedValue), wrappedValue: wrappedValue)
  }

  @_disfavoredOverload
  public init(projectedValue: UIBindable<Value>) where Value: AnyObject & Perceptible {
    self = projectedValue
  }

  public var projectedValue: Self {
    self
  }

  public subscript<Member>(
    dynamicMember keyPath: ReferenceWritableKeyPath<Value, Member>
  ) -> UIBinding<Member> where Value: AnyObject {
    UIBinding(root: self.wrappedValue, keyPath: keyPath, animation: nil)
  }
}

#if canImport(Observation)
  @available(macOS 14, iOS 17, watchOS 10, tvOS 17, *)
  extension UIBindable where Value: AnyObject & Observable {
    public init(_ wrappedValue: Value) {
      self.init(objectIdentifier: ObjectIdentifier(wrappedValue), wrappedValue: wrappedValue)
    }

    public init(wrappedValue: Value) {
      self.init(objectIdentifier: ObjectIdentifier(wrappedValue), wrappedValue: wrappedValue)
    }

    public init(projectedValue: UIBindable<Value>) {
      self = projectedValue
    }
  }
#endif

extension UIBindable: Equatable {
  nonisolated public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.objectIdentifier == rhs.objectIdentifier
  }
}

extension UIBindable: Hashable {
  nonisolated public func hash(into hasher: inout Hasher) {
    hasher.combine(self.objectIdentifier)
  }
}

extension UIBindable: Identifiable {
  public struct ID: Hashable {
    fileprivate let rawValue: ObjectIdentifier
  }

  nonisolated public var id: ID {
    ID(rawValue: self.objectIdentifier)
  }
}
