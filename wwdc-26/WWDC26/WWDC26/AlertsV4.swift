import SwiftUI
import UIKit
import UIKitNavigation

@Observable
final class AlertsV4Model {
  @CaseBindable
  enum Action: Identifiable {
    var id: some Hashable { Self.allCasePaths[self] }
    case delete(confirmation: String)
    case archive
  }

  var alertAction: Action?
  var count = 0
  var status: String?
  func deleteButtonTapped() {
    alertAction = .delete(confirmation: "")
  }
  func archiveButtonTapped() {
    alertAction = .archive
  }
  func confirmDeleteButtonTapped() {
    withUIKitAnimation {
      switch alertAction {
      case .delete(let confirmation):
        status = confirmation == "pointfreeco" ? "✅ Deleted" : "🛑 Confirmation failed"
      case .archive, .none:
        break
      }
    }
  }
  func confirmArchiveButtonTapped() {
    status = nil
  }
  func decrementButtonTapped() {
    count -= 1
  }
  func incrementButtonTapped() {
    withUITransaction(\.animateCount, true) {
      count += 1
    }
  }
}

final class AlertsV4ViewController: UIViewController {
  @UIBindable var model = AlertsV4Model()

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
          model.deleteButtonTapped()
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
          model.archiveButtonTapped()
        },
        for: .touchUpInside
      )
      return button
    }()

    let countLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 24, weight: .semibold)
      label.textAlignment = .center
      return label
    }()
    let decrementButton: UIButton = {
      var configuration = UIButton.Configuration.filled()
      configuration.title = "-"
      configuration.cornerStyle = .large

      let button = UIButton(configuration: configuration)
      button.addAction(
        UIAction { [unowned self] _ in
//          withUITransaction(\.animateCount, true) {
          model.decrementButtonTapped()
//          }
        },
        for: .touchUpInside
      )
      return button
    }()
    let incrementButton: UIButton = {
      var configuration = UIButton.Configuration.filled()
      configuration.title = "+"
      configuration.cornerStyle = .large

      let button = UIButton(configuration: configuration)
      button.addAction(
        UIAction { [unowned self] _ in
          model.incrementButtonTapped()
        },
        for: .touchUpInside
      )
      return button
    }()
    let countButtonsStackView = UIStackView(
      arrangedSubviews: [
        decrementButton,
        incrementButton,
      ]
    )
    countButtonsStackView.axis = .horizontal
    countButtonsStackView.spacing = 16
    countButtonsStackView.distribution = .fillEqually

    self.title = "Alerts V4"
    view.backgroundColor = .systemBackground

    let stackView = UIStackView(arrangedSubviews: [
      countLabel,
      countButtonsStackView,
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

    observe { [unowned self] transaction in
      if transaction.animateCount {
        UIView.transition(with: countLabel, duration: 0.2, options: .transitionCrossDissolve) {
          countLabel.text = "\(model.count)"
        }
      } else {
        countLabel.text = "\(model.count)"
      }
      statusLabel.text = model.status
      statusLabel.alpha = model.status == nil ? 0 : 1
      statusLabel.isHidden = model.status == nil ? true : false
    }

    present(item: $model.alertAction) { [unowned self] $action in
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
            model.confirmDeleteButtonTapped()
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
            model.confirmArchiveButtonTapped()
          }
        )
      }
      return controller
    }
  }
}

extension UITransaction {
  @UITransactionEntry var animateCount = false
}

#Preview {
  UINavigationController(rootViewController: AlertsV4ViewController())
}
