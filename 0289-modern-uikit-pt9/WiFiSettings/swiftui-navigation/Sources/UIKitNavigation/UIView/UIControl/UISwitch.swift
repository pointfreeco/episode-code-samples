import UIKit

@available(iOS 14, *)
extension UISwitch {
  public convenience init(frame: CGRect = .zero, isOn: UIBinding<Bool>) {
    self.init(frame: frame)
    self.bind(isOn: isOn)
  }

  public func bind(isOn: UIBinding<Bool>) {
    self.bind(isOn, to: \.isOn, for: .valueChanged) { [weak self] isAnimated in
      self?.setOn(isOn.wrappedValue, animated: isAnimated)
    }
    self.addAction(
      UIAction { [weak self] _ in
        guard let self else { return }
        isOn.wrappedValue = self.isOn
      }, 
      for: .valueChanged
    )
  }
}
