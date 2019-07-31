import Combine
import SwiftUI

struct AppState {
  var count = 0
  var favoritePrimes: [Int] = []
  var loggedInUser: User? = nil
  var activityFeed: [Activity] = []

  struct Activity {
    let timestamp: Date
    let type: ActivityType

    enum ActivityType {
      case addedFavoritePrime(Int)
      case removedFavoritePrime(Int)
    }
  }

  struct User {
    let id: Int
    let name: String
    let bio: String
  }
}

enum CounterAction {
  case decrTapped
  case incrTapped
}
enum PrimeModalAction {
  case saveFavoritePrimeTapped
  case removeFavoritePrimeTapped
}
enum FavoritePrimesAction {
  case deleteFavoritePrimes(IndexSet)
}
enum AppAction {
  case counter(CounterAction)
  case primeModal(PrimeModalAction)
  case favoritePrimes(FavoritePrimesAction)
}

// (A) -> A
// (inout A) -> Void

// (A, B) -> (A, C)
// (inout A, B) -> C

// (Value, Action) -> Value
// (inout Value, Action) -> Void

//[1, 2, 3].reduce(into: <#T##Result#>, <#T##updateAccumulatingResult: (inout Result, Int) throws -> ()##(inout Result, Int) throws -> ()#>)

func appReducer(value: inout AppState, action: AppAction) -> Void {
  switch action {
  case .counter(.decrTapped):
    value.count -= 1

  case .counter(.incrTapped):
    value.count += 1

  case .primeModal(.saveFavoritePrimeTapped):
    value.favoritePrimes.append(value.count)
    value.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(value.count)))

  case .primeModal(.removeFavoritePrimeTapped):
    value.favoritePrimes.removeAll(where: { $0 == value.count })
    value.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(value.count)))

  case let .favoritePrimes(.deleteFavoritePrimes(indexSet)):
    for index in indexSet {
      let prime = value.favoritePrimes[index]
      value.favoritePrimes.remove(at: index)
      value.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(prime)))
    }
  }
}

final class Store<Value, Action>: ObservableObject {
  let reducer: (inout Value, Action) -> Void
  @Published private(set) var value: Value

  init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
    self.reducer = reducer
    self.value = initialValue
  }

  func send(_ action: Action) {
    self.reducer(&self.value, action)
  }
}

// [1, 2, 3].reduce(<#T##initialResult: Result##Result#>, <#T##nextPartialResult: (Result, Int) throws -> Result##(Result, Int) throws -> Result#>)

var state = AppState()
//appReducer(state: &state, action: .incrTapped)
//appReducer(state: &state, action: .decrTapped)
//print(
//  counterReducer(
//    state: counterReducer(state: state, action: .incrTapped),
//    action: .decrTapped
//  )
//)
//counterReducer(state: state, action: .decrTapped)

// Store<AppState>

struct PrimeAlert: Identifiable {
  let prime: Int
  var id: Int { self.prime }
}

struct CounterView: View {
  @ObservedObject var store: Store<AppState, AppAction>
  @State var isPrimeModalShown = false
  @State var alertNthPrime: PrimeAlert?
  @State var isNthPrimeButtonDisabled = false

  var body: some View {
    VStack {
      HStack {
        Button("-") { self.store.send(.counter(.decrTapped)) }
        Text("\(self.store.value.count)")
        Button("+") { self.store.send(.counter(.incrTapped)) }
      }
      Button("Is this prime?") { self.isPrimeModalShown = true }
      Button(
        "What is the \(ordinal(self.store.value.count)) prime?",
        action: self.nthPrimeButtonAction
      )
      .disabled(self.isNthPrimeButtonDisabled)
    }
    .font(.title)
    .navigationBarTitle("Counter demo")
    .sheet(isPresented: self.$isPrimeModalShown) {
      IsPrimeModalView(store: self.store)
    }
    .alert(item: self.$alertNthPrime) { alert in
      Alert(
        title: Text("The \(ordinal(self.store.value.count)) prime is \(alert.prime)"),
        dismissButton: .default(Text("Ok"))
      )
    }
  }

  func nthPrimeButtonAction() {
    self.isNthPrimeButtonDisabled = true
    nthPrime(self.store.value.count) { prime in
      self.alertNthPrime = prime.map(PrimeAlert.init(prime:))
      self.isNthPrimeButtonDisabled = false
    }
  }
}

struct IsPrimeModalView: View {
  @ObservedObject var store: Store<AppState, AppAction>

  var body: some View {
    VStack {
      if isPrime(self.store.value.count) {
        Text("\(self.store.value.count) is prime 🎉")
        if self.store.value.favoritePrimes.contains(self.store.value.count) {
          Button("Remove from favorite primes") {
            self.store.send(.primeModal(.removeFavoritePrimeTapped))
          }
        } else {
          Button("Save to favorite primes") {
            self.store.send(.primeModal(.saveFavoritePrimeTapped))
          }
        }
      } else {
        Text("\(self.store.value.count) is not prime :(")
      }
    }
  }
}

struct FavoritePrimesView: View {
  @ObservedObject var store: Store<AppState, AppAction>

  var body: some View {
    List {
      ForEach(self.store.value.favoritePrimes, id: \.self) { prime in
        Text("\(prime)")
      }
      .onDelete { indexSet in
        self.store.send(.favoritePrimes(.deleteFavoritePrimes(indexSet)))
      }
    }
    .navigationBarTitle("Favorite Primes")
  }
}

struct ContentView: View {
  @ObservedObject var store: Store<AppState, AppAction>

  var body: some View {
    NavigationView {
      List {
        NavigationLink(
          "Counter demo",
          destination: CounterView(store: self.store)
        )
        NavigationLink(
          "Favorite primes",
          destination: FavoritePrimesView(store: self.store)
        )
      }
      .navigationBarTitle("State management")
    }
  }
}

import PlaygroundSupport
PlaygroundPage.current.liveView = UIHostingController(
  rootView: ContentView(
    store: Store(initialValue: AppState(), reducer: appReducer)
  )
)
