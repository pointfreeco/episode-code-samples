import UIKit
import SafariServices
import Overture

enum Result<Value, Error> {
  case success(Value)
  case failure(Error)
}

//protocol GitHubProtocol {
//  func fetchRepos(onComplete completionHandler: (@escaping (Result<[GitHub.Repo], Error>) -> Void))
//}

struct GitHub { //: GitHubProtocol {
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

struct Analytics {
  struct Event {
    var name: String
    var properties: [String: String]

    static func tappedRepo(_ repo: GitHub.Repo) -> Event {
      return Event(
        name: "tapped_repo",
        properties: [
          "repo_name": repo.name,
          "build": String(Current.version.build),
          "release": Current.version.release,
          "screen_height": String(describing: Current.screen.size.height),
          "screen_width": String(describing: Current.screen.size.width),
          "system_name": Current.system.name,
          "system_version": Current.system.version,
          ]
      )
    }
  }

  var track = track(_:)
}

private func track(_ event: Analytics.Event) {
  print("Tracked", event)
}

struct Version {
  var build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
  var release = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
}

struct Screen {
  var size = UIScreen.main.bounds.size
}

struct System {
  var name = UIDevice.current.systemName
  var version = UIDevice.current.systemVersion
}

struct Environment {
  var analytics = Analytics()
  var calendar = Calendar.autoupdatingCurrent
  var date: () -> Date = Date.init
  var gitHub = GitHub()
  var locale = Locale.autoupdatingCurrent
  var screen = Screen()
  var system = System()
  var version = Version()
}

var Current = Environment()

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

    let color = repo.archived ? UIColor.red : .black
    cell.textLabel?.textColor = color
    cell.detailTextLabel?.textColor = color

    let dateComponentsFormatter = DateComponentsFormatter()
    dateComponentsFormatter.allowedUnits = [.day, .hour, .minute, .second]
    dateComponentsFormatter.calendar = Current.calendar
    dateComponentsFormatter.maximumUnitCount = 1
    dateComponentsFormatter.unitsStyle = .abbreviated
//    dateComponentsFormatter.unitsStyle = .short

    let label = UILabel()
    label.textColor = color
    if let pushedAt = repo.pushedAt {
      label.text = dateComponentsFormatter.string(from: pushedAt, to: Current.date())
    }
    label.sizeToFit()

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

extension TimeInterval {
  static func seconds(_ n: Double) -> TimeInterval {
    return n
  }

  static func minutes(_ n: Double) -> TimeInterval {
    return n * .seconds(60)
  }

  static func hours(_ n: Double) -> TimeInterval {
    return n * .minutes(60)
  }

  static func days(_ n: Double) -> TimeInterval {
    return n * .hours(24)
  }

  static func weeks(_ n: Double) -> TimeInterval {
    return n * .days(7)
  }
}

extension GitHub {
  static let mock = GitHub(fetchRepos: { callback in
    callback(
      .success(
        [
          GitHub.Repo(archived: false, description: "Blob's blog", htmlUrl: URL(string: "https://www.pointfree.co")!, name: "Bloblog", pushedAt: Date(timeIntervalSinceReferenceDate: 547152021))
        ]
      )
    )
  })
}

extension Analytics {
  static let mock = Analytics(track: { event in
    print("Mock track", event)
  })
}

extension Calendar {
  static let mock = with(Calendar(identifier: .gregorian), set(\.locale, .mock))
}

extension Date {
  static let mock = Date(timeIntervalSinceReferenceDate: 557152051)
}

extension GitHub.Repo {
  static let mock = GitHub.Repo(
    archived: false,
    description: "Blob's blog.",
    htmlUrl: URL(string: "https://www.pointfree.co")!,
    name: "Bloblog",
    pushedAt: .mock - .weeks(10)
  )
}

extension Locale {
  static let mock = Locale(identifier: "en_US")
}

extension NSError {
  static let mock = NSError(domain: "co.pointfree", code: 1, userInfo: [NSLocalizedDescriptionKey: "Oops!"])
}

extension Screen {
  static let mock = Screen(
    size: CGSize(width: 768, height: 1024)
  )
}

extension System {
  static let mock = System(
    name: "iOS",
    version: "11.4"
  )
}

extension Version {
  static let mock = Version(
    build: "1",
    release: "1.0.0"
  )
}

extension Environment {
  static let mock = Environment(
    analytics: .mock,
    calendar: .mock,
    date: { .mock },
    gitHub: .mock,
    locale: .mock,
    screen: .mock,
    system: .mock,
    version: .mock
  )
}

Current = .mock

let repos: [GitHub.Repo] = [
  with(.mock, set(\.archived, true)),
  with(.mock, concat(
    set(\GitHub.Repo.pushedAt, .mock - .weeks(2000)),
    set(\.name, "Bloblog 2.0"),
    set(\.description, "Blob's new blog")
  )),
  with(.mock, concat(
    set(\GitHub.Repo.pushedAt, .mock - .seconds(2)),
    set(\.name, "Bloblog 3.0"),
    set(\.description, "Blob's new, new blog")
  ))
]

with(&Current, concat(
  mut(\.calendar.locale, Locale(identifier: "zh_HK")),
  mut(\.locale, Locale(identifier: "zh_HK")),
  mut(\.gitHub.fetchRepos) { callback in
    callback(
      .success(repos)
//      .failure(NSError.mock)
    )
  }
))

Current.calendar.locale

//Current.gitHub.fetchRepos = { callback in
//  callback(.failure(NSError.init(domain: "co.pointfree", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ooops!"])))
//}

let reposViewController = ReposViewController()
//let reposViewController = ReposViewController.init(
//  date: { Date(timeIntervalSinceReferenceDate: 557152051) },
//  gitHub: GitHubMock.init(result: .failure(NSError.init(domain: "co.pointfree", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ooops!"])))
//)


import PlaygroundSupport
let vc = UINavigationController(rootViewController: reposViewController)
PlaygroundPage.current.liveView = vc
