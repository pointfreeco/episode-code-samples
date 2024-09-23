import Counter
import UIKit
import UIKitNavigation
import SwiftUI

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

    let counter = UIStepper(frame: .zero, value: $model.count.toDouble)

    let textField = UITextField(frame: .zero, text: $model.text)
    textField.bind(focus: $model.isTextFocused)
    textField.placeholder = "Some text"
    textField.borderStyle = .bezel

    let factLabel = UILabel()
    factLabel.numberOfLines = 0
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.startAnimating()
    let factButton = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
      guard let self else { return }
      Task { await self.model.factButtonTapped() }
    })
    factButton.setTitle("Get fact", for: .normal)
    let resetButton = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
      guard let self else { return }
      model.count = 0
    })
    resetButton.setTitle("Reset", for: .normal)

    let toggleTimerButton = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
      guard let self else { return }
      model.toggleTimerButtonTapped()
    })

    let counterStack = UIStackView(arrangedSubviews: [
      countLabel,
      counter,
      resetButton,
      textField,
      factLabel,
      activityIndicator,
      factButton,
      toggleTimerButton,
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
      counter.isEnabled = !model.factIsLoading
      factButton.isEnabled = !model.factIsLoading

      toggleTimerButton.setTitle(model.isTimerRunning ? "Stop timer" : "Start timer", for: .normal)
    }

    present(item: $model.alert) { alert in
      UIAlertController(state: alert)
    }
  }
}

extension Int {
  fileprivate var toDouble: Double {
    get {
      Double(self)
    }
    set {
      self = Int(newValue)
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
