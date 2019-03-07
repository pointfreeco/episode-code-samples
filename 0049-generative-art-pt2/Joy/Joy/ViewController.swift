import UIKit

var rng = SystemRandomNumberGenerator()

class ViewController: UIViewController {

  let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
  let amplitudeLabel = UILabel()
  let amplitudeSlider = UISlider()
  let centerLabel = UILabel()
  let centerSlider = UISlider()
  let plateauLabel = UILabel()
  let plateauSlider = UISlider()
  let curveLabel = UILabel()
  let curveSlider = UISlider()

  var amplitude: Float = 0.5
  var center: Float = 0.5
  var plateauSize: Float = 0.5
  var curveSize: Float = 0.5

  override func viewDidLoad() {
    super.viewDidLoad()

    setImage()

    amplitudeLabel.text = "Amplitude"
    amplitudeLabel.textColor = .white

    amplitudeSlider.value = amplitude
    amplitudeSlider.isContinuous = false
    amplitudeSlider.addTarget(self, action: #selector(amplitudeChanged), for: .valueChanged)

    centerLabel.text = "Center"
    centerLabel.textColor = .white

    centerSlider.value = center
    centerSlider.isContinuous = false
    centerSlider.addTarget(self, action: #selector(centerChanged), for: .valueChanged)

    plateauLabel.text = "Plateau size"
    plateauLabel.textColor = .white

    plateauSlider.value = plateauSize
    plateauSlider.isContinuous = false
    plateauSlider.addTarget(self, action: #selector(plateauChanged), for: .valueChanged)

    curveLabel.text = "Curve size"
    curveLabel.textColor = .white

    curveSlider.value = curveSize
    curveSlider.isContinuous = false
    curveSlider.addTarget(self, action: #selector(curveChanged), for: .valueChanged)

    let stackView = UIStackView(arrangedSubviews: [
      imageView,
      amplitudeLabel,
      amplitudeSlider,
      centerLabel,
      centerSlider,
      plateauLabel,
      plateauSlider,
      curveLabel,
      curveSlider,
      ])
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false

    view.backgroundColor = .black
    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      ])
  }

  @objc func amplitudeChanged() {
    amplitude = amplitudeSlider.value
    setImage()
  }

  @objc func centerChanged() {
    center = centerSlider.value
    setImage()
  }

  @objc func plateauChanged() {
    plateauSize = plateauSlider.value
    setImage()
  }

  @objc func curveChanged() {
    curveSize = curveSlider.value
    setImage()
  }

  func setImage() {
    let newImage = image(
      amplitude: CGFloat(self.amplitude),
      center: CGFloat(self.center),
      plateauSize: CGFloat(self.plateauSize),
      curveSize: CGFloat(self.curveSize)
      ).run(using: &rng)
    self.imageView.image = newImage
  }
}

