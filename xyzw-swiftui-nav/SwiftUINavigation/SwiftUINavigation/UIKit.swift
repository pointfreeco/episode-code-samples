import CasePaths
import Combine
import UIKit
import SwiftUI

extension Item.Color {
  static let all: [Self?] = [nil] + Self.defaults
}

class ItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  let viewModel: ItemViewModel

  private var cancellables: Set<AnyCancellable> = []

  init(viewModel: ItemViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // MARK: Layout

    self.view.backgroundColor = .white

    let nameTextField = UITextField()
    nameTextField.placeholder = "Name"
    nameTextField.borderStyle = .roundedRect

    let colorPicker = UIPickerView()
    colorPicker.dataSource = self
    colorPicker.delegate = self

    let quantityLabel = UILabel()

    let quantityStepper = UIStepper()
    quantityStepper.maximumValue = .infinity

    let quantityStackView = UIStackView(arrangedSubviews: [quantityLabel, quantityStepper])

    let markAsSoldOutButton = UIButton()
    markAsSoldOutButton.setTitle("Mark as sold out", for: .normal)

    let inStockStackView = UIStackView(arrangedSubviews: [
      quantityStackView,
      markAsSoldOutButton,
    ])
    inStockStackView.axis = .vertical

    let isOnBackOrderLabel = UILabel()
    isOnBackOrderLabel.text = "Is on back order?"

    let isOnBackOrderSwitch = UISwitch()

    let isOnBackOrderStackView = UIStackView(arrangedSubviews: [
      isOnBackOrderLabel,
      isOnBackOrderSwitch,
    ])

    let isBackInStockButton = UIButton()
    isBackInStockButton.setTitle("Is back in stock!", for: .normal)

    let outOfStockStackView = UIStackView(arrangedSubviews: [
      isOnBackOrderStackView,
      isBackInStockButton,
    ])
    outOfStockStackView.axis = .vertical

    let statusStackView = UIStackView(arrangedSubviews: [
      inStockStackView,
      outOfStockStackView,
    ])
    statusStackView.axis = .vertical

    let stackView = UIStackView(arrangedSubviews: [
      nameTextField,
      colorPicker,
      statusStackView,
    ])
    stackView.axis = .vertical
    stackView.spacing = UIStackView.spacingUseSystem
    stackView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: self.view.readableContentGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor),
    ])

    // MARK: View Model Bindings

    self.viewModel.$item
      .map(\.name)
      .removeDuplicates()
      .sink { name in nameTextField.text = name }
      .store(in: &self.cancellables)

    nameTextField.addAction(
      .init(handler: { [weak self] action in
        self?.viewModel.item.name = (action.sender as? UITextField)?.text ?? ""
      }),
      for: .editingChanged
    )

    self.viewModel.$item
      .map(\.color)
      .removeDuplicates()
      .compactMap { color in color.flatMap(Item.Color.all.firstIndex(of:)) }
      .sink { row in colorPicker.selectRow(row, inComponent: 0, animated: false ) }
      .store(in: &self.cancellables)

    self.viewModel.$item
