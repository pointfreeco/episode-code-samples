import Foundation

public protocol PersistenceKey<Value>: Hashable {
  associatedtype Value
  func load() -> Value?
  func save(_ value: Value)
  var updates: AsyncStream<Value> { get }
}

public struct InMemoryKey<Value>: PersistenceKey {
  let key: String
  public func load() -> Value? { nil }
  public func save(_ value: Value) {}
  public var updates: AsyncStream<Value> { .finished }
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
  public var updates: AsyncStream<Value> {
    AsyncStream { continuation in
      let observer = Observer(continuation: continuation)
      UserDefaults.standard.addObserver(
        observer,
        forKeyPath: self.key,
        options: [.new],
        context: nil
      )
      continuation.onTermination = { _ in
        UserDefaults.standard.removeObserver(observer, forKeyPath: self.key)
      }
    }
  }

  class Observer: NSObject {
    let continuation: AsyncStream<Value>.Continuation
    init(continuation: AsyncStream<Value>.Continuation) {
      self.continuation = continuation
    }
    override func observeValue(
      forKeyPath keyPath: String?,
      of object: Any?,
      change: [NSKeyValueChangeKey : Any]?,
      context: UnsafeMutableRawPointer?
    ) {
      guard let value = change?[.newKey] as? Value
      else { return }
      self.continuation.yield(value)
    }
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
