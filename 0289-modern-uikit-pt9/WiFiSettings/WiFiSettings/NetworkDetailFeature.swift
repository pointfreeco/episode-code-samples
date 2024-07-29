import Observation
import UIKit
import UIKitNavigation

@MainActor
@Perceptible
class NetworkDetailModel {
  var forgetAlertIsPresented = false
  let onConfirmForget: () -> Void
  let network: Network

  init(
    forgetAlertIsPresented: Bool = false,
    network: Network,
    onConfirmForget: @escaping () -> Void = {}
  ) {
    self.forgetAlertIsPresented = forgetAlertIsPresented
    self.onConfirmForget = onConfirmForget
    self.network = network
  }

  func forgetNetworkButtonTapped() {
    forgetAlertIsPresented = true
  }

  func confirmForgetNetworkButtonTapped() {
    onConfirmForget()
  }
}

final class NetworkDetailViewController: UIViewController {
  @UIBindable var model: NetworkDetailModel

  init(model: NetworkDetailModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationItem.title = model.network.name

    let forgetButton = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
      guard let self else { return }
      model.forgetNetworkButtonTapped()
    })
    forgetButton.setTitle("Forget network", for: .normal)
    forgetButton.setTitleColor(.red, for: .normal)
    forgetButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(forgetButton)
    NSLayoutConstraint.activate([
      forgetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      forgetButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])

    // present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>)

    present(isPresented: $model.forgetAlertIsPresented) { [model] in
      let controller = UIAlertController(
        title: "Forget Wi-Fi Network “\(model.network.name)”?",
        message: """
          Your devices using iCloud Keychain will no longer join this Wi-Fi \
          network.
          """,
        preferredStyle: .alert
      )
      controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
      controller.addAction(UIAlertAction(title: "Forget", style: .destructive, handler: { _ in
        model.confirmForgetNetworkButtonTapped()
      }))
      return controller
    }
  }
}

import SwiftUI
#Preview {
  UIViewControllerRepresenting {
    UINavigationController(
      rootViewController: NetworkDetailViewController(
        model: NetworkDetailModel(
          forgetAlertIsPresented: true,
          network: Network(name: "Blob's WiFi"),
          onConfirmForget: { }
        )
      )
    )
  }
}
