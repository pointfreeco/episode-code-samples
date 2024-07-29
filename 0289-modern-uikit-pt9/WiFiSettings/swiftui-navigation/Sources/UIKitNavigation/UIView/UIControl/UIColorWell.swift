import UIKit

@available(iOS 14, *)
extension UIColorWell {
  public convenience init(frame: CGRect = .zero, selectedColor: UIBinding<UIColor?>) {
    self.init(frame: frame)
    self.bind(selectedColor: selectedColor)
  }

  public func bind(selectedColor: UIBinding<UIColor?>) {
    self.bind(selectedColor, to: \.selectedColor, for: .valueChanged)
  }
}
