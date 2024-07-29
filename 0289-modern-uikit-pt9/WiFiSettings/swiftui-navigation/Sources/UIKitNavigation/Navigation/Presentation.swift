import SwiftUI
import UIKit

// TODO: Move Alert APIs from TCA to this repo
// TODO: inherit animation from surrounding context?
// TODO: Add `sheet(item:)` and other APIs as helpers?

extension UIViewController {
  public func present(
    isPresented: UIBinding<Bool>,
    onDismiss: (() -> Void)? = nil,
    content: @escaping @MainActor @Sendable () -> UIViewController
  ) {
    present(item: isPresented.toOptionalVoid, onDismiss: onDismiss, content: content)
  }

  public func present<Item>(
    item: UIBinding<Item?>,
    onDismiss: (() -> Void)? = nil,
    content: @escaping @MainActor @Sendable (Item) -> UIViewController
  ) {
    // TODO: Should we skip this `observe` if we detect that we are already in one?
    observe { [weak self] in
      guard let self else { return }
      let key = item.id
      if let unwrappedItem = item.wrappedValue {
        @MainActor
        func presentController(_ controller: UIViewController) {
          controller.onDeinit = OnDeinit { [weak self, presentationID = item.presentationID] in
            guard let self else { return }
            if presentationID == item.presentationID {
              item.wrappedValue = nil
              presented[key] = nil  // TODO: i think we should be cleaning this up here
            }
          }
          if #available(iOS 17.0, *) {
            controller.traitOverrides.dismiss = UIDismissAction { [weak self] in
              guard let self else { return }
              // TODO: Do presentationID check here like above?
              item.wrappedValue = nil
              presented[key] = nil  // TODO: i think we should be cleaning this up here
            }
          }
          presented[key] = Presented(controller, id: item.presentationID)
          // NB: Thread hop is unfortunately necessary since UIKit does not allow presenting
          //     controllers from viewDidLoad.
          DispatchQueue.main.async {
            self.present(controller, animated: true)
          }
        }
        let controller = content(unwrappedItem)
        if let presented = presented[key] {
          if presented.presentationID != item.presentationID {
            dismiss(animated: true) {
              onDismiss?()
              presentController(controller)
            }
          } else {
            // TODO: if we get here something went wrong and i think it's our fault. should we precondition?
          }
        } else {
          presentController(controller)
        }
      } else if let controller = presented[key]?.controller {
        controller.dismiss(animated: true, completion: onDismiss)
        presented[key] = nil
      }
    }
  }

  fileprivate var presented: [AnyHashable: Presented] {
    get {
      (objc_getAssociatedObject(self, presentedKey)
        as? [AnyHashable: Presented])
        ?? [:]
    }
    set {
      objc_setAssociatedObject(self, presentedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

private let presentedKey = malloc(1)!

private extension UIBinding {
  var presentationID: AnyHashable? {
    guard let id = (self.wrappedValue as? any Identifiable)?.id else { return nil }
    return AnyHashable(id)
  }
}

extension UINavigationController {
  public func pushViewController(
    isPresented: UIBinding<Bool>,
    content: @escaping @MainActor @Sendable () -> UIViewController
  ) {
    pushViewController(item: isPresented.toOptionalVoid, content: content)
  }

  public func pushViewController<Item>(
    item: UIBinding<Item?>,
    content: @escaping @MainActor @Sendable (Item) -> UIViewController
  ) {
    // TODO: Should we skip this `observe` if we detect that we are already in one?
    observe { [weak self] in
      guard let self else { return }
      let key = item.id
      if let unwrappedItem = item.wrappedValue, presented[key] == nil {
        let controller = content(unwrappedItem)
        controller.onDeinit = OnDeinit { [weak self] in
          guard let self else { return }
          item.wrappedValue = nil
          presented[key] = nil  // TODO: i think we should be cleaning this up here
        }
        if #available(iOS 17.0, *) {
          controller.traitOverrides.dismiss = UIDismissAction { [weak self] in
            guard let self else { return }
            item.wrappedValue = nil
            presented[key] = nil  // TODO: i think we should be cleaning this up here
          }
        }

        presented[key] = Presented(controller)
        // NB: Thread hop is necessary since UIKit does not allow presenting controllers from
        //     viewDidLoad.
        DispatchQueue.main.async {
          self.pushViewController(controller, animated: true)
        }
      } else if item.wrappedValue == nil,
        let controller = presented[key]?.controller
      {
        popFromViewController(controller, animated: true)
        presented[key] = nil
      }
    }
  }

  func popFromViewController(_ controller: UIViewController, animated: Bool) {
    guard
      let index = viewControllers.firstIndex(of: controller),
      index != 0
    else {
      // TODO: setViewControllers([]) or runtimeWarn or precondition?
      return
    }
    popToViewController(viewControllers[index - 1], animated: true)
  }
}

private class Presented {
  weak var controller: UIViewController?
  let presentationID: AnyHashable?
  init(_ controller: UIViewController, id presentationID: AnyHashable? = nil) {
    self.controller = controller
    self.presentationID = presentationID
  }
}

extension Bool {
  fileprivate var toOptionalVoid: Void? {
    get { self ? () : nil }
    set { self = newValue != nil }
  }
}
