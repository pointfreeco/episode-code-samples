import UIKit
import SafariServices

enum Result<Value, Error> {
  case success(Value)
  case failure(Error)
}
//
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
          "build": Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown",
          "release": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown",
          "screen_height": String(describing: UIScreen.main.bounds.height),
          "screen_width": String(describing: UIScreen.main.bounds.width),
          "system_name": UIDevice.current.systemName,
          "system_version": UIDevice.current.systemVersion,
          ]
      )
    }
  }

  var track = track(_:)
}

private func track(_ event: Analytics.Event) {
  print("Tracked", event)
}

struct Environment {
  var analytics = Analytics()
  var date: () -> Date = Date.init
  var gitHub = GitHub()
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
            .filter { !$0.archived }
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
    dateComponentsFormatter.allowedUnits = [.day, .hour, .minute, .second]
    dateComponentsFormatter.maximumUnitCount = 1
    dateComponentsFormatter.unitsStyle = .abbreviated

    let label = UILabel()
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

extension Environment {
  static let mock = Environment(
    analytics: .mock,
    date: { Date(timeIntervalSinceReferenceDate: 557152051) },
    gitHub: .mock
  )
}

//Current = .mock

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
