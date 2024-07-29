import UIKitNavigation

@Perceptible
@MainActor
class ConnectToNetworkModel {
  var incorrectPasswordAlertIsPresented = false
  var isConnecting = false
  var onConnect: (Network) -> Void
  let network: Network
  var password = ""
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

final class ConnectToNetworkViewController: UIViewController {
  @UIBindable var model: ConnectToNetworkModel

  init(model: ConnectToNetworkModel) {
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

    let passwordTextField = UITextField(text: $model.password)
    passwordTextField.borderStyle = .line
    passwordTextField.isSecureTextEntry = true
    passwordTextField.becomeFirstResponder()
    let joinButton = UIButton(type: .system, primaryAction: UIAction { _ in
      Task {
        await self.model.joinButtonTapped()
      }
    })
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

    _perceive { [weak self] in
      guard let self else { return }
      passwordTextField.isEnabled = !model.isConnecting
      joinButton.isEnabled = !model.isConnecting
      activityIndicator.isHidden = !model.isConnecting
    }

    present(isPresented: $model.incorrectPasswordAlertIsPresented) { [unowned self] in
      let controller = UIAlertController(
        title: "Incorrect password for “\(model.network.name)”",
        message: nil,
        preferredStyle: .alert
      )
      controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
      return controller
    }
  }
}

#Preview {
  UIViewControllerRepresenting {
    UINavigationController(
      rootViewController: ConnectToNetworkViewController(
        model: ConnectToNetworkModel(
          network: Network(name: "Blob's WiFi"),
          onConnect: { _ in }
        )
      )
    )
  }
}
