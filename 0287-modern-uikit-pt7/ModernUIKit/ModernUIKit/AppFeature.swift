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
      RootViewController(path: $model.path)
    } destination: { path in
      switch path {
      case let .counter(model):
        CounterViewController(model: model)
      case let .settings(model):
        SettingsViewController(model: model)
      }
    }
  }
}

final class RootViewController: UIViewController {
  @UIBinding var path: [AppModel.Path]

  init(path: UIBinding<[AppModel.Path]>) {
    self._path = path
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let counterButton = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
      self?.path.append(.counter(CounterModel()))
    })
    counterButton.setTitle("Counter", for: .normal)
    let settingsButton = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
      self?.path.append(.settings(SettingsModel()))
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
