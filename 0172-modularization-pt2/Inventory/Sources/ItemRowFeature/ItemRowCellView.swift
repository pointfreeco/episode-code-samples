import Combine
import ItemFeature
import UIKit

public class ItemRowCellView: UICollectionViewListCell {
  var cancellables: Set<AnyCancellable> = []
  
  override public func prepareForReuse() {
    super.prepareForReuse()
    self.cancellables = []
  }
  
  public func bind(viewModel: ItemRowViewModel, context: UIViewController) {
    viewModel.$item
      .map(\.name)
      .removeDuplicates()
      .sink { [unowned self] name in
        var content = self.defaultContentConfiguration()
        content.text = name
        self.contentConfiguration = content
      }
      .store(in: &self.cancellables)
    
    var presentedViewController: UIViewController?
    
    viewModel.$route
      .removeDuplicates()
      .sink { [unowned self] route in
        switch route {
        case .none:
          guard let vc = presentedViewController
          else { return }
          vc.dismiss(animated: true)
          context.navigationController?.popToViewController(vc, animated: true)
          context.navigationController?.popViewController(animated: true)
          presentedViewController = nil
          
        case .deleteAlert:
          let alert = UIAlertController(
            title: viewModel.item.name,
            message: "Are you sure you want to delete this item?",
            preferredStyle: .alert
          )
          alert.addAction(.init(title: "Cancel", style: .cancel, handler: { _ in
            viewModel.cancelButtonTapped()
          }))
          alert.addAction(.init(title: "Delete", style: .destructive, handler: { _ in
            viewModel.deleteConfirmationButtonTapped()
          }))
          context.present(alert, animated: true)
          presentedViewController = alert

        case let .duplicate(itemViewModel):
          let vc = ItemViewController(viewModel: itemViewModel)
          vc.title = "Duplicate"
          vc.navigationItem.leftBarButtonItem = .init(
            title: "Cancel",
            primaryAction: .init { _ in
              viewModel.cancelButtonTapped()
            }
          )
          vc.navigationItem.rightBarButtonItem = .init(
            title: "Add",
            primaryAction: .init { _ in
              viewModel.duplicate(item: itemViewModel.item)
            }
          )
          let nav = UINavigationController(rootViewController: vc)
          nav.modalPresentationStyle = .popover
          nav.popoverPresentationController?.sourceView = self
          context.present(nav, animated: true)
          presentedViewController = nav

        case let .edit(itemViewModel):
          let vc = ItemViewController(viewModel: itemViewModel)
          vc.title = "Edit"
          vc.navigationItem.leftBarButtonItem = .init(
            title: "Cancel",
            primaryAction: .init { _ in
              viewModel.cancelButtonTapped()
            }
          )
          vc.navigationItem.rightBarButtonItem = .init(
            title: "Save",
            primaryAction: .init { _ in
              viewModel.edit(item: itemViewModel.item)
            }
          )
          context.show(vc, sender: nil)
          presentedViewController = vc
        }
      }
      .store(in: &self.cancellables)
  }
}
