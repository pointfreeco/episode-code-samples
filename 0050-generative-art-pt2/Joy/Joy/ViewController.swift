import UIKit

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
//    Current.date = { Date.init(timeIntervalSince1970: 1517202000) }
//    var rng = SystemRandomNumberGenerator()
    let newImage = image(
      amplitude: CGFloat(self.amplitude),
      center: CGFloat(self.center),
      plateauSize: CGFloat(self.plateauSize),
      curveSize: CGFloat(self.curveSize),
      isPointFreeAnniversary: Current.date().isPointFreeAnniversary
      ).run(using: &Current.rng)
    self.imageView.image = newImage
  }
}

struct Environment {
  var calendar = Calendar.current
  var date = { Date() }
  var rng = AnyRandomNumberGenerator(rng: SystemRandomNumberGenerator())
}
var Current = Environment()

extension Date {
  var isPointFreeAnniversary: Bool {
    let components = Current.calendar.dateComponents([.day, .month], from: self)
    return components.day == 29 && components.month == 1
  }
}
