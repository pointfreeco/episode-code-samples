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

@propertyWrapper
public struct Shared<Value> {
//  private var currentValue: Value
//  private var snapshot: Value?
  let storage: Storage

  public var wrappedValue: Value {
    get { self.storage.value }
    set { self.storage.value = newValue }
  }
  public init(_ wrappedValue: Value) {
    self.storage = Storage(value: wrappedValue)
  }
  // @Shared("stats") var stats = Stats()
  public init(wrappedValue: Value, _ key: String) {
    if let shared = sharedStates[key] as? Shared<Value>.Storage {
      self.storage = shared
    } else {
      self.storage = Storage(value: wrappedValue)
      sharedStates[key] = self.storage
    }
  }
  public var projectedValue: Shared {
    self
  }

  @Perceptible
  final class Storage {
    var currentValue: Value
    var snapshot: Value?
    init(value: Value) {
      self.currentValue = value
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
}

private var sharedStates: [String: AnyObject] = [:]

extension Shared.Storage: Equatable where Value: Equatable {
  static func == (lhs: Shared.Storage, rhs: Shared.Storage) -> Bool {
    if SharedLocals.isAsserting {
      return lhs.snapshot ?? lhs.currentValue == rhs.currentValue
    } else {
      return lhs.currentValue == rhs.currentValue
    }
  }
}
extension Shared: Equatable where Value: Equatable {}

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
