import Combine
import InventoryFeature
import UIKit

public class ContentViewController: UITabBarController {
  let viewModel: AppViewModel
  private var cancellables: Set<AnyCancellable> = []

  public init(viewModel: AppViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    let oneLabel = UILabel()
    oneLabel.text = "One"
    oneLabel.sizeToFit()

    let one = UIViewController()
    one.tabBarItem.title = "One"
    one.view.addSubview(oneLabel)
    oneLabel.center = one.view.center

    let inventory = UINavigationController(
      rootViewController: InventoryViewController(
        viewModel: self.viewModel.inventoryViewModel
      )
    )
    inventory.tabBarItem.title = "Inventory"

    let threeLabel = UILabel()
    threeLabel.text = "Three"
    threeLabel.sizeToFit()

    let three = UIViewController()
    three.tabBarItem.title = "Three"
    three.view.addSubview(threeLabel)
    threeLabel.center = three.view.center

    self.setViewControllers([one, inventory, three], animated: false)

    self.viewModel.$selectedTab
      .sink { [unowned self] tab in
        switch tab {
        case .one:
          self.selectedIndex = 0
        case .inventory:
          self.selectedIndex = 1
        case .three:
          self.selectedIndex = 2
        }
      }
      .store(in: &self.cancellables)
  }

  override public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    guard let index = tabBar.items?.firstIndex(of: item)
    else { return }

    switch index {
    case 0:
      self.viewModel.selectedTab = .one
    case 1:
      self.viewModel.selectedTab = .inventory
    case 2:
      self.viewModel.selectedTab = .three
    default:
      break
    }
  }
}
