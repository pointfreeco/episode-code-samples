import UIKit

@available(iOS 17.0, *)
@MainActor
public struct UIDismissAction: Sendable {
  let run: @MainActor @Sendable () -> Void
  public func callAsFunction() {
    self.run()
  }
}

@available(iOS 17.0, *)
private enum DismissActionTrait: UITraitDefinition {
  static let defaultValue = UIDismissAction { 
    // Runtime warn that there is no presentation context
  }
}

@available(iOS 17.0, *)
extension UITraitCollection {
  public var dismiss: UIDismissAction { self[DismissActionTrait.self] }
}

@available(iOS 17.0, *)
extension UIMutableTraits {
  var dismiss: UIDismissAction {
    get { self[DismissActionTrait.self] }
    set { self[DismissActionTrait.self] = newValue }
  }
}
