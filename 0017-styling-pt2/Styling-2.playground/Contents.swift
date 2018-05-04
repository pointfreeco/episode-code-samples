import Foundation
import PlaygroundSupport
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

final class SubscribeCalloutCell: UITableViewCell {
  private let bodyLabel = UILabel()
  private let buttonsStackView = UIStackView()
  private let cardView = UIView()
  private let loginButton = UIButton()
  private let orLabel = UILabel()
  private let rootStackView = UIStackView()
  private let subscribeButton = UIButton()
  private let titleLabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.selectionStyle = .none
    self.contentView.layoutMargins = .init(top: .pf_grid(6), left: .pf_grid(6), bottom: .pf_grid(6), right: .pf_grid(6))

    self.titleLabel.text = "Subscribe to Point-Free"
    self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)

    self.bodyLabel.text = "👋 Hey there! See anything you like? You may be interested in subscribing so that you get access to these episodes and all future ones."
    self.bodyLabel.numberOfLines = 0
    self.bodyLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)

    self.cardView.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
    with(self.cardView, generousMargins)
    self.cardView.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(self.cardView)

    self.rootStackView.alignment = .leading
    with(self.rootStackView, baseStackViewStyle)
    self.rootStackView.addArrangedSubview(self.titleLabel)
    self.rootStackView.addArrangedSubview(self.bodyLabel)
    self.rootStackView.addArrangedSubview(self.buttonsStackView)
    self.contentView.addSubview(self.rootStackView)

    self.orLabel.text = "or"
    self.orLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)

    self.subscribeButton.setTitle("See subscription options", for: .normal)
    with(self.subscribeButton, primaryButtonStyle)

    self.loginButton.setTitle("Login", for: .normal)
    with(self.loginButton, secondaryTextButtonStyle)

    self.buttonsStackView.spacing = .pf_grid(2)
    self.buttonsStackView.alignment = .firstBaseline
    self.buttonsStackView.addArrangedSubview(self.subscribeButton)
    self.buttonsStackView.addArrangedSubview(self.orLabel)
    self.buttonsStackView.addArrangedSubview(self.loginButton)

    NSLayoutConstraint.activate([
      self.rootStackView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
      self.rootStackView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
      self.rootStackView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
      self.rootStackView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),

      self.cardView.leadingAnchor.constraint(equalTo: self.rootStackView.leadingAnchor),
      self.cardView.topAnchor.constraint(equalTo: self.rootStackView.topAnchor),
      self.cardView.trailingAnchor.constraint(equalTo: self.rootStackView.trailingAnchor),
      self.cardView.bottomAnchor.constraint(equalTo: self.rootStackView.bottomAnchor),
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class EpisodeCell: UITableViewCell {
  private let blurbLabel = UILabel()
  private let contentStackView = UIStackView()
  private let posterImageView = UIImageView()
  private let rootStackView = UIStackView()
  private let sequenceAndDateLabel = UILabel()
  private let titleLabel = UILabel()
  private let watchNowButton = UIButton()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.blurbLabel.numberOfLines = 0
    self.blurbLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)

    with(self.contentStackView, concat(
      baseStackViewStyle,
      mut(\.layoutMargins.bottom, .pf_grid(8))
    ))
    self.contentStackView.alignment = .leading
    self.contentStackView.addArrangedSubview(self.sequenceAndDateLabel)
    self.contentStackView.addArrangedSubview(self.titleLabel)
    self.contentStackView.addArrangedSubview(self.blurbLabel)
    self.contentStackView.addArrangedSubview(self.watchNowButton)


    with(self.rootStackView, concat(
      autoLayoutStyle,
      verticalStackView
    ))
    self.rootStackView.addArrangedSubview(self.posterImageView)
    self.rootStackView.addArrangedSubview(self.contentStackView)

    self.sequenceAndDateLabel.font = UIFont.preferredFont(forTextStyle: .caption1).smallCaps

    self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)

    self.watchNowButton.setTitle("Watch episode →", for: .normal)
    with(self.watchNowButton, primaryTextButtonStyle)

    self.contentView.addSubview(self.rootStackView)

    NSLayoutConstraint.activate([
      self.rootStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.rootStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.rootStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.rootStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

      self.posterImageView.widthAnchor.constraint(equalTo: self.posterImageView.heightAnchor, multiplier: 16/9),
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with episode: Episode) {
    self.titleLabel.text = episode.title
    self.blurbLabel.text = episode.blurb
    let formattedDate = episodeDateFormatter.string(from: episode.publishedAt)
    self.sequenceAndDateLabel.text = "#\(episode.sequence) • \(formattedDate)"

    URLSession.shared.dataTask(with: URL(string: episode.posterImageUrl)!) { data, _, _ in
      DispatchQueue.main.async { self.posterImageView.image = data.flatMap(UIImage.init(data:)) }
      }.resume()
  }
}

final class EpisodeListViewController: UITableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.estimatedRowHeight = 400
    self.tableView.rowHeight = UITableViewAutomaticDimension
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      return SubscribeCalloutCell(style: .default, reuseIdentifier: nil)
    }

    let cell = EpisodeCell(style: .default, reuseIdentifier: nil)
    cell.configure(with: episodes[indexPath.row - 1])
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodes.count + 1
  }
}

let vc = EpisodeListViewController()
vc.preferredContentSize = .init(width: 376, height: 1000)
PlaygroundPage.current.liveView = vc
