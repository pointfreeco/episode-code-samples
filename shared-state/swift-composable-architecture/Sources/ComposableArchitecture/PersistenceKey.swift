import Foundation
import UIKit

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

private enum DefaultAppStorageKey: DependencyKey {
  static let liveValue = UncheckedSendable(UserDefaults.standard)
  static var testValue: UncheckedSendable<UserDefaults> {
    let suiteName = "pointfree.co"
    let defaults = UserDefaults(suiteName: suiteName)!
    defaults.removePersistentDomain(forName: suiteName)
    return UncheckedSendable(defaults)
  }
}

extension DependencyValues {
  public var defaultAppStorage: UserDefaults {
    get { self[DefaultAppStorageKey.self].value }
    set { self[DefaultAppStorageKey.self].value = newValue }
  }
}

public struct AppStorageKey<Value>: PersistenceKey {
  @Dependency(\.defaultAppStorage) var defaultAppStorage
  let key: String
  public init(key: String) {
    self.key = key
  }
  public func load() -> Value? {
    defaultAppStorage.value(forKey: self.key) as? Value
  }
  public func save(_ value: Value) {
    defaultAppStorage.setValue(value, forKey: self.key)
  }
  public var updates: AsyncStream<Value> {
    AsyncStream { continuation in
      let observer = Observer(continuation: continuation)
      defaultAppStorage.addObserver(
        observer,
        forKeyPath: self.key,
        options: [.new],
        context: nil
      )
      continuation.onTermination = { _ in
        defaultAppStorage.removeObserver(observer, forKeyPath: self.key)
      }
    }
  }
  public static func == (lhs: AppStorageKey, rhs: AppStorageKey) -> Bool {
    lhs.key == rhs.key
  }
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.key)
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

public final class FileStorageKey<Value: Codable>: PersistenceKey {
  let url: URL
  let saveQueue = DispatchQueue(label: "co.pointfree.save")
  var saveWorkItem: DispatchWorkItem?
  init(url: URL) {
    self.url = url
    NotificationCenter.default.addObserver(
      forName: UIApplication.willResignActiveNotification,
      object: nil,
      queue: nil
    ) { [weak self] _ in
      guard let self, let saveWorkItem else { return }
      saveQueue.async(execute: saveWorkItem)
      saveQueue.async {
        self.saveWorkItem?.cancel()
        self.saveWorkItem = nil
      }
    }
  }

  public func load() -> Value? {
    try? JSONDecoder().decode(Value.self, from: Data(contentsOf: self.url))
  }

  public func save(_ value: Value) {
    self.saveWorkItem?.cancel()
    self.saveWorkItem = DispatchWorkItem { [weak self] in
      guard let self else { return }
      try? JSONEncoder().encode(value).write(to: self.url)
      self.saveWorkItem = nil
    }
    saveQueue.asyncAfter(deadline: .now() + 5, execute: self.saveWorkItem!)
  }

  public var updates: AsyncStream<Value> {
    .finished
  }

  public static func == (lhs: FileStorageKey<Value>, rhs: FileStorageKey<Value>) -> Bool {
    lhs.url == rhs.url
  }
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.url)
  }
}

extension PersistenceKey {
  public static func fileStorage<Value>(
    _ url: URL
  ) -> Self where Self == FileStorageKey<Value> {
    Self(url: url)
  }
}
