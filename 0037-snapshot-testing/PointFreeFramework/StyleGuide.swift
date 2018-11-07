import Foundation
import UIKit
import Overture

extension CGFloat {
  static func pf_grid(_ n: Int) -> CGFloat {
    return CGFloat(n) * 4
  }
}

let generousMargins =
  mut(\UIView.layoutMargins, .init(top: .pf_grid(6), left: .pf_grid(6), bottom: .pf_grid(6), right: .pf_grid(6)))

let autoLayoutStyle = mut(\UIView.translatesAutoresizingMaskIntoConstraints, false)

let verticalStackView = mut(\UIStackView.axis, .vertical)

let baseStackViewStyle = concat(
  generousMargins,
  mut(\UIStackView.spacing, .pf_grid(3)),
  verticalStackView,
  mut(\.isLayoutMarginsRelativeArrangement, true),
  autoLayoutStyle
)

let bolded: (inout UIFont) -> Void = { $0 = $0.bolded }

let baseTextButtonStyle = concat(
  mut(\UIButton.titleLabel!.font, UIFont.preferredFont(forTextStyle: .subheadline)),
  mver(\UIButton.titleLabel!.font!, bolded)
)

extension UIButton {
  var normalTitleColor: UIColor? {
    get { return self.titleColor(for: .normal) }
    set { self.setTitleColor(newValue, for: .normal) }
  }
}

let secondaryTextButtonStyle = concat(
  baseTextButtonStyle,
  mut(\.normalTitleColor, .black)
)

let primaryTextButtonStyle = concat(
  baseTextButtonStyle,
  mut(\.normalTitleColor, .pf_purple)
)

let baseButtonStyle = concat(
  baseTextButtonStyle,
  mut(\.contentEdgeInsets, .init(top: .pf_grid(2), left: .pf_grid(4), bottom: .pf_grid(2), right: .pf_grid(4)))
)

func roundedStyle(cornerRadius: CGFloat) -> (UIView) -> Void {
  return concat(
    mut(\.layer.cornerRadius, cornerRadius),
    mut(\.layer.masksToBounds, true)
  )
}

let baseRoundedStyle = roundedStyle(cornerRadius: 6)

let baseFilledButtonStyle = concat(
  baseButtonStyle,
  baseRoundedStyle
)

extension UIButton {
  var normalBackgroundImage: UIImage? {
    get { return self.backgroundImage(for: .normal) }
    set { self.setBackgroundImage(newValue, for: .normal) }
  }
}

let primaryButtonStyle = concat(
  baseFilledButtonStyle,
  mut(\.normalBackgroundImage, .from(color: .pf_purple)),
  mut(\.normalTitleColor, .white)
)

let smallCapsLabelStyle = mut(\UILabel.font, UIFont.preferredFont(forTextStyle: .caption1).smallCaps)
