import Counter
import Epoxy
import UIKit
import UIKitNavigation

class EpoxyCounterViewController: CollectionViewController {
  @UIBindable var model: CounterModel

  init(model: CounterModel) {
    self.model = model
    super.init(
      layout: UICollectionViewCompositionalLayout.list(
        using: UICollectionLayoutListConfiguration(
          appearance: .grouped
        )
      )
    )
  }

  private enum DataID: Hashable {
    case activity
    case count
    case decrementButton
    case fact
    case factButton
    case incrementButton
    case savedFact(String)
    case savedFactsHeader
    case toggleTimerButton
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    observe { [weak self] in
      guard let self else { return }

      setItems(items, animated: false)
    }

    present(item: $model.alert) { alert in
      UIAlertController(state: alert) { [weak self] action in
        guard let action else { return }
        self?.model.handle(alertAction: action)
      }
    }
  }

  @ItemModelBuilder
  private var items: [ItemModeling] {
    Label.itemModel(
      dataID: DataID.count,
      content: "Count: \(model.count)",
      style: .style(with: .title1)
    )
    ButtonRow.itemModel(
      dataID: DataID.decrementButton,
      content: ButtonRow.Content(text: "Decrement"),
      behaviors: ButtonRow.Behaviors(
        didTap: { [weak self] in
          self?.model.decrementButtonTapped()
        }
      )
    )
    ButtonRow.itemModel(
      dataID: DataID.incrementButton,
      content: ButtonRow.Content(text: "Increment"),
      behaviors: ButtonRow.Behaviors(
        didTap: { [weak self] in
          self?.model.incrementButtonTapped()
        }
      )
    )
    ButtonRow.itemModel(
      dataID: DataID.factButton,
      content: ButtonRow.Content(text: "Get fact"),
      behaviors: ButtonRow.Behaviors(
        didTap: { [weak self] in
          Task {
            await self?.model.factButtonTapped()
          }
        }
      )
    )
//    if let fact = model.fact {
//      Label.itemModel(
//        dataID: DataID.fact,
//        content: fact.value,
//        style: .style(with: .body)
//      )
//    } else {
      ActivityIndicatorView.itemModel(
        dataID: DataID.activity,
        content: model.factIsLoading,
        style: .large
      )
//    }
    ButtonRow.itemModel(
      dataID: DataID.toggleTimerButton,
      content: ButtonRow.Content(text: model.isTimerRunning ? "Stop timer" : "Start timer"),
      behaviors: ButtonRow.Behaviors(
        didTap: { [weak self] in
          self?.model.toggleTimerButtonTapped()
        }
      )
    )
    if !model.savedFacts.isEmpty {
      Label.itemModel(
        dataID: DataID.savedFactsHeader,
        content: "Saved facts",
        style: .style(with: .title1)
      )
      for fact in model.savedFacts {
        SavedFactRow.itemModel(
          dataID: DataID.savedFact(fact),
          content: fact,
          behaviors: SavedFactRow.Behaviors(
            didTapDelete: { [weak self] in
              self?.model.deleteFactButtonTapped(fact: fact)
            }
          )
        )
      }
    }
  }
}

final class SavedFactRow: UIView, @preconcurrency EpoxyableView {
  init() {
    super.init(frame: .zero)
    setUp()
  }
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  struct Behaviors {
    var didTapDelete: (() -> Void)?
  }
  func setContent(_ content: String, animated _: Bool) {
    label.text = content
  }
  func setBehaviors(_ behaviors: Behaviors?) {
    didTapDelete = behaviors?.didTapDelete
  }
  private let stack = UIStackView()
  private let label = UILabel()
  private let button = UIButton(type: .system)
  private var didTapDelete: (() -> Void)?
  private func setUp() {
    layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
    backgroundColor = .quaternarySystemFill
    stack.axis = .horizontal
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.distribution = .equalSpacing
    stack.addArrangedSubview(label)
    stack.addArrangedSubview(button)
    label.font = .preferredFont(forTextStyle: .title3)
    label.textColor = .black
    button.tintColor = .systemBlue
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
    button.setTitle("Delete", for: .normal)
    addSubview(stack)
    NSLayoutConstraint.activate([
      stack.leadingAnchor
        .constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      stack.topAnchor
        .constraint(equalTo: layoutMarginsGuide.topAnchor),
      stack.trailingAnchor
        .constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      stack.bottomAnchor
        .constraint(equalTo: layoutMarginsGuide.bottomAnchor),
    ])
    button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
  }
  @objc
  private func handleTap() {
    didTapDelete?()
  }
}

final class ActivityIndicatorView: UIActivityIndicatorView, EpoxyableView {
  func setContent(_ content: Bool, animated: Bool) {
    if content {
      startAnimating()
    } else {
      stopAnimating()
    }
  }
}

final class Label: UILabel, @preconcurrency EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    font = style.font
    numberOfLines = style.numberOfLines
    if style.showLabelBackground {
      backgroundColor = .secondarySystemBackground
    }
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  struct Style: Hashable {
    let font: UIFont
    let showLabelBackground: Bool
    var numberOfLines = 0
  }

  typealias Content = String

  func setContent(_ content: String, animated _: Bool) {
    text = content
  }
}

extension Label.Style {
  static func style(
    with textStyle: UIFont.TextStyle,
    showBackground: Bool = false
  ) -> Label.Style {
    .init(
      font: UIFont.preferredFont(forTextStyle: textStyle),
      showLabelBackground: showBackground
    )
  }
}

final class ButtonRow: UIView, @preconcurrency EpoxyableView {

  // MARK: Lifecycle

  init() {
    super.init(frame: .zero)
    setUp()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Behaviors {
    var didTap: (() -> Void)?
  }

  struct Content: Equatable {
    var text: String?
  }

  func setContent(_ content: Content, animated _: Bool) {
    text = content.text
  }

  func setBehaviors(_ behaviors: Behaviors?) {
    didTap = behaviors?.didTap
  }

  // MARK: Private

  private let button = UIButton(type: .system)
  private var didTap: (() -> Void)?

  private var text: String? {
    get { button.title(for: .normal) }
    set { button.setTitle(newValue, for: .normal) }
  }

  private func setUp() {
    translatesAutoresizingMaskIntoConstraints = false
    layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
    backgroundColor = .quaternarySystemFill

    button.tintColor = .systemBlue
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
    button.translatesAutoresizingMaskIntoConstraints = false

    addSubview(button)
    NSLayoutConstraint.activate([
      button.leadingAnchor
        .constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      button.topAnchor
        .constraint(equalTo: layoutMarginsGuide.topAnchor),
      button.trailingAnchor
        .constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      button.bottomAnchor
        .constraint(equalTo: layoutMarginsGuide.bottomAnchor),
    ])

    button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
  }

  @objc
  private func handleTap() {
    didTap?()
  }
}

import SwiftUI
// #Preview
struct EpoxyCounterViewControllerPreview: PreviewProvider {
  static var previews: some View {
    UIViewControllerRepresenting {
      EpoxyCounterViewController(model: CounterModel())
    }
  }
}
