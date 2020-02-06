import ComposableArchitecture
import PrimeAlert
import SwiftUI

public enum FavoritePrimesAction: Equatable {
  case deleteFavoritePrimes(IndexSet)
  case loadButtonTapped
  case loadedFavoritePrimes([Int])
  case saveButtonTapped
  case primeButtonTapped(Int)
  case nthPrimeResponse(n: Int, prime: Int?)
  case alertDismissButtonTapped
}

public typealias FavoritePrimesState = (
  alertNthPrime: PrimeAlert?,
  favoritePrimes: [Int]
)

public func favoritePrimesReducer(state: inout FavoritePrimesState, action: FavoritePrimesAction, environment: FavoritePrimesEnvironment
) -> [Effect<FavoritePrimesAction>] {
  switch action {
  case let .deleteFavoritePrimes(indexSet):
    for index in indexSet {
      state.favoritePrimes.remove(at: index)
    }
    return [
    ]

  case let .loadedFavoritePrimes(favoritePrimes):
    state.favoritePrimes = favoritePrimes
    return []

  case .saveButtonTapped:
    return [
      environment.fileClient.save("favorite-primes.json", try! JSONEncoder().encode(state.favoritePrimes))
        .fireAndForget()
//      saveEffect(favoritePrimes: state)
    ]

  case .loadButtonTapped:
    return [
      environment.fileClient.load("favorite-primes.json")
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

  case let .primeButtonTapped(prime):
    return [
      environment.nthPrime(prime)
        .receive(on: DispatchQueue.main)
        .map { FavoritePrimesAction.nthPrimeResponse(n: prime, prime: $0) }
        .eraseToEffect()
    ]

  case let .nthPrimeResponse(n, prime):
    state.alertNthPrime = prime.map { PrimeAlert(n: n, prime: $0) }
    return []

  case .alertDismissButtonTapped:
    state.alertNthPrime = nil
    return []
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


public struct FileClient {
  var load: (String) -> Effect<Data?>
  var save: (String, Data) -> Effect<Never>
}
extension FileClient {
  public static let live = FileClient(
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

public typealias FavoritePrimesEnvironment = (
  fileClient: FileClient,
  nthPrime: (Int) -> Effect<Int?>
)

#if DEBUG
extension FileClient {
  static let mock = FileClient(
    load: { _ in Effect<Data?>.sync {
      try! JSONEncoder().encode([2, 31])
      } },
    save: { _, _ in .fireAndForget {} }
  )
}
#endif


public struct FavoritePrimesView: View {
  @ObservedObject var store: Store<FavoritePrimesState, FavoritePrimesAction>

  public init(store: Store<FavoritePrimesState, FavoritePrimesAction>) {
    self.store = store
  }

  public var body: some View {
    List {
      ForEach(self.store.value.favoritePrimes, id: \.self) { prime in
        Button("\(prime)") {
          self.store.send(.primeButtonTapped(prime))
        }
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
      .alert(
        item: .constant(self.store.value.alertNthPrime)
      ) { alert in
        Alert(
          title: Text(alert.title),
          dismissButton: .default(Text("Ok")) {
            self.store.send(.alertDismissButtonTapped)
          }
        )
    }
  }
}
