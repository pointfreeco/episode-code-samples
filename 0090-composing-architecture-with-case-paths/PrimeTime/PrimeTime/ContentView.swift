import Combine
import CompArch
import Counter
import FavoritePrimes
import HistoryTransceiver
import SwiftUI

struct AppState: Codable {
  var count = 0
  var favoritePrimes: [Int] = []
  var loggedInUser: User? = nil
  var activityFeed: [Activity] = []
  var alertNthPrime: PrimeAlert? = nil
  var isNthPrimeButtonDisabled: Bool = false
  var isPrimeModalShown: Bool = false

  struct Activity: Codable {
    let timestamp: Date
    let type: ActivityType

    enum ActivityType {
      case addedFavoritePrime(Int)
      case removedFavoritePrime(Int)
    }
  }

  struct User: Codable {
    let id: Int
    let name: String
    let bio: String
  }
}

enum AppAction {
  case counterView(CounterViewAction)
  case favoritePrimes(FavoritePrimesAction)

//  var counterView: CounterViewAction? {
//    get {
//      guard case let .counterView(value) = self else { return nil }
//      return value
//    }
//    set {
//      guard case .counterView = self, let newValue = newValue else { return }
//      self = .counterView(newValue)
//    }
//  }
//
//  var favoritePrimes: FavoritePrimesAction? {
//    get {
//      guard case let .favoritePrimes(value) = self else { return nil }
//      return value
//    }
//    set {
//      guard case .favoritePrimes = self, let newValue = newValue else { return }
//      self = .favoritePrimes(newValue)
//    }
//  }
}

extension AppState {
  var counterView: CounterViewState {
    get {
      CounterViewState(
        alertNthPrime: self.alertNthPrime,
        count: self.count,
        favoritePrimes: self.favoritePrimes,
        isNthPrimeButtonDisabled: self.isNthPrimeButtonDisabled,
        isPrimeModalShown: self.isPrimeModalShown
      )
    }
    set {
      self.alertNthPrime = newValue.alertNthPrime
      self.count = newValue.count
      self.favoritePrimes = newValue.favoritePrimes
      self.isNthPrimeButtonDisabled = newValue.isNthPrimeButtonDisabled
      self.isPrimeModalShown = newValue.isPrimeModalShown
    }
  }
}

import CasePaths

let appReducer = combine(
  pullback(
    counterViewReducer,
    value: \AppState.counterView,
    action: /AppAction.counterView
  ),
  pullback(
    favoritePrimesReducer,
    value: \.favoritePrimes,
    action: /AppAction.favoritePrimes
  )
)

func activityFeed(
  _ reducer: @escaping Reducer<AppState, AppAction>
) -> Reducer<AppState, AppAction> {

  return { state, action in
    switch action {
    case .counterView(.counter),
         .favoritePrimes(.loadedFavoritePrimes),
         .favoritePrimes(.loadButtonTapped),
         .favoritePrimes(.saveButtonTapped):
      break
    case .counterView(.primeModal(.removeFavoritePrimeTapped)):
      state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.count)))

    case .counterView(.primeModal(.saveFavoritePrimeTapped)):
      state.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(state.count)))

    case let .favoritePrimes(.deleteFavoritePrimes(indexSet)):
      for index in indexSet {
        state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.favoritePrimes[index])))
      }
    }

    return reducer(&state, action)
  }
}

struct ContentView: View {
  @ObservedObject var store: Store<AppState, AppAction>

  var body: some View {
    NavigationView {
      List {
        NavigationLink(
          "Counter demo",
          destination: CounterView(
            store: self.store.view(
              value: { $0.counterView },
              action: { .counterView($0) }
            )
          )
        )
        NavigationLink(
          "Favorite primes",
          destination: FavoritePrimesView(
            store: self.store.view(
              value: { $0.favoritePrimes },
              action: { .favoritePrimes($0) }
            )
          )
        )
      }
      .navigationBarTitle("State management")
    }
  }
}


// MARK:- State Surfing


extension AppState: StateInitializable {}

extension ContentView: StateSurfable {
    typealias State = AppState
    typealias Action = AppAction

    static func body(store: Store<State, Action>) -> ContentView {
        ContentView(store: store)
    }
    static var reducer: (inout State, Action) -> [Effect<Action>] {
        with(
          appReducer,
          compose(
            logging,
            activityFeed
          )
        )
    }
}

extension AppState.Activity.ActivityType: Codable {
    enum DecodingError: Error {
        case keysNotFound
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(Int.self, forKey: .addedFavoritePrime) {
            self = .addedFavoritePrime(value)
            return
        }
        if let value = try? container.decode(Int.self, forKey: .removedFavoritePrime) {
            self = .removedFavoritePrime(value)
            return
        }
        throw DecodingError.keysNotFound
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
            case .addedFavoritePrime(let value):
                try container.encode(value, forKey: .addedFavoritePrime)
            case .removedFavoritePrime(let value):
                try container.encode(value, forKey: .removedFavoritePrime)
        }
    }

    enum CodingKeys: String, CodingKey {
        case addedFavoritePrime
        case removedFavoritePrime
    }
}
