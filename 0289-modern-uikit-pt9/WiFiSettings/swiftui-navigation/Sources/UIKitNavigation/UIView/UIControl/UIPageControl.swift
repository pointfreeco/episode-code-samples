import UIKit

@available(iOS 14, *)
extension UIPageControl {
  public convenience init(frame: CGRect = .zero, currentPage: UIBinding<Int>) {
    self.init(frame: frame)
    self.bind(currentPage: currentPage)
  }

  public func bind(currentPage: UIBinding<Int>) {
    self.bind(currentPage, to: \.currentPage, for: .valueChanged)
  }
}
