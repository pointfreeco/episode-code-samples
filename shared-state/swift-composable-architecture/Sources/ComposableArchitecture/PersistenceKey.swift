import Foundation
public protocol PersistenceKey<Value>: Hashable {
  associatedtype Value
  func load() -> Value?
  func save(_ value: Value)
}

public struct InMemoryKey<Value>: PersistenceKey {
  let key: String
  public func load() -> Value? { nil }
  public func save(_ value: Value) {}
}

public struct AppStorageKey<Value>: PersistenceKey {
  let key: String
  public init(key: String) {
    self.key = key
  }
  public func load() -> Value? {
    UserDefaults.standard.value(forKey: self.key) as? Value
  }
  public func save(_ value: Value) {
    UserDefaults.standard.setValue(value, forKey: self.key)
  }
}

extension PersistenceKey {
  public static func appStorage<Value>(
    _ key: String
  ) -> Self where Self == AppStorageKey<Value> {
    AppStorageKey(key: key)
  }

  public static func inMemory<Value>(
    _ key: String
  ) -> Self where Self == InMemoryKey<Value> {
    InMemoryKey(key: key)
  }
}
