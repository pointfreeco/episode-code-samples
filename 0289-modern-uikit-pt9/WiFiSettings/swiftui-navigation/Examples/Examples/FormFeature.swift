import UIKitNavigation

@MainActor
@Perceptible
final class FormModel: Hashable {
  var color: UIColor? = .white
  var date = Date()
  var isOn = false
  var isDrillDownPresented = false
  var isSheetPresented = false
  var sheet: Sheet?
  var sliderValue: Float = 0.5
  var stepperValue: Double = 5
  var text = "Blob"

  struct Sheet: Identifiable {
    var text = "Hi"
    var id: String { text }
  }

  nonisolated func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
  }
  nonisolated static func == (lhs: FormModel, rhs: FormModel) -> Bool {
    lhs === rhs
  }
}

@MainActor
final class FormViewController: UIViewController {
  @UIBindable var model: FormModel

  init(model: FormModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let myColorWell = UIColorWell(selectedColor: $model.color)

    let myDatePicker = UIDatePicker(date: $model.date)

    let mySlider = UISlider(value: $model.sliderValue)

    let myStepper = UIStepper(value: $model.stepperValue)

    let mySwitch = UISwitch(isOn: $model.isOn)

    let myTextField = UITextField(text: $model.text)
    myTextField.borderStyle = .roundedRect

    let sheetButton = UIButton(configuration: .plain(), primaryAction: UIAction { [weak self] _ in
      self?.model.sheet = .init(text: "Blob")
//      Task {
//        try await Task.sleep(for: .seconds(2))
//        self?.model.sheet = .init(text: "Blob, Jr.")
//      }
    })
    sheetButton.setTitle("Present sheet", for: .normal)

    let drillDownButton = UIButton(
      configuration: .plain(),
      primaryAction: UIAction { [weak self] _ in self?.model.isDrillDownPresented = true }
    )
    drillDownButton.setTitle("Present drill-down", for: .normal)

    let myLabel = UILabel()
    myLabel.numberOfLines = 0

    let stack = UIStackView(arrangedSubviews: [
      myColorWell,
      myDatePicker,
      mySlider,
      myStepper,
      mySwitch,
      myTextField,
      myLabel,
      sheetButton,
      drillDownButton,
    ])
    stack.axis = .vertical
    stack.isLayoutMarginsRelativeArrangement = true
    stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    stack.spacing = 8
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)

    _perceive { [weak self] in
      guard let self else { return }

      view.backgroundColor = model.color
      myLabel.text = """
      MyModel(
        color: \(String(describing: model.color)),
        date: \(model.date),
        isOn: \(model.isOn),
        sliderValue: \(model.sliderValue)
        stepperValue: \(model.stepperValue),
        text: \(model.text)
      )
      """
    }

    navigationController?.pushViewController(isPresented: $model.isDrillDownPresented) {
      ChildController()
    }

    present(item: $model.sheet) { item in
      ChildController(text: item.text)
    }

    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: view.topAnchor),
      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),

      myColorWell.heightAnchor.constraint(equalToConstant: 50),
    ])
  }
}

final class ChildController: UIViewController {
  let text: String
  init(text: String = "Hello!") {
    self.text = text
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    let label = UILabel()
    label.text = text
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    Task {
      try await Task.sleep(for: .seconds(1))
      if #available(iOS 17.0, *) {
        self.traitCollection.dismiss()
      }
    }
  }
}
