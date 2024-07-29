import Perception
@preconcurrency import SwiftUI
import SwiftUINavigation

@MainActor
@Perceptible
class CounterModel: HashableObject {
  @CasePathable
  enum Destination {
    case fact(Fact)
    case settings(SettingsModel)
  }

  init(count: Int = 0, destination: Destination? = nil, factIsLoading: Bool = false) {
    self.count = count
    self.destination = destination
    self.factIsLoading = factIsLoading
  }

  var count = 0
  var destination: Destination?
  var factIsLoading = false
  struct Fact: Identifiable {
    var value: String
    var id: String { value }
  }
  func incrementButtonTapped() {
    count += 1
    destination = nil
  }
  func decrementButtonTapped() {
    count -= 1
    destination = nil
  }
  func factButtonTapped() async {
    withUIAnimation {
      self.destination = nil
    }
    self.factIsLoading = true
    defer { self.factIsLoading = false }

    do {
      try await Task.sleep(for: .seconds(1))
      let loadedFact = try await String(
        decoding: URLSession.shared
          .data(
            from: URL(string: "http://www.numberapi.com/\(count)")!
          ).0,
        as: UTF8.self
      )
      destination = nil
      try await Task.sleep(for: .seconds(0.1))
      self.destination = .fact(Fact(value: loadedFact))
    } catch {
      // TODO: error handling
    }
//    try? await Task.sleep(for: .seconds(1))
//    count += 1
//    try? await Task.sleep(for: .seconds(2))
//    fact = nil
  }
  func settingsButtonTapped() {
    destination = .settings(SettingsModel())
  }
}

struct CounterView: View {
  @Perception.Bindable var model: CounterModel
  var body: some View {
    WithPerceptionTracking {
      Form {
        Text("\(model.count)")
        Button("Decrement") { model.decrementButtonTapped() }
        Button("Increment") { model.incrementButtonTapped() }

        if model.factIsLoading {
          ProgressView().id(UUID())
        }

        Button("Get fact") {
          Task {
            await model.factButtonTapped()
          }
        }
      }
      .disabled(model.factIsLoading)
      .sheet(item: ($model.destination as Binding<CounterModel.Destination?>).fact) { fact in
        Text(fact.value)
      }
      .navigationDestination(item: $model.destination.settings) { model in
        SettingsView(model: model)
      }
      .toolbar {
        ToolbarItem {
          Button("Settings") {
            model.settingsButtonTapped()
          }
        }
      }
//      .alert(item: $model.fact) { _ in
//        Text(model.count.description)
//      } actions: { _ in
//      } message: { fact in
//        Text(fact)
//      }
    }
  }
}

#Preview("SwiftUI") {
  NavigationStack {
    CounterView(model: CounterModel())
  }
}

final class CounterViewController: UIViewController {
  @UIBindable var model: CounterModel

  init(model: CounterModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    let countLabel = UILabel()
    countLabel.textAlignment = .center
    let decrementButton = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
      self?.model.decrementButtonTapped()
    })
    decrementButton.setTitle("Decrement", for: .normal)
    let incrementButton = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
      self?.model.incrementButtonTapped()
    })
    incrementButton.setTitle("Increment", for: .normal)

    let factLabel = UILabel()
    factLabel.numberOfLines = 0
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.startAnimating()
    let factButton = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
      guard let self else { return }
      Task { await self.model.factButtonTapped() }
    })
    factButton.setTitle("Get fact", for: .normal)

    let counterStack = UIStackView(arrangedSubviews: [
      countLabel,
      decrementButton,
      incrementButton,
      factLabel,
      activityIndicator,
      factButton,
    ])
    counterStack.axis = .vertical
    counterStack.spacing = 12
    counterStack.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(counterStack)
    NSLayoutConstraint.activate([
      counterStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      counterStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      counterStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      counterStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", primaryAction: UIAction { [weak self] _ in
      self?.model.settingsButtonTapped()
    })

    observe { [weak self] in
      guard let self else { return }
      countLabel.text = "\(model.count)"

      activityIndicator.isHidden = !model.factIsLoading
      decrementButton.isEnabled = !model.factIsLoading
      incrementButton.isEnabled = !model.factIsLoading
      factButton.isEnabled = !model.factIsLoading
    }

    present(item: $model.destination.fact) { fact in
      FactViewController(fact: fact.value)
    }

    navigationController?.pushViewController(item: $model.destination.settings) { model in
      SettingsViewController(model: model)
    }
  }
}

class FactViewController: UIViewController {
  let fact: String
  init(fact: String) {
    self.fact = fact
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    let factLabel = UILabel()
    factLabel.text = fact
    factLabel.numberOfLines = 0
    factLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(factLabel)
    NSLayoutConstraint.activate([
      factLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      factLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      factLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      factLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])
  }
}

#Preview("UIKit") {
  UIViewControllerRepresenting {
    UINavigationController(
      rootViewController: CounterViewController(model: CounterModel())
    )
  }
}

struct UIViewControllerRepresenting: UIViewControllerRepresentable {
  let base: UIViewController
  init(base: () -> UIViewController) {
    self.base = base()
  }

  func makeUIViewController(context: Context) -> some UIViewController {
    return base
  }
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
}
