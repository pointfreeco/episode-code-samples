import Foundation
import UIKit

public var episodeDateFormatter: DateFormatter {
  let formatter = DateFormatter()
  formatter.dateFormat = "EEEE MMM d, yyyy"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  return formatter
}

extension UIColor {
  public static let pf_black = UIColor(white: 0.07, alpha: 1)
  public static let pf_blue = UIColor(red: 76/255, green: 204/255, blue: 255/255, alpha: 1)
  public static let pf_gray950 = UIColor(white: 0.95, alpha: 1.0)
  public static let pf_green = UIColor(red: 121/255, green: 242/255, blue: 176/255, alpha: 1)
  public static let pf_purple = UIColor(red: 151/255, green: 77/255, blue: 255/255, alpha: 1)
  public static let pf_red = UIColor(red: 235/255, green: 28/255, blue: 38/255, alpha: 1)
  public static let pf_yellow = UIColor(red: 255/255, green: 240/255, blue: 128/255, alpha: 1)
}

extension UIImage {
  public static func from(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    defer { UIGraphicsEndImageContext() }
    guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
    context.setFillColor(color.cgColor)
    context.fill(rect)
    return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
  }
}

extension UIFont {
  public var smallCaps: UIFont {
    let upperCaseFeature = [
      UIFontDescriptor.FeatureKey.featureIdentifier : kUpperCaseType,
      UIFontDescriptor.FeatureKey.typeIdentifier : kUpperCaseSmallCapsSelector
    ]
    let lowerCaseFeature = [
      UIFontDescriptor.FeatureKey.featureIdentifier : kLowerCaseType,
      UIFontDescriptor.FeatureKey.typeIdentifier : kLowerCaseSmallCapsSelector
    ]
    let features = [upperCaseFeature, lowerCaseFeature]
    let smallCapsDescriptor = self.fontDescriptor.addingAttributes([UIFontDescriptor.AttributeName.featureSettings : features])
    return UIFont(descriptor: smallCapsDescriptor, size: 0)
  }

  public var bolded: UIFont {
    guard let descriptor = self.fontDescriptor.withSymbolicTraits(.traitBold) else { return self }
    return UIFont(descriptor: descriptor, size: 0)
  }
}

func wrapView(padding: UIEdgeInsets) -> (UIView) -> UIView {
  return { subview in
    let wrapper = UIView()
    subview.translatesAutoresizingMaskIntoConstraints = false
    wrapper.addSubview(subview)
    NSLayoutConstraint.activate([
      subview.leadingAnchor.constraint(
        equalTo: wrapper.leadingAnchor, constant: padding.left
      ),
      subview.rightAnchor.constraint(
        equalTo: wrapper.rightAnchor, constant: -padding.right
      ),
      subview.topAnchor.constraint(
        equalTo: wrapper.topAnchor, constant: padding.top
      ),
      subview.bottomAnchor.constraint(
        equalTo: wrapper.bottomAnchor, constant: -padding.bottom
      ),
      ])
    return wrapper
  }
}
