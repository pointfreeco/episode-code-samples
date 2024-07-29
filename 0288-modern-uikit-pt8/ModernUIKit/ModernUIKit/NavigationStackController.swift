import UIKit

@MainActor
private protocol _NavigationStackController<Data>: AnyObject {
  associatedtype Data where Data: RangeReplaceableCollection

  var path: Data { get set }
}

open class NavigationStackController<Data: RangeReplaceableCollection & RandomAccessCollection>: UINavigationController, _NavigationStackController, UINavigationControllerDelegate
where Data.Element: Hashable {
  @UIBinding var path: Data
  let root: UIViewController
  let destination: (Data.Element) -> UIViewController

  init(
    path: UIBinding<Data>,
    root: () -> UIViewController,
    destination: @escaping (Data.Element) -> UIViewController
  ) {
    self._path = path
    self.root = root()
    self.destination = destination
    super.init(nibName: nil, bundle: nil)
    self.delegate = self
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open override func viewDidLoad() {
    super.viewDidLoad()

    observe { [weak self] in
      guard let self else { return }

      setViewControllers(
        [root] + path.map { element in
          guard let existingController = self.viewControllers.first(
            where: { $0.navigationID == AnyHashable(element) }
          )
          else {
            let controller = self.destination(element)
            controller.navigationID = element
            return controller
          }
          return existingController
        },
        animated: true
      )
    }
  }

  public func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    let diff = path.count - (viewControllers.count - 1)
    if diff > 0 {
      path.removeLast(diff)
    }
  }
}

extension UIViewController {
  fileprivate var navigationID: AnyHashable? {
    get {
      return objc_getAssociatedObject(self, navigationIDKey) as? AnyHashable
    }
    set {
      objc_setAssociatedObject(
        self,
        navigationIDKey,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
}
private let navigationIDKey = malloc(1)!

extension UINavigationController {
  func push<Element>(value: Element) {
    func open<Data>(_ controller: some _NavigationStackController<Data>) {
      guard Element.self == Data.Element.self
      else {
        // TODO: runtime warning
        return
      }

      controller.path.append(value as! Data.Element)
    }
    guard let navStack = self as? any _NavigationStackController
    else {
      // TODO: runtime warning
      return
    }
    open(navStack)
  }
}
