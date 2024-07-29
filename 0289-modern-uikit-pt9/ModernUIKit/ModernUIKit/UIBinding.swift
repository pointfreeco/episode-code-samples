import CasePaths
import Perception
import SwiftUI

@dynamicMemberLookup
@propertyWrapper
struct UIBinding<Value>: Hashable {
  fileprivate let base: AnyObject
  fileprivate let keyPath: AnyKeyPath

  // init(get: () -> Value, set: (Value) -> Void)

  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(base))
    hasher.combine(keyPath)
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.base === rhs.base && lhs.keyPath == rhs.keyPath
  }

  var wrappedValue: Value {
    get {
      (base as Any)[keyPath: keyPath] as! Value
    }
    nonmutating set {
      func open<Root>(_ root: Root) {
        root[keyPath: keyPath as! ReferenceWritableKeyPath<Root, Value>] = newValue
      }
      _openExistential(base, do: open)
    }
  }

  subscript<Member>(dynamicMember keyPath: WritableKeyPath<Value, Member>) -> UIBinding<Member> {
    UIBinding<Member>(base: base, keyPath: self.keyPath.appending(path: keyPath)!)
  }

  public subscript<Enum: CasePathable, Member>(
    dynamicMember keyPath: KeyPath<Enum.AllCasePaths, AnyCasePath<Enum, Member>>
  ) -> UIBinding<Member?>
  where Value == Enum? {
    self[keyPath]
  }
}

@dynamicMemberLookup
@propertyWrapper
struct UIBindable<Value> {
  var wrappedValue: Value
  var projectedValue: Self {
    get { self }
    set { self = newValue }
  }

  init(wrappedValue: Value) where Value: Perceptible, Value: AnyObject {
    self.wrappedValue = wrappedValue
  }

  subscript<Member>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, Member>) -> UIBinding<Member>
  where Value: AnyObject {
    UIBinding(base: wrappedValue, keyPath: keyPath)
  }
}

extension Optional where Wrapped: CasePathable {
  fileprivate subscript<Member>(
    keyPath: KeyPath<Wrapped.AllCasePaths, AnyCasePath<Wrapped, Member>>
  ) -> Member? {
    get {
      guard let wrapped = self else { return nil }
      return Wrapped.allCasePaths[keyPath: keyPath].extract(from: wrapped)
    }
    set {
      guard let newValue else {
        self = nil
        return
      }
      self = Wrapped.allCasePaths[keyPath: keyPath].embed(newValue)
    }
  }
}
