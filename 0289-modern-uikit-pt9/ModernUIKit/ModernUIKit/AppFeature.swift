import Perception
import SwiftUI

@Perceptible
class AppModel {
  var path: [Path] 
  init(path: [Path] = []) {
    self.path = path
  }

  enum Path: Hashable {
    case counter(CounterModel)
    case settings(SettingsModel)
  }
}

struct AppView: View {
  @Perception.Bindable var model: AppModel

  var body: some View {
    WithPerceptionTracking {
      NavigationStack(path: $model.path) {
        Form {
          Button("Counter") {
            model.path.append(.counter(CounterModel()))
          }
          Button("Settings") {
            model.path.append(.settings(SettingsModel()))
          }

          NavigationLink("Counter w/ value", value: AppModel.Path.counter(CounterModel()))
        }
        .navigationDestination(for: AppModel.Path.self) { path in
          switch path {
          case let .counter(model):
            CounterView(model: model)
          case let .settings(model):
            SettingsView(model: model)
          }
        }
      }
    }
  }
}

extension NavigationStackController where Data == [AppModel.Path] {
  convenience init(model: AppModel) {
    @UIBindable var model = model
    self.init(path: $model.path) {
      RootViewController()
    } destination: { path in
      switch path {
      case let .counter(model):
        CounterViewController(model: model)
      case let .settings(model):
        SettingsViewController(model: model)
      }
    }
    if #available(iOS 17.0, *) {
      self.traitOverrides.path = $model.path
    } else {
      // Fallback on earlier versions
    }
  }
}

private enum PathTrait: UITraitDefinition {
  static var defaultValue: UIBinding<[AppModel.Path]> {
    @UIBindable var model = AppModel()
    return $model.path
  }
}

extension UITraitCollection {
  @available(iOS 17.0, *)
  var path: UIBinding<[AppModel.Path]> {
    self[PathTrait.self]
  }
}

@available(iOS 17.0, *)
extension UIMutableTraits {
  fileprivate(set) var path: UIBinding<[AppModel.Path]> {
    get { self[PathTrait.self] }
    set { self[PathTrait.self] = newValue }
  }
}

final class RootViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let counterButton = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
      self?.navigationController?.push(value: AppModel.Path.counter(CounterModel()))
    })
    counterButton.setTitle("Counter", for: .normal)
    let settingsButton = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
      self?.navigationController?.push(value: AppModel.Path.settings(SettingsModel()))
    })
    settingsButton.setTitle("Settings", for: .normal)
    let stack = UIStackView(arrangedSubviews: [
      counterButton,
      settingsButton,
    ])
    stack.axis = .vertical
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)

    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
}
