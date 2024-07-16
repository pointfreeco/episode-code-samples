import Perception
@preconcurrency import SwiftUI
import SwiftUINavigation

@MainActor
@Perceptible
class CounterModel {
  var count = 0
  var fact: Fact?
  var secondaryFact: Fact?
  var factIsLoading = false
  struct Fact: Identifiable {
    var value: String
    var id: String { value }
  }
  func incrementButtonTapped() {
    count += 1
    fact = nil
  }
  func decrementButtonTapped() {
    count -= 1
    fact = nil
  }
  func factButtonTapped() async {
    withUIAnimation {
      self.fact = nil
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
      self.fact = Fact(value: loadedFact)
      try? await Task.sleep(for: .seconds(2))
      self.secondaryFact = Fact(
        value: try await String(
          decoding: URLSession.shared
            .data(
              from: URL(string: "http://www.numberapi.com/\(count)")!
            ).0,
          as: UTF8.self
        )
      )
    } catch {
      // TODO: error handling
    }
//    try? await Task.sleep(for: .seconds(1))
//    count += 1
//    try? await Task.sleep(for: .seconds(2))
//    fact = nil
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
      .sheet(item: $model.fact) { fact in
        Text(fact.value)
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
  CounterView(model: CounterModel())
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

    observe { [weak self] in
      guard let self else { return }
      countLabel.text = "\(model.count)"

      activityIndicator.isHidden = !model.factIsLoading
      decrementButton.isEnabled = !model.factIsLoading
      incrementButton.isEnabled = !model.factIsLoading
      factButton.isEnabled = !model.factIsLoading
    }

    navigationController?.pushViewController(item: self.$model.fact) { fact in
      FactViewController(fact: fact.value)
    }

    navigationController?.pushViewController(item: self.$model.secondaryFact) { fact in
      FactViewController(fact: fact.value)
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
