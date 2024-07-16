import UIKit

open class NavigationStackController<Data: Collection>: UINavigationController
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
