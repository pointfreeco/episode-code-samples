import CasePaths
import Combine
import UIKit

class ItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  let viewModel: ItemViewModel

  private var cancellables: Set<AnyCancellable> = []

  init(viewModel: ItemViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // MARK: Layout

    self.view.backgroundColor = .white

    let nameTextField = UITextField()
    nameTextField.placeholder = "Name"
    nameTextField.borderStyle = .roundedRect

    let colorPicker = UIPickerView()
    colorPicker.dataSource = self
    colorPicker.delegate = self

    let quantityLabel = UILabel()

    let quantityStepper = UIStepper()
    quantityStepper.maximumValue = .infinity

    let quantityStackView = UIStackView(arrangedSubviews: [quantityLabel, quantityStepper])

    let markAsSoldOutButton = UIButton()
    markAsSoldOutButton.setTitle("Mark as sold out", for: .normal)

    let inStockStackView = UIStackView(arrangedSubviews: [
      quantityStackView,
      markAsSoldOutButton,
    ])
    inStockStackView.axis = .vertical

    let isOnBackOrderLabel = UILabel()
    isOnBackOrderLabel.text = "Is on back order?"

    let isOnBackOrderSwitch = UISwitch()

    let isOnBackOrderStackView = UIStackView(arrangedSubviews: [
      isOnBackOrderLabel,
      isOnBackOrderSwitch,
    ])

    let isBackInStockButton = UIButton()
    isBackInStockButton.setTitle("Is back in stock!", for: .normal)

    let outOfStockStackView = UIStackView(arrangedSubviews: [
      isOnBackOrderStackView,
      isBackInStockButton,
    ])
    outOfStockStackView.axis = .vertical

    let statusStackView = UIStackView(arrangedSubviews: [
      inStockStackView,
      outOfStockStackView,
    ])
    statusStackView.axis = .vertical

    let stackView = UIStackView(arrangedSubviews: [
      nameTextField,
      colorPicker,
      statusStackView,
    ])
    stackView.axis = .vertical
    stackView.spacing = UIStackView.spacingUseSystem
    stackView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: self.view.readableContentGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor),
    ])

    // MARK: View Model Bindings

    self.viewModel.$item
      .map(\.name)
      .removeDuplicates()
      .sink { name in nameTextField.text = name }
      .store(in: &self.cancellables)

    nameTextField.addAction(
      .init(handler: { [weak self] action in
        self?.viewModel.item.name = (action.sender as? UITextField)?.text ?? ""
      }),
      for: .editingChanged
    )

    self.viewModel.$item
      .map(\.color)
      .removeDuplicates()
      .compactMap { color in color.flatMap(Item.Color.all.firstIndex(of:)) }
      .sink { row in colorPicker.selectRow(row, inComponent: 0, animated: false ) }
      .store(in: &self.cancellables)

    self.viewModel.$item
      .map { !(/Item.Status.inStock ~= $0.status) }
      .removeDuplicates()
      .sink { isHidden in inStockStackView.isHidden = isHidden }
      .store(in: &self.cancellables)

    self.viewModel.$item
      .map(\.status)
      .compactMap(/Item.Status.inStock)
      .removeDuplicates()
      .sink { quantity in
        quantityLabel.text = "Quantity: \(quantity)"
        quantityStepper.value = Double(quantity)
      }
      .store(in: &self.cancellables)

    quantityStepper.addAction(
      .init { _ in
        self.viewModel.item.status = .inStock(quantity: Int(quantityStepper.value))
      },
      for: .valueChanged
    )

    markAsSoldOutButton.addAction(
      .init { [weak self] _ in
        self?.viewModel.item.status = .outOfStock(isOnBackOrder: false)
      },
      for: .touchUpInside
    )

    self.viewModel.$item
      .map(\.status)
      .map(/Item.Status.outOfStock)
      .map { $0 == nil }
      .removeDuplicates()
      .sink { isHidden in outOfStockStackView.isHidden = isHidden }
      .store(in: &self.cancellables)

    self.viewModel.$item
      .map(\.status)
      .compactMap(/Item.Status.outOfStock)
      .removeDuplicates()
      .sink { isOnBackOrder in isOnBackOrderSwitch.isOn = isOnBackOrder }
      .store(in: &self.cancellables)

    isOnBackOrderSwitch.addAction(
      .init(handler: { [weak self, weak isOnBackOrderSwitch] action in
        guard let self = self, let isOnBackOrder = isOnBackOrderSwitch?.isOn
        else { return }

        self.viewModel.item.status = .outOfStock(isOnBackOrder: isOnBackOrder)
      }),
      for: .valueChanged
    )

    isBackInStockButton.addAction(
      .init { [weak self] _ in
        self?.viewModel.item.status = .inStock(quantity: 1)
      },
      for: .touchUpInside
    )
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    Item.Color.all.count
  }

  func pickerView(
    _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int
  ) -> String? {
    Item.Color.all[row]?.name ?? "None"
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.viewModel.item.color = Item.Color.all[row]
  }
}
