import SwiftUI

@dynamicMemberLookup
@propertyWrapper
@MainActor
public struct UIBinding<Value>: Sendable {
  private let location: any _UIBinding<Value>
  var animation: UIAnimation?

  init(location: any _UIBinding<Value>, animation: UIAnimation?) {
    self.location = location
    self.animation = animation
  }

  init<Root: AnyObject>(
    root: Root,
    keyPath: ReferenceWritableKeyPath<Root, Value>,
    animation: UIAnimation?
  ) {
    self.init(
      location: _UIBindingAppendKeyPath(
        base: _UIBindingRoot(wrappedValue: root),
        keyPath: keyPath
      ),
      animation: animation
    )
  }

  public init?(_ base: UIBinding<Value?>) {
    guard let initialValue = base.wrappedValue
    else { return nil }
    func open(_ location: some _UIBinding<Value?>) -> any _UIBinding<Value> {
      _UIBindingFromOptional(initialValue: initialValue, base: location)
    }
    self.init(location: open(base.location), animation: base.animation)
  }

  public init<V>(_ base: UIBinding<V>) where Value == V? {
    func open(_ location: some _UIBinding<V>) -> any _UIBinding<Value> {
      _UIBindingToOptional(base: location)
    }
    self.init(location: open(base.location), animation: base.animation)
  }

  // TODO: How is this used in SwiftUI? Is this useful in UIKit? Remove?
//  public init<V: Hashable>(_ base: UIBinding<V>) where Value == AnyHashable {
//    func open(_ location: some _UIBinding<V>) -> any _UIBinding<Value> {
//      _UIBindingToAnyHashable(base: location)
//    }
//    self.init(location: open(base.location), animation: base.animation)
//  }

  public init(projectedValue: UIBinding<Value>) {
    self = projectedValue
  }

  public static func constant(_ value: Value) -> Self {
    Self(location: _UIBindingConstant(value), animation: nil)
  }

  public var wrappedValue: Value {
    get {
      self.location.wrappedValue
    }
    nonmutating set {
      self.location.wrappedValue = newValue
    }
  }

  public var projectedValue: Self {
    self
  }

  // TODO: Motivate?
  public func isPresent<Wrapped>() -> UIBinding<Bool> where Value == Wrapped? {
    func open(_ location: some _UIBinding<Value>) -> UIBinding<Bool> {
      UIBinding<Bool>(
        location: _UIBindingIsPresent(base: location),
        animation: animation
      )
    }
    return open(self.location)
  }

  public subscript<Member>(
    dynamicMember keyPath: WritableKeyPath<Value, Member>
  ) -> UIBinding<Member> {
    func open(_ location: some _UIBinding<Value>) -> UIBinding<Member> {
      UIBinding<Member>(
        location: _UIBindingAppendKeyPath(base: location, keyPath: keyPath),
        animation: self.animation
      )
    }
    return open(self.location)
  }

  public subscript<Member>(
    dynamicMember keyPath: KeyPath<Value.AllCasePaths, AnyCasePath<Value, Member>>
  ) -> UIBinding<Member>?
  where Value: CasePathable {
    func open(_ location: some _UIBinding<Value>) -> UIBinding<Member?> {
      UIBinding<Member?>(
        location: _UIBindingEnumToOptionalCase(base: location, keyPath: keyPath),
        animation: self.animation
      )
    }
    return UIBinding<Member>(open(self.location))
  }

  public subscript<V: CasePathable, Member>(
    dynamicMember keyPath: KeyPath<V.AllCasePaths, AnyCasePath<V, Member>>
  ) -> UIBinding<Member?>
  where Value == V? {
    func open(_ location: some _UIBinding<Value>) -> UIBinding<Member?> {
      UIBinding<Member?>(
        location: _UIBindingOptionalEnumToCase(base: location, keyPath: keyPath),
        animation: self.animation
      )
    }
    return open(self.location)
  }

  public func animation(_ animation: UIAnimation? = .default) -> Self {
    var binding = self
    binding.animation = animation
    return binding
  }

  public var isAnimated: Bool {
    self.animation != nil
  }
}

extension UIBinding: Equatable {
  nonisolated public static func == (lhs: Self, rhs: Self) -> Bool {
    func openLHS<B: _UIBinding<Value>>(_ lhs: B) -> Bool {
      func openRHS(_ rhs: some _UIBinding<Value>) -> Bool {
        lhs == rhs as? B
      }
      return openRHS(rhs.location)
    }
    return openLHS(lhs.location)
  }
}

