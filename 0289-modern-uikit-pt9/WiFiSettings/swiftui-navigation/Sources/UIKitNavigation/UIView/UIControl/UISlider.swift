import UIKit

@available(iOS 14, *)
extension UISlider {
  public convenience init(frame: CGRect = .zero, value: UIBinding<Float>) {
    self.init(frame: frame)
    self.bind(value: value)
  }

  public func bind(value: UIBinding<Float>) {
    self.bind(value, to: \.value, for: .valueChanged)
  }
}
