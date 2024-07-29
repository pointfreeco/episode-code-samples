import UIKit

@MainActor
private protocol _UIControl: UIControl {}
extension UIControl: _UIControl {}

extension _UIControl {
  func bind<Value>(
    _ binding: UIBinding<Value>,
    to keyPath: ReferenceWritableKeyPath<Self, Value>,
    for event: UIControl.Event
  ) {
    observe { [weak self] in
      guard let self else { return }
      self[keyPath: keyPath] = binding.wrappedValue
    }
    self.addAction(
      UIAction { [weak self] _ in
        guard let self else { return }
        binding.wrappedValue = self[keyPath: keyPath]
      },
      for: event
    )
  }
}

extension UIStepper {
  convenience init(
    frame: CGRect = .zero,
    value: UIBinding<Double>
  ) {
    self.init(frame: frame)
    self.bind(value: value)
  }

  func bind(value: UIBinding<Double>) {
    self.bind(value, to: \.value, for: .valueChanged)
  }
}

extension UITextField {
  convenience init(
    frame: CGRect = .zero,
    text: UIBinding<String>
  ) {
    self.init(frame: frame)
    self.bind(text: text)
  }

  func bind(text: UIBinding<String>) {
    self.bind(text.toOptional, to: \.text, for: .editingChanged)
  }

  func bind(focus: UIBinding<Bool>) {
    observe { [weak self] in
      guard let self else { return }
      if focus.wrappedValue {
        becomeFirstResponder()
      } else {
        resignFirstResponder()
      }
    }
    addAction(
      UIAction { _ in focus.wrappedValue = true },
      for: .editingDidBegin
    )
    addAction(
      UIAction { _ in focus.wrappedValue = false },
      for: .editingDidEnd
    )
  }
}

extension String {
  fileprivate var toOptional: String? {
    get { self }
    set { self = newValue ?? "" }
  }
}
