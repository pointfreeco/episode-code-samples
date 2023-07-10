import Foundation

public final class LockIsolated<Value>: @unchecked Sendable {
  private var _value: Value
  private let lock = NSRecursiveLock()
  public init(_ value: @autoclosure @Sendable () throws -> Value) rethrows {
    self._value = try value()
  }
  public func withValue<T: Sendable>(
    _ operation: (inout Value) throws -> T
  ) rethrows -> T {
    try self.lock.withLock {
      var value = self._value
      defer { self._value = value }
      return try operation(&value)
    }
  }
}

extension LockIsolated where Value: Sendable {
  public var value: Value {
    self.lock.withLock {
      self._value
    }
  }
}
