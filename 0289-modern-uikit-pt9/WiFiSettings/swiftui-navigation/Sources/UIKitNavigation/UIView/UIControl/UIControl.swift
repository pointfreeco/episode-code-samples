import ConcurrencyExtras
import UIKit

@MainActor
protocol _UIControl: UIControl {}

extension UIControl: _UIControl {}

extension _UIControl {
  @available(iOS 14, *)
  public func bind<Value>(
    _ binding: UIBinding<Value>,
    to keyPath: ReferenceWritableKeyPath<Self, Value>,
    for event: UIControl.Event
  ) {
    self.bind(binding, to: keyPath, for: event, setAnimated: nil)
  }

  @available(iOS 14, *)
  func bind<Value>(
    _ binding: UIBinding<Value>,
    to keyPath: ReferenceWritableKeyPath<Self, Value>,
    for event: UIControl.Event,
    setAnimated: ((Bool) -> Void)?
  ) {
    self.addAction(
      UIAction { [weak self] _ in
        guard let self else { return }
        binding.wrappedValue = self[keyPath: keyPath]
      },
      for: event
    )
    // TODO: Should we vendor LockIsolated?
    let isSetting = LockIsolated(false)
    observe { [weak self] in
      guard let self else { return }
      isSetting.setValue(true)
      defer { isSetting.setValue(false) }
      if let setAnimated {
        setAnimated(binding.isAnimated || UIAnimation.current != nil)
      } else {
        self[keyPath: keyPath] = binding.wrappedValue
      }
    }
    self._observations[keyPath] = self.observe(
      keyPath
    ) { [weak self] _, _ in
      guard let self else { return }
      if !isSetting.value {
        MainActor.assumeIsolated {
          binding.wrappedValue = self[keyPath: keyPath]
        }
      }
    }
  }

  private var _observations: [AnyKeyPath: NSKeyValueObservation] {
    get {
      objc_getAssociatedObject(self, observationsKey) as? [AnyKeyPath: NSKeyValueObservation] ?? [:]
    }
    set {
      objc_setAssociatedObject(self, observationsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

private let observationsKey = malloc(1)!
