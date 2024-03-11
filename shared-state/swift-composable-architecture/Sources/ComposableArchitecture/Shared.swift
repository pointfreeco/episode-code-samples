import Perception

class ChangeTracker {
  var onDeinit: () -> Void = {}
  var didChange = false
  deinit {
    self.onDeinit()
  }
}

enum SharedLocals {
  @TaskLocal static var isAsserting = false
  @TaskLocal static var changeTracker: ChangeTracker?
  static var isTracking: Bool { self.changeTracker != nil }
}

protocol StorageProtocol<Value>: AnyObject {
  associatedtype Value
  var value: Value { get set }
  var currentValue: Value { get }
  var snapshot: Value? { get }
}

@propertyWrapper
@dynamicMemberLookup
public struct Shared<Value> {
  let keyPath: AnyKeyPath
  let storage: any StorageProtocol

  public var wrappedValue: Value {
    get {
      func open<Root>(_ storage: some StorageProtocol<Root>) -> Value {
        storage.value[keyPath: self.keyPath] as! Value
      }
      return open(self.storage)
    }
    set {
      func open<Root>(_ storage: some StorageProtocol<Root>) {
        storage.value[keyPath: self.keyPath as! WritableKeyPath<Root, Value>] = newValue
      }
      open(self.storage)
    }
  }
  // @Shared var count: Int
  public init(_ wrappedValue: Value) {
    self.keyPath = \Value.self
    self.storage = Storage(value: wrappedValue)
  }
  // @Shared("stats") var stats = Stats()
  public init(wrappedValue: Value, _ key: some PersistenceKey<Value>) {
    self.keyPath = \Value.self
    if let shared = sharedStates[key] as? Shared<Value>.Storage {
      self.storage = shared
    } else {
      self.storage = Storage(value: wrappedValue, persistenceKey: key)
      sharedStates[key] = self.storage
    }
  }
  init(storage: some StorageProtocol, keyPath: AnyKeyPath) {
    self.storage = storage
    self.keyPath = keyPath
  }
  public var projectedValue: Shared {
    self
  }

  @Perceptible
  final class Storage: StorageProtocol {
    let persistenceKey: (any PersistenceKey<Value>)?
    var _currentValue: Value

    var currentValue: Value {
      get {
        _currentValue
      }
      set {
        _currentValue = newValue
        self.persistenceKey?.save(newValue)
      }
    }
    var snapshot: Value?
    init(
      value: Value,
      persistenceKey: (any PersistenceKey<Value>)? = nil
    ) {
      self._currentValue = persistenceKey?.load() ?? value
      self.persistenceKey = persistenceKey
      if let updates =  persistenceKey?.updates {
        Task { @MainActor in 
          for await value in updates {
            self._currentValue = value
          }
        }
      }
    }
    var value: Value {
      get {
        if SharedLocals.isAsserting {
          return self.snapshot ?? self.currentValue
        } else {
          return self.currentValue
        }
      }
      set {
        if SharedLocals.isAsserting {
          self.snapshot = newValue
        } else {
          if SharedLocals.isTracking, self.snapshot == nil {
            self.snapshot = self.currentValue
            SharedLocals.changeTracker?.onDeinit = {
              self.snapshot = nil
            }
          }
          self.currentValue = newValue
          SharedLocals.changeTracker?.didChange = true
        }
      }
    }
  }

  public subscript<Member>(
    dynamicMember keyPath: WritableKeyPath<Value, Member>
  ) -> Shared<Member> {
    Shared<Member>(
      storage: self.storage,
      keyPath: self.keyPath.appending(path: keyPath)!
    )
  }
}

private var sharedStates: [AnyHashable: AnyObject] = [:]

extension Shared {
  var snapshot: Value? {
    func open<Root>(_ storage: some StorageProtocol<Root>) -> Value? {
      storage.snapshot?[keyPath: self.keyPath] as? Value
    }
    return open(self.storage)
  }
  var currentValue: Value {
    func open<Root>(_ storage: some StorageProtocol<Root>) -> Value {
      storage.currentValue[keyPath: self.keyPath] as! Value
    }
    return open(self.storage)
  }
}

extension Shared: Equatable where Value: Equatable {
  public static func == (lhs: Shared, rhs: Shared) -> Bool {
    if SharedLocals.isAsserting {
      return lhs.snapshot ?? lhs.currentValue == rhs.currentValue
    } else {
      return lhs.currentValue == rhs.currentValue
    }
  }
}
//extension Shared: Equatable where Value: Equatable {
//  public static func == (lhs: Shared<Value>, rhs: Shared<Value>) -> Bool {
//    lhs.storage == rhs.storage
//  }
//}

extension Shared.Storage: _CustomDiffObject {
  public var _customDiffValues: (Any, Any) {
    (self.snapshot ?? self.currentValue, self.currentValue)
  }
}
extension Shared: CustomDumpRepresentable {
  public var customDumpValue: Any {
    self.storage
  }
}
