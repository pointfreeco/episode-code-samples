import Perception

enum SharedLocals {
  @TaskLocal static var isAsserting = false
}

@propertyWrapper
@Perceptible
public final class Shared<Value> {
  private var currentValue: Value
  public var wrappedValue: Value {
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
        if self.snapshot == nil {
          self.snapshot = self.currentValue
        }
        self.currentValue = newValue
      }
    }
  }
  private var snapshot: Value?
  public init(_ wrappedValue: Value) {
    self.currentValue = wrappedValue
  }
  public var projectedValue: Shared {
    self
  }
}
extension Shared: Equatable where Value: Equatable {
  public static func == (lhs: Shared, rhs: Shared) -> Bool {
    if SharedLocals.isAsserting {
      return lhs.snapshot == rhs.currentValue
    } else {
      return lhs.currentValue == rhs.currentValue
    }
  }
}

extension Shared: _CustomDiffObject {
  public var _customDiffValues: (Any, Any) {
    (self.snapshot ?? self.currentValue, self.currentValue)
  }
}
