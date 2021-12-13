import Combine
import ItemFeature
import ItemRowFeature
import Models
import SwiftUIHelpers
import UIKit

public class InventoryViewController: UIViewController, UICollectionViewDelegate {
  let viewModel: InventoryViewModel
  private var cancellables: Set<AnyCancellable> = []

  public init(viewModel: InventoryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    // MARK: view creation

    self.title = "Inventory"
    self.navigationItem.rightBarButtonItem = .init(
      title: "Add",
      primaryAction: .init { [unowned self] _ in
        self.viewModel.addButtonTapped()
      }
    )

    enum Section { case inventory }

    let cellRegistration = UICollectionView.CellRegistration<
      ItemRowCellView,
      ItemRowViewModel
    > { [unowned self] cell, indexPath, itemRowViewModel in
      cell.bind(viewModel: itemRowViewModel, context: self)
    }
    
    var dataSource: UICollectionViewDiffableDataSource<
      Section,
      ItemRowViewModel
    >!

    var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    layoutConfig.trailingSwipeActionsConfigurationProvider = { indexPath in
      guard let viewModel = dataSource.itemIdentifier(for: indexPath)
      else { return nil }
      let duplicate = UIContextualAction(
        style: .normal,
        title: "Duplicate"
      ) { _, _, completion in
        viewModel.duplicateButtonTapped()
        completion(true)
      }
      let delete = UIContextualAction(
        style: .destructive,
        title: "Delete"
      ) { _, _, completion in
        viewModel.deleteButtonTapped()
        completion(true)
      }
      return UISwipeActionsConfiguration(actions: [duplicate, delete])
    }

    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewCompositionalLayout.list(using: layoutConfig)
    )
    collectionView.delegate = self
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    dataSource = UICollectionViewDiffableDataSource<
      Section,
      ItemRowViewModel
    >(
      collectionView: collectionView
    ) { collectionView, indexPath, itemRowViewModel in

      let cell = collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: itemRowViewModel
      )
      cell.accessories = [.disclosureIndicator()]
      return cell
    }

    collectionView.dataSource = dataSource

    self.view.addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
    ])

    // MARK: view model bindings

    var presentedViewController: UIViewController?

    self.viewModel.$route
      .removeDuplicates()
      .sink { [unowned self] route in
        switch route {
        case .none:
          presentedViewController?.dismiss(animated: true)
          break

        case let .add(itemViewModel):
          let vc = ItemViewController(viewModel: itemViewModel)
          vc.title = "Add"
          vc.navigationItem.leftBarButtonItem = .init(
            title: "Cancel",
            primaryAction: .init { [unowned self] _ in
              self.viewModel.cancelButtonTapped()
            }
          )
          vc.navigationItem.rightBarButtonItem = .init(
            title: "Add",
            primaryAction: .init { [unowned self] _ in
              self.viewModel.add(item: itemViewModel.item)
            }
          )
          let nav = UINavigationController(rootViewController: vc)
          self.present(nav, animated: true)
          presentedViewController = nav

        case .row:
          break
        }
      }
      .store(in: &self.cancellables)

    self.viewModel.$inventory
      .sink { inventory in
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemRowViewModel>()
        snapshot.appendSections([.inventory])
        snapshot.appendItems(inventory.elements, toSection: .inventory)
        dataSource.apply(snapshot, animatingDifferences: true)
      }
      .store(in: &self.cancellables)

    // MARK: UI actions
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.viewModel.inventory[indexPath.row].setEditNavigation(isActive: true)
  }
}

import SwiftUI

struct InventoryViewController_Previews: PreviewProvider {
  static var previews: some View {
    ToSwiftUI {
      UINavigationController(
        rootViewController: InventoryViewController(
          viewModel: .init(
            inventory: [
              .init(
                item: .init(
                  name: "Keyboard",
                  color: .red,
                  status: .inStock(quantity: 100)
                )
              ),
              .init(
                item: .init(
                  name: "Mouse",
                  color: .red,
                  status: .inStock(quantity: 10)
                )
              )
            ],
            route: nil
          )
        )
      )
    }
  }
}
