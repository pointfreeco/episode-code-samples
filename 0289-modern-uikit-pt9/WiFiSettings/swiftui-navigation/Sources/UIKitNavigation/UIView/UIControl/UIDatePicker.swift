import UIKit

@available(iOS 14, *)
extension UIDatePicker {
  public convenience init(frame: CGRect = .zero, date: UIBinding<Date>) {
    self.init(frame: frame)
    self.bind(date: date)
  }

  public func bind(date: UIBinding<Date>) {
    self.bind(date, to: \.date, for: .valueChanged)
  }
}