extension UIBinding: Hashable {
  nonisolated public func hash(into hasher: inout Hasher) {
    hasher.combine(self.location)
  }
}

// TODO: Given `Equatable` and `Hashable` conformances, should `Identifiable` be unconditional?
extension UIBinding: Identifiable {
  nonisolated public var id: AnyHashable {
    AnyHashable(self.location)
  }
}

// TODO: Conform to BidirectionalCollection/Collection/RandomAccessCollection/Sequence?
// TODO: Conform to DynamicProperty?

protocol _UIBinding<Value>: AnyObject, Hashable, Sendable {
  associatedtype Value
  var wrappedValue: Value { get set }
}

private final class _UIBindingRoot<Value: AnyObject>: _UIBinding, @unchecked Sendable {
  var wrappedValue: Value
  init(wrappedValue: Value) {
    self.wrappedValue = wrappedValue
  }
  static func == (lhs: _UIBindingRoot, rhs: _UIBindingRoot) -> Bool {
    lhs.wrappedValue === rhs.wrappedValue
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self.wrappedValue))
  }
}

private final class _UIBindingConstant<Value>: _UIBinding, @unchecked Sendable {
  let value: Value
  init(_ value: Value) {
    self.value = value
  }
  var wrappedValue: Value {
    get { self.value }
    set {}
  }
  static func == (lhs: _UIBindingConstant, rhs: _UIBindingConstant) -> Bool {
    lhs === rhs
  }
  func hash(into hasher: inout Hasher) {
    if let value = value as? any Hashable {
      hasher.combine(AnyHashable(value))
    } else {
      hasher.combine(ObjectIdentifier(self))
    }
  }
}

private final class _UIBindingIsPresent<Base: _UIBinding, Wrapped>: _UIBinding
where Base.Value == Wrapped?
{
  let base: Base
  init(base: Base) {
    self.base = base
  }
  var wrappedValue: Bool {
    get {
      self.base.wrappedValue != nil
    }
    set {
      if !newValue {
        self.base.wrappedValue = nil
      }
    }
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(base)
  }
  static func == (lhs: _UIBindingIsPresent, rhs: _UIBindingIsPresent) -> Bool {
    lhs.base == rhs.base
  }
}

private final class _UIBindingAppendKeyPath<Base: _UIBinding, Value>: _UIBinding, @unchecked Sendable {
  let base: Base
  let keyPath: WritableKeyPath<Base.Value, Value>
  init(base: Base, keyPath: WritableKeyPath<Base.Value, Value>) {
    self.base = base
    self.keyPath = keyPath
  }
  var wrappedValue: Value {
    get { self.base.wrappedValue[keyPath: self.keyPath] }
    set { self.base.wrappedValue[keyPath: self.keyPath] = newValue }
  }
  static func == (lhs: _UIBindingAppendKeyPath, rhs: _UIBindingAppendKeyPath) -> Bool {
    lhs.base == rhs.base && lhs.keyPath == rhs.keyPath
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.base)
    hasher.combine(self.keyPath)
  }
}

private final class _UIBindingFromOptional<Base: _UIBinding<Value?>, Value>: _UIBinding, @unchecked Sendable {
  var value: Value
  let base: Base
  init(initialValue: Value, base: Base) {
    self.value = initialValue
    self.base = base
  }
  var wrappedValue: Value {
    get {
      if let value = self.base.wrappedValue {
        self.value = value
      }
      return self.value
    }
    set {
      self.value = newValue
      if self.base.wrappedValue != nil {
        self.base.wrappedValue = newValue
      }
    }
  }
  static func == (lhs: _UIBindingFromOptional, rhs: _UIBindingFromOptional) -> Bool {
    lhs.base == rhs.base
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.base)
  }
}

private final class _UIBindingToOptional<Base: _UIBinding>: _UIBinding {
  let base: Base
  init(base: Base) {
    self.base = base
  }
  var wrappedValue: Base.Value? {
    get { self.base.wrappedValue }
    set {
      guard let newValue else { return }
      self.base.wrappedValue = newValue
    }
  }
  static func == (lhs: _UIBindingToOptional, rhs: _UIBindingToOptional) -> Bool {
    lhs.base == rhs.base
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.base)
  }
}

