import ComposableArchitecture
import SwiftUI

public enum FavoritePrimesAction: Equatable {
  case deleteFavoritePrimes(IndexSet)
  case loadButtonTapped
  case loadedFavoritePrimes([Int])
  case saveButtonTapped
}

public func favoritePrimesReducer(state: inout [Int], action: FavoritePrimesAction) -> [Effect<FavoritePrimesAction>] {
  switch action {
  case let .deleteFavoritePrimes(indexSet):
    for index in indexSet {
      state.remove(at: index)
    }
    return [
    ]

  case let .loadedFavoritePrimes(favoritePrimes):
    state = favoritePrimes
    return []

  case .saveButtonTapped:
    return [
      Current.fileClient.save("favorite-primes.json", try! JSONEncoder().encode(state))
        .fireAndForget()
//      saveEffect(favoritePrimes: state)
    ]

  case .loadButtonTapped:
    return [
      Current.fileClient.load("favorite-primes.json")
        .compactMap { $0 }
        .decode(type: [Int].self, decoder: JSONDecoder())
        .catch { error in Empty(completeImmediately: true) }
        .map(FavoritePrimesAction.loadedFavoritePrimes)
//        .merge(with: Just(FavoritePrimesAction.loadedFavoritePrimes([2, 31])))
        .eraseToEffect()
//      loadEffect
//        .compactMap { $0 }
//        .eraseToEffect()
    ]
  }
}

// (Never) -> A

import Combine

extension Publisher where Output == Never, Failure == Never {
  func fireAndForget<A>() -> Effect<A> {
    return self.map(absurd).eraseToEffect()
  }
}


func absurd<A>(_ never: Never) -> A {}


struct FileClient {
  var load: (String) -> Effect<Data?>
  var save: (String, Data) -> Effect<Never>
}
extension FileClient {
  static let live = FileClient(
    load: { fileName -> Effect<Data?> in
      .sync {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsUrl = URL(fileURLWithPath: documentsPath)
        let favoritePrimesUrl = documentsUrl.appendingPathComponent(fileName)
        return try? Data(contentsOf: favoritePrimesUrl)
      }
  },
    save: { fileName, data in
      return .fireAndForget {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsUrl = URL(fileURLWithPath: documentsPath)
        let favoritePrimesUrl = documentsUrl.appendingPathComponent(fileName)
        try! data.write(to: favoritePrimesUrl)
      }
  }
  )
}

struct FavoritePrimesEnvironment {
  var fileClient: FileClient
}
extension FavoritePrimesEnvironment {
  static let live = FavoritePrimesEnvironment(fileClient: .live)
}

var Current = FavoritePrimesEnvironment.live

#if DEBUG
extension FavoritePrimesEnvironment {
  static let mock = FavoritePrimesEnvironment(
    fileClient: FileClient(
      load: { _ in Effect<Data?>.sync {
        try! JSONEncoder().encode([2, 31])
        } },
      save: { _, _ in .fireAndForget {} }
    )
  )
}
#endif

//struct Environment {
//  var date: () -> Date
//}
//extension Environment {
//  static let live = Environment(date: Date.init)
//}
//
//extension Environment {
//  static let mock = Environment(date: { Date.init(timeIntervalSince1970: 1234567890) })
//}
//
////Current = .mock
//
//struct GitHubClient {
//  var fetchRepos: (@escaping (Result<[Repo], Error>) -> Void) -> Void
//
//  struct Repo: Decodable {
//    var archived: Bool
//    var description: String?
//    var htmlUrl: URL
//    var name: String
//    var pushedAt: Date?
//  }
//}
//
//#if DEBUG
//var Current = Environment.live
//#else
//let Current = Environment.live
//#endif

//private func saveEffect(favoritePrimes: [Int]) -> Effect<FavoritePrimesAction> {
//  return .fireAndForget {
////    Current.date()
//    let data = try! JSONEncoder().encode(favoritePrimes)
//    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//    let documentsUrl = URL(fileURLWithPath: documentsPath)
//    let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
//    try! data.write(to: favoritePrimesUrl)
//  }
//}

//private let loadEffect = Effect<FavoritePrimesAction?>.sync {
//  let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//  let documentsUrl = URL(fileURLWithPath: documentsPath)
//  let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
//  guard
//    let data = try? Data(contentsOf: favoritePrimesUrl),
//    let favoritePrimes = try? JSONDecoder().decode([Int].self, from: data)
//    else { return nil }
//  return .loadedFavoritePrimes(favoritePrimes)
//}

public struct FavoritePrimesView: View {
  @ObservedObject var store: Store<[Int], FavoritePrimesAction>

  public init(store: Store<[Int], FavoritePrimesAction>) {
    self.store = store
  }

  public var body: some View {
    List {
      ForEach(self.store.value, id: \.self) { prime in
        Text("\(prime)")
      }
      .onDelete { indexSet in
        self.store.send(.deleteFavoritePrimes(indexSet))
      }
    }
    .navigationBarTitle("Favorite primes")
    .navigationBarItems(
      trailing: HStack {
        Button("Save") {
          self.store.send(.saveButtonTapped)
        }
        Button("Load") {
          self.store.send(.loadButtonTapped)
        }
      }
    )
  }
}
