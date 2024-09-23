import Perception
import SwiftUI
import SwiftUINavigation

@MainActor
@Perceptible
class SettingsModel: HashableObject {
  var isOn = false
}

struct SettingsView: View {
  @Perception.Bindable var model: SettingsModel

  var body: some View {
    WithPerceptionTracking {
      Form {
        Toggle(isOn: $model.isOn) {
          Text("Is on?")
        }
      }
    }
  }
}

class SettingsViewController: UIViewController {
  let model: SettingsModel

  init(model: SettingsModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    let isOnSwitch = UISwitch()
    isOnSwitch.addAction(
      UIAction { [weak model = self.model, weak isOnSwitch] _ in
        guard let model, let isOnSwitch
        else { return }
        model.isOn = isOnSwitch.isOn
      },
      for: .valueChanged
    )
    isOnSwitch.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(isOnSwitch)

    NSLayoutConstraint.activate([
      isOnSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      isOnSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])

    observe { [weak self] in
      guard let self else { return }
      isOnSwitch.setOn(model.isOn, animated: true)
    }
  }
}

#Preview("SwiftUI") {
  SettingsView(model: SettingsModel())
}

import UIKitNavigation

#Preview("UIKit") {
  UIViewControllerRepresenting {
    SettingsViewController(model: SettingsModel())
  }
}
