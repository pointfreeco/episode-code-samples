import UIKit

extension UIView {
  var recursiveDescription: String {
    let description = self
      .perform(Selector(("recursiveDescription")))
      .retain().takeUnretainedValue()
      as! String
    return description
      .replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)", with: "$1", options: .regularExpression)
  }

  var image: UIImage {
    return UIGraphicsImageRenderer(size: self.layer.bounds.size).image { context in
      layer.render(in: context.cgContext)
    }
  }
}
