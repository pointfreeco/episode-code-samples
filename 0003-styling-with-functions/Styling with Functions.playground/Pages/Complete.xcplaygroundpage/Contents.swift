import UIKit

func <> <A: AnyObject>(f: @escaping (A) -> Void, g: @escaping (A) -> Void) -> (A) -> Void {
  return { a in
    f(a)
    g(a)
  }
}

// base

func autolayoutStyle(_ view: UIView) -> Void {
  view.translatesAutoresizingMaskIntoConstraints = false
}

func aspectRatioStyle(size: CGSize) -> (UIView) -> Void {
  return {
    $0.widthAnchor
      .constraint(equalTo: $0.heightAnchor, multiplier: size.width / size.height)
      .isActive = true
  }
}

func borderStyle(color: UIColor, width: CGFloat) -> (UIView) -> Void {
  return {
    $0.layer.borderColor = color.cgColor
    $0.layer.borderWidth = width
  }
}

func implicitAspectRatioStyle(_ view: UIView) -> Void {
  aspectRatioStyle(size: view.frame.size)(view)
}

func roundedStyle(_ view: UIView) {
  view.clipsToBounds = true
  view.layer.cornerRadius = 6
}

// buttons

let baseButtonStyle: (UIButton) -> Void = {
  $0.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
  $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
}

let roundedButtonStyle =
  baseButtonStyle
    <> roundedStyle

let filledButtonStyle =
  roundedButtonStyle
    <> {
      $0.backgroundColor = .black
      $0.tintColor = .white
}

let borderButtonStyle =
  roundedButtonStyle
    <> borderStyle(color: .black, width: 2)
    <> {
      $0.setTitleColor(.black, for: .normal)
}

let textButtonStyle =
  baseButtonStyle <> {
    $0.setTitleColor(.black, for: .normal)
}

let imageButtonStyle: (UIImage?) -> (UIButton) -> Void = { image in
  return {
    $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    $0.setImage(image, for: .normal)
  }
}

let gitHubButtonStyle =
  filledButtonStyle
    <> imageButtonStyle(UIImage(named: "github"))

// text fields

let baseTextFieldStyle: (UITextField) -> Void =
  roundedStyle
    <> borderStyle(color: UIColor(white: 0.75, alpha: 1), width: 1)
    <> { (tf: UITextField) in
      tf.borderStyle = .roundedRect
      tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
}

let emailTextFieldStyle =
  baseTextFieldStyle
    <> {
      $0.keyboardType = .emailAddress
      $0.placeholder = "blob@pointfree.co"
}

let passwordTextFieldStyle =
  baseTextFieldStyle
    <> {
      $0.isSecureTextEntry = true
      $0.placeholder = "••••••••••••••••"
}

// labels

func fontStyle(ofSize size: CGFloat, weight: UIFont.Weight) -> (UILabel) -> Void {
  return {
    $0.font = .systemFont(ofSize: size, weight: weight)
  }
}

func textColorStyle(_ color: UIColor) -> (UILabel) -> Void {
  return {
    $0.textColor = color
  }
}

let centerStyle: (UILabel) -> Void = {
  $0.textAlignment = .center
}

// hyper-local

let orLabelStyle: (UILabel) -> Void =
  centerStyle
    <> fontStyle(ofSize: 14, weight: .medium)
    <> textColorStyle(UIColor(white: 0.625, alpha: 1))

let finePrintStyle: (UILabel) -> Void =
  centerStyle
    <> fontStyle(ofSize: 14, weight: .medium)
    <> textColorStyle(UIColor(white: 0.5, alpha: 1))
    <> {
      $0.font = .systemFont(ofSize: 11, weight: .light)
      $0.numberOfLines = 0
}

let gradientStyle: (GradientView) -> Void =
  autolayoutStyle <> {
    $0.fromColor = UIColor(red: 0.5, green: 0.85, blue: 1, alpha: 0.85)
    $0.toColor = .white
}

// stack views

let rootStackViewStyle: (UIStackView) -> Void =
  autolayoutStyle
    <> {
      $0.axis = .vertical
      $0.isLayoutMarginsRelativeArrangement = true
      $0.layoutMargins = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
      $0.spacing = 16
}

final class SignInViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .white

    let gradientView = GradientView()
    gradientStyle(gradientView)

    let logoImageView = UIImageView(image: UIImage(named: "logo"))
    implicitAspectRatioStyle(logoImageView)

    baseButtonStyle(.appearance())

    let gitHubButton = UIButton(type: .system)
    gitHubButton.setTitle("Sign in with GitHub", for: .normal)
    gitHubButtonStyle(gitHubButton)

    let orLabel = UILabel()
    orLabelStyle(orLabel)
    orLabel.text = "or"

    let emailField = UITextField()
    emailTextFieldStyle(emailField)

    let passwordField = UITextField()
    passwordTextFieldStyle(passwordField)

    let signInButton = UIButton(type: .system)
    signInButton.setTitle("Sign in", for: .normal)
    borderButtonStyle(signInButton)

    let forgotPasswordButton = UIButton(type: .system)
    forgotPasswordButton.setTitle("I forgot my password", for: .normal)
    textButtonStyle(forgotPasswordButton)

    let legalLabel = UILabel()
    legalLabel.text = "By signing into Point-Free you agree to our latest terms of use and privacy policy."
    finePrintStyle(legalLabel)

    let rootStackView = UIStackView(arrangedSubviews: [
      logoImageView,
      gitHubButton,
      orLabel,
      emailField,
      passwordField,
      signInButton,
      forgotPasswordButton,
      legalLabel,
      ])
    rootStackViewStyle(rootStackView)

    self.view.addSubview(gradientView)
    self.view.addSubview(rootStackView)

    NSLayoutConstraint.activate([
      gradientView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      gradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      gradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      gradientView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor),

      rootStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      rootStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      rootStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      ])
  }
}

import PlaygroundSupport
PlaygroundPage.current.liveView = SignInViewController()
