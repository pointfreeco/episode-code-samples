import Combine
import SwiftUI

@MainActor
class LegacyConnectToNetworkModel {
  @Published var incorrectPasswordAlertIsPresented = false
  @Published var isConnecting = false
  @Published var onConnect: (Network) -> Void
  let network: Network
  @Published var password = ""

  init(network: Network, onConnect: @escaping (Network) -> Void) {
    self.onConnect = onConnect
    self.network = network
  }

  func joinButtonTapped() async {
    isConnecting = true
    defer { isConnecting = false }
    try? await Task.sleep(for: .seconds(1))
    if password == "blob" {
      onConnect(network)
    } else {
      incorrectPasswordAlertIsPresented = true
    }
  }
}

final class LegacyConnectToNetworkViewController: UIViewController {
  let model: LegacyConnectToNetworkModel
  var cancellables: Set<AnyCancellable> = []

  init(model: LegacyConnectToNetworkModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationItem.title = "Enter the password for “\(model.network.name)”"

    let passwordTextField = UITextField()
    passwordTextField.borderStyle = .line
    passwordTextField.isSecureTextEntry = true
    passwordTextField.becomeFirstResponder()
    let joinButton = UIButton(type: .system, primaryAction: UIAction { _ in
      Task {
        await self.model.joinButtonTapped()
      }
    })
    passwordTextField.addAction(
      UIAction { [weak self, weak passwordTextField] action in
        self?.model.password = passwordTextField?.text ?? ""
      },
      for: .editingChanged
    )

    joinButton.setTitle("Join network", for: .normal)
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.startAnimating()

    let stack = UIStackView(arrangedSubviews: [
      passwordTextField,
      joinButton,
      activityIndicator,
    ])
    stack.axis = .vertical
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stack.widthAnchor.constraint(equalToConstant: 200)
    ])

    model.$isConnecting.map(!)
      .assign(to: \.isEnabled, on: passwordTextField)
      .store(in: &cancellables)

    model.$isConnecting.map(!)
      .assign(to: \.isEnabled, on: joinButton)
      .store(in: &cancellables)

    model.$isConnecting.map(!)
      .assign(to: \.isHidden, on: activityIndicator)
      .store(in: &cancellables)

    model.$password.map(Optional.init)
      .assign(to: \.text, on: passwordTextField)
      .store(in: &cancellables)

    var alert: UIAlertController?
    model.$incorrectPasswordAlertIsPresented
      .removeDuplicates()
      .sink { [weak self] isPresented in
        guard let self else { return }

        if isPresented {
          alert = UIAlertController(
            title: "Incorrect password for “\(model.network.name)”",
            message: nil,
            preferredStyle: .alert
          )
          alert!.addAction(
            UIAlertAction(
              title: "OK",
              style: .default,
              handler: { [weak self] _ in
                guard let self else { return }
                model.incorrectPasswordAlertIsPresented = false
              })
          )
          present(alert!, animated: true)
        } else {
          alert?.dismiss(animated: true)
          alert = nil
        }
      }
      .store(in: &cancellables)
  }
}


import UIKitNavigation
#Preview {
  UIViewControllerRepresenting {
    UINavigationController(
      rootViewController: LegacyConnectToNetworkViewController(
        model: LegacyConnectToNetworkModel(
          network: Network(name: "Blob's WiFi"),
          onConnect: { _ in }
        )
      )
    )
  }
}
