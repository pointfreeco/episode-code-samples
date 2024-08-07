import IdentifiedCollections
import UIKitNavigation

extension UICollectionView {
  @available(iOS 14, *)
  public convenience init<Cell: UICollectionViewCell, ID: Hashable & Sendable, Item>(
    frame: CGRect = .zero,
    collectionViewLayout: UICollectionViewLayout = UICollectionViewLayout(),
    data: UIBinding<IdentifiedArray<ID, Item>>,
    content: @escaping (Cell, IndexPath, UIBinding<Item>) -> Void
  ) {
    self.init(frame: frame, collectionViewLayout: collectionViewLayout)

    let cellRegistration = UICollectionView.CellRegistration<
      Cell, UIBinding<Item>
    > { cell, indexPath, item in
      _perceive { // TODO: Should this `perceive` be here?
        content(cell, indexPath, item)
      }
    }

    let dataSource = UICollectionViewDiffableDataSource<
      Section, UIBinding<Item>
    >(collectionView: self) { collectionView, indexPath, item in
      MainActor.assumeIsolated {
        collectionView.dequeueConfiguredReusableCell(
          using: cellRegistration, for: indexPath, item: item
        )
      }
    }

    _perceive {
      var snapshot = NSDiffableDataSourceSnapshot<Section, UIBinding<Item>>()
      snapshot.appendSections([.main])
      snapshot.appendItems(
        data.wrappedValue.ids.map { UIBinding(data[id: $0])! }
      )
      dataSource.apply(snapshot, animatingDifferences: true)
    }
  }
}

private enum Section { case main }

// ...

import SwiftUI

@Perceptible
final class CollectionModel: Hashable {
  struct Item: Identifiable, Comparable {
    let id = UUID()
    var count = 0
    static func < (lhs: Self, rhs: Self) -> Bool {
      lhs.count < rhs.count
    }
  }
  var items: IdentifiedArrayOf<Item> = [
    Item(count: 1),
    Item(count: 2),
    Item(count: 3)
  ]

  nonisolated func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
  }
  nonisolated static func == (lhs: CollectionModel, rhs: CollectionModel) -> Bool {
    lhs === rhs
  }
}

final class CollectionViewController: UIViewController {
  @UIBindable var model: CollectionModel

  init(model: CollectionModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let collectionView = UICollectionView(
      frame: view.bounds,
      collectionViewLayout: UICollectionViewCompositionalLayout.list(
        using: UICollectionLayoutListConfiguration(appearance: .insetGrouped)
      ),
      data: $model.items
    ) { (cell: UICollectionViewListCell, indexPath, $item) in
      var content = cell.defaultContentConfiguration()
      content.text = "\(item.count)"
      cell.contentConfiguration = content
    }
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(collectionView)

    // collectionView.delegate = self

    Task { [weak self] in
      while true {
        guard let self else { return }
        try await Task.sleep(for: .seconds(1))
        for position in model.items.indices {
          model.items[position].count += .random() ? 1 : -1
        }
        model.items.sort()
        print(model.items)
      }
    }
  }
}
