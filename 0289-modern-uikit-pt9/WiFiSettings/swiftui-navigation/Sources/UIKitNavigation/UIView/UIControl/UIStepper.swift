import UIKit

@available(iOS 14, *)
extension UIStepper {
  public convenience init(frame: CGRect = .zero, value: UIBinding<Double>) {
    self.init(frame: frame)
    self.bind(value: value)
  }

  public func bind(value: UIBinding<Double>) {
    self.bind(value, to: \.value, for: .valueChanged)
  }
}