//private final class _UIBindingToAnyHashable<Base: _UIBinding>: _UIBinding
//where Base.Value: Hashable {
//  let base: Base
//  init(base: Base) {
//    self.base = base
//  }
//  var wrappedValue: AnyHashable {
//    get { self.base.wrappedValue }
//    set {
//      // TODO: Use swift-dependencies to make this precondition testable?
//      self.base.wrappedValue = newValue.base as! Base.Value
//    }
//  }
//  static func == (lhs: _UIBindingToAnyHashable, rhs: _UIBindingToAnyHashable) -> Bool {
//    lhs.base == rhs.base
//  }
//  func hash(into hasher: inout Hasher) {
//    hasher.combine(self.base)
//  }
//}

private final class _UIBindingEnumToOptionalCase<Base: _UIBinding, Case>: _UIBinding, @unchecked Sendable
where Base.Value: CasePathable {
  let base: Base
  let keyPath: KeyPath<Base.Value.AllCasePaths, AnyCasePath<Base.Value, Case>>
  let casePath: AnyCasePath<Base.Value, Case>
  init(base: Base, keyPath: KeyPath<Base.Value.AllCasePaths, AnyCasePath<Base.Value, Case>>) {
    self.base = base
    self.keyPath = keyPath
    self.casePath = Base.Value.allCasePaths[keyPath: keyPath]
  }
  var wrappedValue: Case? {
    get {
      self.casePath.extract(from: self.base.wrappedValue)
    }
    set {
      guard let newValue, self.casePath.extract(from: self.base.wrappedValue) != nil
      else { return }
      self.base.wrappedValue = self.casePath.embed(newValue)
    }
  }
  static func == (lhs: _UIBindingEnumToOptionalCase, rhs: _UIBindingEnumToOptionalCase) -> Bool {
    lhs.base == rhs.base && lhs.keyPath == rhs.keyPath
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.base)
    hasher.combine(self.keyPath)
  }
}

private final class _UIBindingOptionalEnumToCase<
  Base: _UIBinding<Enum?>, Enum: CasePathable, Case
>: _UIBinding, @unchecked Sendable {
  let base: Base
  let keyPath: KeyPath<Enum.AllCasePaths, AnyCasePath<Enum, Case>>
  let casePath: AnyCasePath<Enum, Case>
  init(base: Base, keyPath: KeyPath<Enum.AllCasePaths, AnyCasePath<Enum, Case>>) {
    self.base = base
    self.keyPath = keyPath
    self.casePath = Enum.allCasePaths[keyPath: keyPath]
  }
  var wrappedValue: Case? {
    get {
      self.base.wrappedValue.flatMap(self.casePath.extract(from:))
    }
    set {
      guard self.base.wrappedValue.flatMap(self.casePath.extract(from:)) != nil
      else { return }
      self.base.wrappedValue = newValue.map(self.casePath.embed)
    }
  }
  static func == (lhs: _UIBindingOptionalEnumToCase, rhs: _UIBindingOptionalEnumToCase) -> Bool {
    lhs.base == rhs.base && lhs.keyPath == rhs.keyPath
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.base)
    hasher.combine(self.keyPath)
  }
}

extension UIBinding {
  init<V: RandomAccessCollection & RangeReplaceableCollection>(_ base: UIBinding<V>)
  where Value == any RandomAccessCollection & RangeReplaceableCollection {
    func open(_ location: some _UIBinding<V>) -> any _UIBinding<Value> {
      _UIBindingToAnyRangeReplaceableCollection(base: location)
    }
    self.init(location: open(base.location), animation: base.animation)
  }
}

private final class _UIBindingToAnyRangeReplaceableCollection<Base: _UIBinding>: _UIBinding
where Base.Value: RandomAccessCollection & RangeReplaceableCollection {
  let base: Base
  init(base: Base) {
    self.base = base
  }
  var wrappedValue: any RandomAccessCollection & RangeReplaceableCollection {
    // _read { yield self.base.wrappedValue }
    // _modify {
    //   var wrappedValue = self.base.wrappedValue as any RangeReplaceableCollection & RandomAccessCollection
    //   yield &wrappedValue
    //   self.base.wrappedValue = wrappedValue as! Base.Value
    // }
    get { self.base.wrappedValue }
    set { self.base.wrappedValue = newValue as! Base.Value }
  }
  static func == (
    lhs: _UIBindingToAnyRangeReplaceableCollection,
    rhs: _UIBindingToAnyRangeReplaceableCollection
  ) -> Bool {
    lhs.base == rhs.base
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.base)
  }
}