//      .map(\.status)
//      .map(/Item.Status.inStock)
//      .map { $0 == nil }
      .map { !(/Item.Status.inStock ~= $0.status) }
      .removeDuplicates()
      .sink { isHidden in inStockStackView.isHidden = isHidden }
      .store(in: &self.cancellables)

    self.viewModel.$item
      .map(\.status)
      .compactMap(/Item.Status.inStock)
      .removeDuplicates()
      .sink { quantity in
        quantityLabel.text = "Quantity: \(quantity)"
        quantityStepper.value = Double(quantity)
      }
      .store(in: &self.cancellables)

    quantityStepper.addAction(
      .init { _ in
        self.viewModel.item.status = .inStock(quantity: Int(quantityStepper.value))
      },
      for: .valueChanged
    )

    markAsSoldOutButton.addAction(
      .init { [weak self] _ in
        self?.viewModel.item.status = .outOfStock(isOnBackOrder: false)
      },
      for: .touchUpInside
    )

    self.viewModel.$item
      .map(\.status)
      .map(/Item.Status.outOfStock)
      .map { $0 == nil }
      .removeDuplicates()
      .sink { isHidden in outOfStockStackView.isHidden = isHidden }
      .store(in: &self.cancellables)

    self.viewModel.$item
      .map(\.status)
      .compactMap(/Item.Status.outOfStock)
      .removeDuplicates()
      .sink { isOnBackOrder in isOnBackOrderSwitch.isOn = isOnBackOrder }
      .store(in: &self.cancellables)

    isOnBackOrderSwitch.addAction(
      .init(handler: { [weak self, weak isOnBackOrderSwitch] action in
        guard let self = self, let isOnBackOrder = isOnBackOrderSwitch?.isOn
        else { return }

        self.viewModel.item.status = .outOfStock(isOnBackOrder: isOnBackOrder)
      }),
      for: .valueChanged
    )

    isBackInStockButton.addAction(
      .init { [weak self] _ in
        self?.viewModel.item.status = .inStock(quantity: 1)
      },
      for: .touchUpInside
    )
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    Item.Color.all.count
  }

  func pickerView(
    _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int
  ) -> String? {
    Item.Color.all[row]?.name ?? "None"
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.viewModel.item.color = Item.Color.all[row]
  }
}

extension ItemRowViewModel: Hashable {
  static func == (lhs: ItemRowViewModel, rhs: ItemRowViewModel) -> Bool {
    lhs === rhs
  }

  func hash(into hasher: inout Hasher) {
    self.item.hash(into: &hasher)
  }
}

class InventoryViewController: UIViewController, UICollectionViewDelegate {
  let viewModel: InventoryViewModel

  private var cancellables: Set<AnyCancellable> = []

