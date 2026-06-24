import SwiftUI
import UIKit
import UIKitNavigation

@Observable
final class AlertsV4ViewController: UIViewController {
  @CaseBindable
  enum Action: Identifiable {
    var id: some Hashable { Self.allCasePaths[self] }
    case delete(confirmation: String)
    case archive
  }

  var alertAction: Action? {
    didSet {
      print("didSet", alertAction)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let deleteButton: UIButton = {
      var configuration = UIButton.Configuration.filled()
      configuration.title = "Delete"
      configuration.baseBackgroundColor = .systemRed
      configuration.cornerStyle = .large

      let button = UIButton(configuration: configuration)
      button.addAction(
        UIAction { [unowned self] _ in
          alertAction = .delete(confirmation: "")
        },
        for: .touchUpInside
      )
      return button
    }()
    let archiveButton: UIButton = {
      var configuration = UIButton.Configuration.filled()
      configuration.title = "Archive"
      configuration.cornerStyle = .large

      let button = UIButton(configuration: configuration)
      button.addAction(
        UIAction { [unowned self] _ in
          alertAction = .archive
        },
        for: .touchUpInside
      )
      return button
    }()

    self.title = "Alerts V4"
    view.backgroundColor = .systemBackground

    let stackView = UIStackView(arrangedSubviews: [
      deleteButton,
      archiveButton,
    ])
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.leadingAnchor.constraint(
        greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor
      ),
      view.layoutMarginsGuide.trailingAnchor.constraint(
        greaterThanOrEqualTo: stackView.trailingAnchor
      ),
    ])

    @UIBindable var `self` = self

    //    @Environment(Library.self) var library
    //    @Bindable var library = library

    present(item: $self.alertAction) { $action in
      let controller = UIAlertController(
        title: {
          switch action {
          case .delete: "Delete"
          case .archive: "Archive"
          }
        }(),
        message: {
          switch action {
          case .delete: "Do you want to delete?"
          case .archive: "Do you want to archive?"
          }
        }(),
        preferredStyle: .alert
      )
      controller.addAction(
        UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
      )
      switch $action.cases {
      case .delete(let $confirmation):
        controller.addAction(
          UIAlertAction(title: "Confirm", style: .destructive) { _ in
            print($confirmation.wrappedValue == "pointfreeco" ? "✅" : "🛑")
          }
        )
        controller.addTextField { textField in
          textField.autocapitalizationType = .none
          textField.placeholder = "pointfreeco"
          textField.bind(text: $confirmation)
        }
      case .archive:
        controller.addAction(
          UIAlertAction(title: "Confirm", style: .default) { _ in

          }
        )
      }
      return controller
    }
  }
}

#Preview {
  UINavigationController(rootViewController: AlertsV4ViewController())
}
