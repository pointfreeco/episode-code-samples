import Foundation
import UIKit
import Overture

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
  private let subscriberOnlyLabel = UILabel()
  private lazy var subscriberOnlyLabelWrapper = with(
    wrapView(
      padding: UIEdgeInsets(
        top: .pf_grid(1),
        left: .pf_grid(2),
        bottom: .pf_grid(1),
        right: .pf_grid(2)
      )
      )(self.subscriberOnlyLabel),
    concat(
      autoLayoutStyle,
      baseRoundedStyle,
      mut(\UIView.backgroundColor, UIColor(white: 0, alpha: 0.3))
    )
  )

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

    with(self.sequenceAndDateLabel, smallCapsLabelStyle)

    self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)

    self.watchNowButton.setTitle("Watch episode →", for: .normal)
    with(self.watchNowButton, primaryTextButtonStyle)

    self.subscriberOnlyLabel.text = "Subscriber Only"
    with(self.subscriberOnlyLabel, concat(
      smallCapsLabelStyle,
      mut(\.textColor, .white)
    ))

    self.contentView.addSubview(self.rootStackView)
    self.contentView.addSubview(self.subscriberOnlyLabelWrapper)

    NSLayoutConstraint.activate([
      self.rootStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.rootStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.rootStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.rootStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

      self.posterImageView.widthAnchor.constraint(equalTo: self.posterImageView.heightAnchor, multiplier: 16/9),

      self.subscriberOnlyLabelWrapper.topAnchor.constraint(equalTo: self.posterImageView.topAnchor, constant: .pf_grid(3)),
      self.subscriberOnlyLabelWrapper.trailingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: -.pf_grid(6)),
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
    self.subscriberOnlyLabel.isHidden = !episode.subscriberOnly

    URLSession.shared.dataTask(with: URL(string: episode.posterImageUrl)!) { data, _, _ in
      DispatchQueue.main.async { self.posterImageView.image = data.flatMap(UIImage.init(data:)) }
      }.resume()
  }
}

public final class EpisodeListViewController: UITableViewController {
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.estimatedRowHeight = 400
    self.tableView.rowHeight = UITableViewAutomaticDimension
  }

  override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      return SubscribeCalloutCell(style: .default, reuseIdentifier: nil)
    }

    let cell = EpisodeCell(style: .default, reuseIdentifier: nil)
    cell.configure(with: episodes[indexPath.row - 1])
    return cell
  }

  override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodes.count + 1
  }
}
