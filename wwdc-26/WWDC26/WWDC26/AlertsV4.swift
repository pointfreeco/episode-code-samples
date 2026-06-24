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

  var alertAction: Action?
  var status: String?

  let statusLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    return label
  }()
  @ObservationIgnored
  var observationToken: ObservationTracking.Token?

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
      statusLabel,
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

    observe { [unowned self] in
      statusLabel.text = status
      statusLabel.alpha = status == nil ? 0 : 1
      statusLabel.isHidden = status == nil ? true : false
    }

    @UIBindable var `self` = self

    present(item: $self.alertAction) { [unowned self] $action in
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
          UIAlertAction(title: "Confirm", style: .destructive) { [unowned self] _ in
            withUIKitAnimation {
              self.status = $confirmation.wrappedValue == "pointfreeco" ? "✅ Deleted" : "🛑 Confirmation failed"
            }
          }
        )
        controller.addTextField { textField in
          textField.autocapitalizationType = .none
          textField.placeholder = "pointfreeco"
          textField.bind(text: $confirmation)
        }
      case .archive:
        controller.addAction(
          UIAlertAction(title: "Confirm", style: .default) { [unowned self] _ in
            self.status = nil
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
