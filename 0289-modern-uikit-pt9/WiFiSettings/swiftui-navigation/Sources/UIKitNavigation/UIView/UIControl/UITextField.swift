import UIKit

@available(iOS 14, *)
extension UITextField {
//  public convenience init(frame: CGRect = .zero, text: UIBinding<String?>) {
//    self.init(frame: frame)
//    self.bind(text: text)
//  }
//
//  public func bind(text: UIBinding<String?>) {
//    self.bind(text, to: \.text, for: .editingChanged)
//  }

  public convenience init(frame: CGRect = .zero, text: UIBinding<String>) {
    self.init(frame: frame)
    self.bind(text: text)
  }

  public func bind(text: UIBinding<String>) {
    self.bind(UIBinding(text), to: \.text, for: .editingChanged)
  }
}
