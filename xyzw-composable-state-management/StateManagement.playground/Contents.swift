
import SwiftUI


struct WolframAlphaResult: Decodable {
  let queryresult: QueryResult

  struct QueryResult: Decodable {
    let pods: [Pod]

    struct Pod: Decodable {
      let primary: Bool?
      let subpods: [SubPod]

      struct SubPod: Decodable {
        let plaintext: String
      }
    }
  }
}


func wolframAlpha(query: String, callback: @escaping (WolframAlphaResult?) -> Void) -> Void {
  var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
  components.queryItems = [
    URLQueryItem(name: "input", value: query),
    URLQueryItem(name: "format", value: "plaintext"),
    URLQueryItem(name: "output", value: "JSON"),
    URLQueryItem(name: "appid", value: wolframAlphaApiKey),
  ]

  URLSession.shared.dataTask(with: components.url(relativeTo: nil)!) { data, response, error in
    callback(
      data
        .flatMap { try? JSONDecoder().decode(WolframAlphaResult.self, from: $0) }
    )
  }
  .resume()
}


func nthPrime(_ n: Int, callback: @escaping (Int?) -> Void) -> Void {
  wolframAlpha(query: "prime \(n)") { result in
    callback(
      result
        .flatMap {
          $0.queryresult
            .pods
            .first(where: { $0.primary == .some(true) })?
            .subpods
            .first?
            .plaintext
      }
      .flatMap(Int.init)
    )
  }
}

//nthPrime(1_000_000) { p in
//  print(p)
//}


struct ContentView: View {
  @ObjectBinding var store: Store<AppState, AppAction>

  var body: some View {
    NavigationView {
      List {
        NavigationLink(destination: CounterView(store: self.store)) {
          Text("Counter demo")
        }
        NavigationLink(destination: FavoritePrimesView(store: self.store)) {
          Text("Favorite primes")
        }
      }
      .navigationBarTitle("State management")
    }
  }
}

private func ordinal(_ n: Int) -> String {
  let formatter = NumberFormatter()
  formatter.numberStyle = .ordinal
  return formatter.string(for: n) ?? ""
}

//BindableObject

import Combine

class Store<Value, Action>: BindableObject {
  let reducer: (inout Value, Action) -> Void
  let willChange = PassthroughSubject<Void, Never>()

  var value: Value {
    willSet {
      self.willChange.send()
    }
  }

  init(value: Value, reducer: @escaping (inout Value, Action) -> Void) {
    self.value = value
    self.reducer = reducer
  }

  func send(_ action: Action) {
    self.reducer(&self.value, action)
  }
}

enum AppAction {
  case counter(CounterAction)
  case primeModal(PrimeModalAction)
  case favoritePrimes(FavoritePrimesAction)
}

enum CounterAction {
  case decrTapped
  case incrTapped
}

enum PrimeModalAction {
  case addFavoritePrime
  case removeFavoritePrime
}

enum FavoritePrimesAction {
  case removeFavoritePrimes(at: IndexSet)
}

func appReducer(value: inout AppState, action: AppAction) -> Void {
  switch action {
  case .counter(.decrTapped):
    value.count -= 1

  case .counter(.incrTapped):
    value.count += 1

  case .primeModal(.addFavoritePrime):
    value.favoritePrimes.append(value.count)
    value.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(value.count)))

  case .primeModal(.removeFavoritePrime):
    value.favoritePrimes.removeAll(where: { $0 == value.count })
    value.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(value.count)))

  case let .favoritePrimes(.removeFavoritePrimes(indexSet)):
    for index in indexSet {
      let prime = value.favoritePrimes[index]
      value.favoritePrimes.remove(at: index)
      value.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(prime)))
    }
  }
}

struct AppState {
  var count = 0
  var favoritePrimes: [Int] = []
  var loggedInUser: User?
  var activityFeed: [Activity] = []

  var willChange = PassthroughSubject<Void, Never>()

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

struct CounterView: View {
  @ObjectBinding var store: Store<AppState, AppAction>
  @State var isPrimeModalShown: Bool = false
  @State var alertNthPrime: Int?
  @State var isNthPrimeButtonDisabled = false

  var body: some View {
    VStack {
      HStack {
        Button(action: {
          self.store.send(.counter(.decrTapped))
          //          self.store.value = counterReducer(value: self.store.value, action: .decrTapped)
          //self.store.value.count -= 1
        }) {
          Text("-")
        }
        Text("\(self.store.value.count)")
        Button(action: {
          self.store.send(.counter(.incrTapped))
          //          self.store.value = counterReducer(value: self.store.value, action: .incrTapped)
          //self.store.value.count += 1
        }) {
          Text("+")
        }
      }
      Button(action: { self.isPrimeModalShown = true }) {
        Text("Is this prime?")
      }
      Button(action: self.nthPrimeButtonAction) {
        Text("What is the \(ordinal(self.store.value.count)) prime?")
      }
      .disabled(self.isNthPrimeButtonDisabled)
    }
    .font(.title)
      .navigationBarTitle("Counter demo")
      .sheet(isPresented: self.$isPrimeModalShown) {
        IsPrimeModalView(store: self.store)
    }
    .alert(item: self.$alertNthPrime) { n in
      Alert(
        title: Text("The \(ordinal(self.store.value.count)) prime is \(n)"),
        dismissButton: .default(Text("Ok"))
      )
    }
  }

  func nthPrimeButtonAction() {
    self.isNthPrimeButtonDisabled = true
    nthPrime(self.store.value.count) { prime in
      self.alertNthPrime = prime
      self.isNthPrimeButtonDisabled = false
    }
  }
}

private func isPrime (_ p: Int) -> Bool {
  if p <= 1 { return false }
  if p <= 3 { return true }
  for i in 2...Int(sqrtf(Float(p))) {
    if p % i == 0 { return false }
  }
  return true
}

struct IsPrimeModalView: View {
  @ObjectBinding var store: Store<AppState, AppAction>

  var body: some View {
    VStack {
      if isPrime(self.store.value.count) {
        Text("\(self.store.value.count) is prime 🎉")
        if self.store.value.favoritePrimes.contains(self.store.value.count) {
          Button(action: {
            self.store.send(.primeModal(.removeFavoritePrime))
            //            self.store.value.favoritePrimes.removeAll(where: { $0 == self.store.value.count })
            //            self.store.value.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(self.store.value.count)))
          }) {
            Text("Remove from favorite primes")
          }
        } else {
          Button(action: {
            self.store.send(.primeModal(.addFavoritePrime))
            //            self.store.value.favoritePrimes.append(self.store.value.count)
            //            self.store.value.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(self.store.value.count)))
          }) {
            Text("Save to favorite primes")
          }
        }

      } else {
        Text("\(self.store.value.count) is not prime :(")
      }

    }
  }
}

struct FavoritePrimesView: View {
  @ObjectBinding var store: Store<AppState, AppAction>

  var body: some View {
    List {
      ForEach(self.store.value.favoritePrimes) { prime in
        Text("\(prime)")
      }
      .onDelete { indexSet in
        self.store.send(.favoritePrimes(.removeFavoritePrimes(at: indexSet)))
        for index in indexSet {
          let prime = self.store.value.favoritePrimes[index]
          self.store.value.favoritePrimes.remove(at: index)
          self.store.value.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(prime)))
        }
      }
    }
    .navigationBarTitle(Text("Favorite Primes"))
  }
}


import PlaygroundSupport

PlaygroundPage.current.liveView = UIHostingController(
  rootView: ContentView(store: Store(value: AppState(), reducer: appReducer))
  //  rootView: CounterView()
)
