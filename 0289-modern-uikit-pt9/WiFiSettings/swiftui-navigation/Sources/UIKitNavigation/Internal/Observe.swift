import Foundation

@MainActor
public func observe(_ apply: @escaping @MainActor @Sendable () -> Void) {
  onChange(apply)
}

extension NSObject {
  @MainActor
  public func observe(_ apply: @escaping @MainActor @Sendable () -> Void) {
    onChange(apply)
  }
}

fileprivate func onChange(_ apply: @escaping @MainActor @Sendable () -> Void) {
  withPerceptionTracking {
    MainActor.assumeIsolated { apply() }
  } onChange: {
    Task { @MainActor in
      withUIAnimation(UIAnimation.current) {
        onChange(apply)
      }
    }
  }
}
