import UIKit
import SafariServices

enum Result<Value, Error> {
  case success(Value)
  case failure(Error)
}

// =======================================
//
//             GitHub Client
//
// =======================================

struct GitHub {
  struct Repo: Decodable {
    var archived: Bool
    var description: String?
    var htmlUrl: URL
    var name: String
    var pushedAt: Date?
  }

  var fetchRepos = fetchRepos(onComplete:)
}

private func fetchRepos(onComplete completionHandler: (@escaping (Result<[GitHub.Repo], Error>) -> Void)) {
  dataTask("orgs/pointfreeco/repos", completionHandler: completionHandler)
}

private func dataTask<T: Decodable>(_ path: String, completionHandler: (@escaping (Result<T, Error>) -> Void)) {
  let request = URLRequest(url: URL(string: "https://api.github.com/" + path)!)
  URLSession.shared.dataTask(with: request) { data, urlResponse, error in
    do {
      if let error = error {
        throw error
      } else if let data = data {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        completionHandler(.success(try decoder.decode(T.self, from: data)))
      } else {
        fatalError()
      }
    } catch let finalError {
      completionHandler(.failure(finalError))
    }
    }.resume()
}

// =======================================
//
//            Analytics Client
//
// =======================================

struct Version {
  var build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
  var release = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
}

struct Screen {
  var screenHeight = String(describing: UIScreen.main.bounds.height)
  var screenWidth = String(describing: UIScreen.main.bounds.width)
}

struct Device {
  var systemName = UIDevice.current.systemName
  var systemVersion = UIDevice.current.systemVersion
}

struct Analytics {
  struct Event {
    var name: String
    var properties: [String: String]

    static func tappedRepo(_ repo: GitHub.Repo) -> Event {
      return Event(
        name: "tapped_repo",
        properties: [
          "repo_name": repo.name,
          "build": Current.version.build,
          "release": Current.version.release,
          "screen_height": Current.screen.screenHeight,
          "screen_width": Current.screen.screenWidth,
          "system_name": Current.device.systemName,
          "system_version": Current.device.systemVersion,
          ]
      )
    }
  }

  var track = track(_:)
}

private func track(_ event: Analytics.Event) {
  print("Tracked", event)
}

// =======================================
//
//             Environment
//
// =======================================

struct Environment {
  var analytics = Analytics()
  var calendar = Calendar.autoupdatingCurrent
  var date: () -> Date = Date.init
  var device = Device()
  var gitHub = GitHub()
  var screen = Screen()
  var version = Version()
}

var Current = Environment()

// =======================================
//
//          Table View Controller
//
// =======================================

class ReposViewController: UITableViewController {
  var repos: [GitHub.Repo] = [] {
    didSet {
      self.tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Point-Free Repos"
    self.view.backgroundColor = .white

    Current.gitHub.fetchRepos { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case let .success(repos):
          self?.repos = repos
            //            .filter { !$0.archived }
            .sorted(by: {
              guard let lhs = $0.pushedAt, let rhs = $1.pushedAt else { return false }
              return lhs > rhs
            })
        case let .failure(error):
          let alert = UIAlertController(
            title: "Something went wrong",
            message: error.localizedDescription,
            preferredStyle: .alert
          )
          self?.present(alert, animated: true, completion: nil)
        }
      }
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.repos.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let repo = self.repos[indexPath.row]

    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
    cell.textLabel?.text = repo.name
    cell.detailTextLabel?.text = repo.description

    let dateComponentsFormatter = DateComponentsFormatter()
    dateComponentsFormatter.calendar = Current.calendar
    dateComponentsFormatter.allowedUnits = [.day, .hour, .minute, .second]
    dateComponentsFormatter.maximumUnitCount = 1
    dateComponentsFormatter.unitsStyle = .abbreviated

    let label = UILabel()
    if let pushedAt = repo.pushedAt {
      label.text = dateComponentsFormatter.string(from: pushedAt, to: Current.date())
    }
    label.sizeToFit()

    let color = repo.archived ? UIColor.gray : .black
    cell.textLabel?.textColor = color
    cell.detailTextLabel?.textColor = color
    label.textColor = color

    cell.accessoryView = label

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let repo = self.repos[indexPath.row]
    Current.analytics.track(.tappedRepo(repo))
    let vc = SFSafariViewController(url: repo.htmlUrl)
    self.present(vc, animated: true, completion: nil)
  }
}

// =======================================
//
//            Dependency Mocks
//
// =======================================

extension GitHub.Repo {
  static let mock = GitHub.Repo(
    archived: false,
    description: "Blob's blog",
    htmlUrl: URL(string: "https://www.pointfree.co")!,
    name: "Bloblog",
    pushedAt: .mock - 60*60*24*116
  )
}

import Overture

extension Array where Element == GitHub.Repo {
  static let mock = [
    GitHub.Repo.mock,
    with(GitHub.Repo.mock, set(\.archived, true)),
    with(.mock, concat(
      set(\.name, "Nomadic Blob"),
      set(\.description, "Where in the world is Blob?"),
      set(\GitHub.Repo.pushedAt, .mock - 60*60*2)
    ))
    ] + mocks(5)

  static func mocks(_ count: Int) -> Array {
    return (1...count).map { n in
      with(.mock, concat(
        over(\.name) { "#\(n): \($0)" },
        set(\GitHub.Repo.pushedAt, .mock - 60*60*24*TimeInterval(n)*1000)
      ))
    }
  }
}

extension GitHub {
  static let mock = GitHub(fetchRepos: { callback in
    callback(
      .success(.mock)
    )
  })
}

extension Analytics {
  static let mock = Analytics(track: { event in
    print("Mock track", event)
  })
}

extension Date {
  static let mock = Date(timeIntervalSinceReferenceDate: 557152051)
}

extension Device {
  static let mock = Device(systemName: "Mock iOS", systemVersion: "11.mock")
}

extension Screen {
  static let mock = Screen(screenHeight: "568", screenWidth: "376")
}

extension Version {
  static let mock = Version(build: "42", release: "0.0.1")
}

extension Locale {
  static let mock = Locale(identifier: "en_US")
}

extension Calendar {
  static let mock = with(
    Calendar(identifier: .gregorian),
    set(\.locale, .mock)
  )
}

extension Environment {
  static let mock = Environment(
    analytics: .mock,
    calendar: .mock,
    date: { .mock },
    device: .mock,
    gitHub: .mock,
    screen: .mock,
    version: .mock
  )
}

// =======================================
//
//            Live Applications
//
// =======================================

Current = Environment()
Current = .mock
with(&Current, mut(\.calendar.locale, Locale(identifier: "de_DE")))

let reposViewController = ReposViewController()

import PlaygroundSupport
let vc = UINavigationController(rootViewController: reposViewController)
PlaygroundPage.current.liveView = vc
