import Combine
import ComposableArchitecture
import Counter
import FavoritePrimes
import SwiftUI

struct AppState: Equatable {
  var count = 0
  var favoritePrimes: [Int] = []
  var loggedInUser: User? = nil
  var activityFeed: [Activity] = []
  var alertNthPrime: PrimeAlert? = nil
  var isNthPrimeButtonDisabled: Bool = false
  var isPrimeModalShown: Bool = false

  struct Activity: Equatable {
    let timestamp: Date
    let type: ActivityType

    enum ActivityType: Equatable {
      case addedFavoritePrime(Int)
      case removedFavoritePrime(Int)
    }
  }

  struct User: Equatable {
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
  let store: Store<AppState, AppAction>

  init(store: Store<AppState, AppAction>) {
    print("ContentView.init")
    self.store = store
  }

  var body: some View {
    print("ContentView.body")
    return NavigationView {
      List {
        NavigationLink(
          "Counter demo",
          destination: CounterView(
            store: self.store.scope(
              value: { $0.counterView },
              action: { .counterView($0) }
            )
          )
        )
        NavigationLink(
          "Favorite primes",
          destination: FavoritePrimesView(
            store: self.store.scope(
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
