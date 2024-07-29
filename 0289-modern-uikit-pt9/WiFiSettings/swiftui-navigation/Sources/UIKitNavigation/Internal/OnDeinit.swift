import UIKit

final class OnDeinit {
  let onDismiss: () -> Void
  init(onDismiss: @escaping () -> Void) {
    self.onDismiss = onDismiss
  }
  deinit {
    onDismiss()
  }
}

extension UIViewController {
  var onDeinit: OnDeinit? {
    get {
      objc_getAssociatedObject(self, onDeinitKey) as? OnDeinit
    }
    set {
      objc_setAssociatedObject(self, onDeinitKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

private let onDeinitKey = malloc(1)!
