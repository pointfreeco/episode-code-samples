import ObjectiveC
import UIKit
import SwiftUI

extension UIViewController {
  func present<Item: Identifiable>(
    item: @autoclosure @escaping () -> Binding<Item?>,
    content: @escaping (Item) -> UIViewController
  ) {
//    observe { [weak self] in
//      guard let self else { return }
//      let item = item()
//      if let unwrappedItem = item.wrappedValue {
//        @MainActor
//        func presentNewController() {
//          let controller = content(unwrappedItem)
//          controller.onDeinit = OnDeinit { [weak self] in
//            if AnyHashable(unwrappedItem.id) == self?.presented?.id {
//              item.wrappedValue = nil
//            }
//          }
//          presented = Presented(controller: controller, id: unwrappedItem.id)
//          present(controller, animated: true)
//        }
//        if let presented {
//          guard AnyHashable(unwrappedItem.id) != presented.id
//          else { return }
//          presented.controller?.dismiss(animated: true, completion: {
//            presentNewController()
//          })
//        } else {
//          presentNewController()
//        }
//      } else if item.wrappedValue == nil, let controller = presented?.controller {
//        controller.dismiss(animated: true)
//        presented = nil
//      }
//    }
  }

  fileprivate var presented: [AnyHashable: Presented] {
    get {
      objc_getAssociatedObject(
        self,
        presentedKey
      ) as? [AnyHashable: Presented]
      ?? [:]
    }
    set {
      objc_setAssociatedObject(
        self,
        presentedKey,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

  fileprivate var onDeinit: OnDeinit? {
    get {
      objc_getAssociatedObject(
        self,
        onDeinitKey
      ) as? OnDeinit
    }
    set {
      objc_setAssociatedObject(
        self,
        onDeinitKey,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
}

extension UINavigationController {
  func pushViewController<Item>(
    item: @autoclosure @escaping () -> Binding<Item?>,
    content: @escaping (Item) -> UIViewController
  ) {
//    observe { [weak self] in
//      guard let self else { return }
//      let item = item()
//      if let unwrappedItem = item.wrappedValue, presented == nil {
//        let controller = content(unwrappedItem)
//        controller.onDeinit = OnDeinit {
//          item.wrappedValue = nil
//        }
//        presented = Presented(controller: controller)
//        pushViewController(controller, animated: true)
//      } else if item.wrappedValue == nil, let controller = presented?.controller {
//        popFromViewController(controller, animated: true)
//        presented = nil
//      }
//    }
  }

  private func popFromViewController(
    _ controller: UIViewController,
    animated: Bool
  ) {
    guard
      let index = viewControllers.firstIndex(of: controller),
      index != 0
    else {
      return
    }
    popToViewController(viewControllers[index - 1], animated: true)
  }
}

private let presentedKey = malloc(1)!
private let onDeinitKey = malloc(1)!

final fileprivate class OnDeinit {
  let onDismiss: () -> Void
  init(onDismiss: @escaping () -> Void) {
    self.onDismiss = onDismiss
  }
  deinit {
    onDismiss()
  }
}

fileprivate final class Presented {
  weak var controller: UIViewController?
  let id: AnyHashable?
  init(controller: UIViewController? = nil, id: AnyHashable? = nil) {
    self.controller = controller
    self.id = id
  }
}
