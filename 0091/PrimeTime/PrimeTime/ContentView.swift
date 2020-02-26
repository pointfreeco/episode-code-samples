import CasePaths
import Combine
import ComposableArchitecture
import Counter
import FavoritePrimes
import PrimeAlert
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

enum AppAction: Equatable {
  case counterView(CounterViewAction)
  case offlineCounterView(CounterViewAction)
  case favoritePrimes(FavoritePrimesAction)
}

extension AppState {
  var favoritePrimesState: FavoritePrimesState {
    get {
      (self.alertNthPrime, self.favoritePrimes)
    }
    set {
      (self.alertNthPrime, self.favoritePrimes) = newValue
    }
  }

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

//struct AppEnvironment {
//  var counter: CounterEnvironment
//  var favoritePrimes: FavoritePrimesEnvironment
//}

typealias AppEnvironment = (
  fileClient: FileClient,
  nthPrime: (Int) -> Effect<Int?>,
  offlineNthPrime: (Int) -> Effect<Int?>
)

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = combine(
  pullback(
    counterViewReducer,
    value: \AppState.counterView,
    action: /AppAction.counterView,
    environment: { $0.nthPrime }
  ),
  pullback(
    counterViewReducer,
    value: \AppState.counterView,
    action: /AppAction.offlineCounterView,
    environment: { $0.offlineNthPrime }
  ),
  pullback(
    favoritePrimesReducer,
    value: \.favoritePrimesState,
    action: /AppAction.favoritePrimes,
    environment: { ($0.fileClient, $0.nthPrime) }
  )
)

func activityFeed(
  _ reducer: @escaping Reducer<AppState, AppAction, AppEnvironment>
) -> Reducer<AppState, AppAction, AppEnvironment> {

  return { state, action, environment in
    switch action {
    case .counterView(.counter),
         .offlineCounterView(.counter),
         .favoritePrimes(.loadedFavoritePrimes),
         .favoritePrimes(.loadButtonTapped),
         .favoritePrimes(.saveButtonTapped),
         .favoritePrimes(.primeButtonTapped(_)),
         .favoritePrimes(.nthPrimeResponse),
         .favoritePrimes(.alertDismissButtonTapped):
      break
    case .counterView(.primeModal(.removeFavoritePrimeTapped)),
         .offlineCounterView(.primeModal(.removeFavoritePrimeTapped)):
      state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.count)))

    case .counterView(.primeModal(.saveFavoritePrimeTapped)),
         .offlineCounterView(.primeModal(.saveFavoritePrimeTapped)):
      state.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(state.count)))

    case let .favoritePrimes(.deleteFavoritePrimes(indexSet)):
      for index in indexSet {
        state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.favoritePrimes[index])))
      }
    }

    return reducer(&state, action, environment)
  }
}

let isInExperiment = false //Bool.random()

struct ContentView: View {
  @ObservedObject var store: Store<AppState, AppAction>
  
  init(store: Store<AppState, AppAction>) {
    print("ContentView.init")
    self.store = store
  }

  var body: some View {
    print("ContentView.body")
    return NavigationView {
      List {
        if !isInExperiment {
          NavigationLink(
            "Counter demo",
            destination: CounterView(
              store: self.store.view(
                value: { $0.counterView },
                action: { .counterView($0) }
              )
            )
          )
        } else {
          NavigationLink(
            "Offline counter demo",
            destination: CounterView(
              store: self.store.view(
                value: { $0.counterView },
                action: { .offlineCounterView($0) }
              )
            )
          )
        }
        NavigationLink(
          "Favorite primes",
          destination: FavoritePrimesView(
            store: self.store.view(
              value: { $0.favoritePrimesState },
              action: { .favoritePrimes($0) }
            )
          )
        )

        ForEach(Array(1...500_000), id: \.self) { value in
          Text("\(value)")
        }

      }
      .navigationBarTitle("State management")
    }
  }
}