  init(viewModel: InventoryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let addButton = UIBarButtonItem(title: "Add")
    self.navigationItem.rightBarButtonItem = addButton

    self.title = "Inventory"

    self.view.backgroundColor = .white

    enum Section { case inventory }
    var dataSource: UICollectionViewDiffableDataSource<Section, ItemRowViewModel>!

    var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    layoutConfig.trailingSwipeActionsConfigurationProvider = { indexPath in
      guard let viewModel = dataSource.itemIdentifier(for: indexPath) else { return nil }

      let duplicate = UIContextualAction(style: .normal, title: "Duplicate") { _, _, completion in
        viewModel.duplicateButtonTapped()
        completion(true)
      }
      duplicate.backgroundColor = .darkGray

      let delete = UIContextualAction(style: .normal, title: "Delete") { _, _, completion in
        viewModel.deleteButtonTapped()
        completion(true)
      }
      delete.backgroundColor = .red

      return UISwipeActionsConfiguration(actions: [delete, duplicate])
    }

    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewCompositionalLayout.list(using: layoutConfig)
    )
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    let cellRegistration = UICollectionView.CellRegistration<
      UICollectionViewListCell, ItemRowViewModel
    > { cell, indexPath, itemRowViewModel in
      var content = cell.defaultContentConfiguration()
      content.text = itemRowViewModel.item.name
      cell.contentConfiguration = content
    }
    dataSource = UICollectionViewDiffableDataSource<Section, ItemRowViewModel>(
      collectionView: collectionView
    ) { collectionView, indexPath, itemRowViewModel in
      let cell = collectionView
        .dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemRowViewModel)
      cell.accessories = [.disclosureIndicator()]
      return cell
    }
    collectionView.dataSource = dataSource
    collectionView.delegate = self

    self.view.addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
    ])

    addButton.primaryAction = .init { _ in
      self.viewModel.addButtonTapped()
    }

    self.viewModel.$inventory
      .sink { inventory in
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemRowViewModel>()
        snapshot.appendSections([.inventory])
        snapshot.appendItems(inventory.elements, toSection: .inventory)
        dataSource.apply(snapshot, animatingDifferences: true)
      }
      .store(in: &self.cancellables)

    self.viewModel.$route
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] route in
        guard let self = self else { return }

        switch route {
        case .none:
          self.presentedViewController?.dismiss(animated: true, completion: nil)
          guard
            let nav = self.navigationController,
            let index = nav.viewControllers.firstIndex(of: self)
          else { return }
          nav.setViewControllers(
            Array(nav.viewControllers[...index]),
            animated: true
          )

        case let .add(itemViewModel):
          let vc = ItemViewController(viewModel: itemViewModel)
          vc.title = "Add"
          vc.navigationItem.leftBarButtonItem = .init(
            title: "Cancel",
            primaryAction: .init { _ in
              self.viewModel.cancelButtonTapped()
            }
          )
          vc.navigationItem.rightBarButtonItem = .init(
            title: "Add",
            primaryAction: .init { _ in
              self.viewModel.add(item: itemViewModel.item)
            }
          )

          self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)

        case let .row(id, route):
          guard let itemRowViewModel = self.viewModel.inventory[id: id]
          else { return }

          switch route {
          case .deleteAlert:
            let alert = UIAlertController(
              title: itemRowViewModel.item.name,
              message: "Are you sure you want to delete this item?",
              preferredStyle: .alert
            )
            alert.addAction(.init(title: "Cancel", style: .cancel) { _ in
              itemRowViewModel.cancelButtonTapped()
            })
            alert.addAction(.init(title: "Delete", style: .destructive) { _ in
              itemRowViewModel.deleteConfirmationButtonTapped()
            })
            self.present(alert, animated: true)

          case let .duplicate(itemViewModel):
            let itemToDuplicate = ItemViewController(viewModel: itemViewModel)
            itemToDuplicate.title = "Duplicate"
            itemToDuplicate.navigationItem.leftBarButtonItem = .init(
              title: "Cancel",
              primaryAction: .init { _ in
                itemRowViewModel.cancelButtonTapped()
              }
            )
            itemToDuplicate.navigationItem.rightBarButtonItem = .init(
              title: "Add",
              primaryAction: .init { _ in
                itemRowViewModel.duplicate(item: itemViewModel.item)
              }
            )
            let vc = UINavigationController(rootViewController: itemToDuplicate)
            vc.modalPresentationStyle = .popover
            let row = self.viewModel.inventory.index(id: id)
            vc.popoverPresentationController?.sourceView = row.flatMap {
              collectionView.cellForItem(at: .init(row: $0, section: 0))
            }
            self.present(vc, animated: true)

          case let .edit(itemViewModel):
            let itemToEdit = ItemViewController(viewModel: itemViewModel)
            itemToEdit.title = "Edit"
            itemToEdit.navigationItem.leftBarButtonItem = .init(
              title: "Cancel",
              primaryAction: .init { _ in
                itemRowViewModel.cancelButtonTapped()
              }
            )
            itemToEdit.navigationItem.rightBarButtonItem = .init(
              title: "Save",
              primaryAction: .init { _ in
                itemRowViewModel.edit(item: itemViewModel.item)
                collectionView.reloadData()
              }
            )
            self.show(itemToEdit, sender: nil)
          }
        }
      }
      .store(in: &self.cancellables)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.viewModel.inventory[indexPath.row].setEditNavigation(isActive: true)
  }
}

class ContentViewController: UITabBarController {
  let viewModel: AppViewModel
  private var cancellables: Set<AnyCancellable> = []

  init(viewModel: AppViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let oneLabel = UILabel()
    oneLabel.text = "One"
    oneLabel.sizeToFit()

    let one = UIViewController()
    one.tabBarItem.title = "One"
    one.view.addSubview(oneLabel)
    oneLabel.center = one.view.center

    let inventory = UINavigationController(
      rootViewController: InventoryViewController(viewModel: self.viewModel.inventoryViewModel)
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
      .sink { [weak self] tab in
        switch tab {
        case .one:
          self?.selectedIndex = 0
        case .inventory:
          self?.selectedIndex = 1
        case .three:
          self?.selectedIndex = 2
        }
      }
      .store(in: &self.cancellables)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct UIKitContentView: UIViewControllerRepresentable {
  let viewModel: AppViewModel

  func makeUIViewController(context: Context) -> ContentViewController {
    .init(viewModel: self.viewModel)
  }

  func updateUIViewController(_ uiViewController: ContentViewController, context: Context) {}
}
