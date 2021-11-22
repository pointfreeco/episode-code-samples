import CasePaths
import Combine
import SwiftUI
import UIKit

class ItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
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
    
    // MARK: View creation
    
    let nameTextField = UITextField()
    nameTextField.placeholder = "Name"
    nameTextField.borderStyle = .roundedRect
    
    let colorPicker = UIPickerView()
    colorPicker.dataSource = self
    colorPicker.delegate = self
    
    let quantityLabel = UILabel()
    
    let quantityStepper = UIStepper()
    quantityStepper.maximumValue = .infinity

    let quantityStackView = UIStackView(arrangedSubviews: [
      quantityLabel,
      quantityStepper
    ])
    
    let markAsSoldOutButton = UIButton(type: .system)
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

    let isBackInStockButton = UIButton(type: .system)
    isBackInStockButton.setTitle("Is back in stock!", for: .normal)

    let outOfStockStackView = UIStackView(arrangedSubviews: [
      isOnBackOrderStackView,
      isBackInStockButton,
    ])
    outOfStockStackView.axis = .vertical
    
    let stackView = UIStackView(arrangedSubviews: [
      nameTextField,
      colorPicker,
      inStockStackView,
      outOfStockStackView,
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
    
    // MARK: View model bindings
    
    self.viewModel.$item
      .map(\.name)
      .removeDuplicates()
      .sink { nameTextField.text = $0 }
      .store(in: &self.cancellables)
    
    self.viewModel.$item
      .map(\.color)
      .removeDuplicates()
      .sink { color in
        guard let row = Item.Color.all.firstIndex(of: color)
        else { return }
        colorPicker.selectRow(row, inComponent: 0, animated: false)
      }
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

    self.viewModel.$item
      .map { /Item.Status.inStock ~= $0.status }
      .removeDuplicates()
      .sink { isInStock in
        inStockStackView.isHidden = !isInStock
      }
      .store(in: &self.cancellables)

    self.viewModel.$item
      .map { /Item.Status.outOfStock ~= $0.status }
      .removeDuplicates()
      .sink { isOutOfStock in
        outOfStockStackView.isHidden = !isOutOfStock
      }
      .store(in: &self.cancellables)

    self.viewModel.$item
      .map(\.status)
      .compactMap(/Item.Status.outOfStock)
      .removeDuplicates()
      .sink { isOnBackOrder in
        isOnBackOrderSwitch.isOn = isOnBackOrder
      }
      .store(in: &self.cancellables)

    // MARK: UI actions
    
    quantityStepper.addAction(.init { [unowned self, unowned quantityStepper] _ in
      self.viewModel.item.status = .inStock(quantity: Int(quantityStepper.value))
    }, for: .valueChanged)

    markAsSoldOutButton.addAction(
      .init { [unowned self] _ in
        self.viewModel.item.status = .outOfStock(isOnBackOrder: false)
      },
      for: .touchUpInside
    )

    isBackInStockButton.addAction(
      .init { [unowned self] _ in
        self.viewModel.item.status = .inStock(quantity: 1)
      },
      for: .touchUpInside
    )

    nameTextField.addAction(
      .init { [unowned self, unowned nameTextField] _ in
        self.viewModel.item.name = nameTextField.text ?? ""
      },
      for: .editingChanged
    )

    isOnBackOrderSwitch.addAction(
      .init { [unowned self, unowned isOnBackOrderSwitch] _ in
        self.viewModel.item.status = .outOfStock(isOnBackOrder: isOnBackOrderSwitch.isOn)
      },
      for: .valueChanged
    )
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    Item.Color.all.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    Item.Color.all[row]?.name ?? "None"
  }

  func pickerView(
    _ pickerView: UIPickerView,
    didSelectRow row: Int,
    inComponent component: Int
  ) {
    self.viewModel.item.color = Item.Color.all[row]
  }
}

extension Item.Color {
  static let all: [Self?] = [nil] + Self.defaults
}

struct ItemViewController_Previews: PreviewProvider {
  static var previews: some View {
    ToSwiftUI {
      ItemViewController(
        viewModel: ItemViewModel(
          item: .init(
            name: "Keyboard",
            color: .blue,
            status: .outOfStock(isOnBackOrder: true)
          ),
          route: nil
        )
      )
    }
  }
}
