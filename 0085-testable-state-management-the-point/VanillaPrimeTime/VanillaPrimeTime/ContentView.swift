import Combine
import SwiftUI

class AppState: ObservableObject {
  @Published var count = 0
  @Published var favoritePrimes: [Int] = []
  @Published var loggedInUser: User? = nil
  @Published var activityFeed: [Activity] = []
  @Published var alertNthPrime: PrimeAlert? = nil
  @Published var isNthPrimeButtonDisabled = false

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

struct PrimeAlert: Identifiable {
  let prime: Int

  var id: Int { self.prime }
}

struct ContentView: View {
  @ObservedObject var state: AppState

  var body: some View {
    NavigationView {
      List {
        NavigationLink(destination: CounterView(state: self.state)) {
          Text("Counter demo")
        }
        NavigationLink(
          destination: FavoritePrimesView(
            favoritePrimes: self.$state.favoritePrimes,
            activityFeed: self.$state.activityFeed
          )
        ) {
          Text("Favorite primes")
        }
      }
      .navigationBarTitle("State management")
    }
  }
}

struct CounterView: View {
  @ObservedObject var state: AppState
  @State var isPrimeModalShown: Bool = false
//  @State var alertNthPrime: PrimeAlert?
//  @State var isNthPrimeButtonDisabled = false

  func decrementCount() { self.state.count -= 1 }
  func incrementCount() { self.state.count += 1 }

  var body: some View {
    VStack {
      HStack {
        Button(action: self.decrementCount) {
          Text("-")
        }
        Text("\(self.state.count)")
        Button(action: self.incrementCount) {
          Text("+")
        }
      }
      Button(action: { self.isPrimeModalShown = true }) {
        Text("Is this prime?")
      }
      Button(action: self.nthPrimeButtonAction) {
        Text("What is the \(ordinal(self.state.count)) prime?")
      }
      .disabled(self.state.isNthPrimeButtonDisabled)
    }
    .font(.title)
    .navigationBarTitle("Counter demo")
    .sheet(isPresented: self.$isPrimeModalShown) {
      IsPrimeModalView(
//        state: self.$state.isPrimeModalViewState
        activityFeed: self.$state.activityFeed,
        count: self.state.count,
        favoritePrimes: self.$state.favoritePrimes
      )
    }
    .alert(item: self.$state.alertNthPrime) { alert in
      Alert(
        title: Text("The \(ordinal(self.state.count)) prime is \(alert.prime)"),
        dismissButton: .default(Text("Ok"))
      )
    }
  }

  func nthPrimeButtonAction() {
    self.state.isNthPrimeButtonDisabled = true
    nthPrime(self.state.count) { prime in
      self.state.alertNthPrime = prime.map(PrimeAlert.init(prime:))
      self.state.isNthPrimeButtonDisabled = false
    }
  }
}


extension AppState {
  var isPrimeModalViewState: IsPrimeModalView.State {
    get {
      IsPrimeModalView.State(
        activityFeed: self.activityFeed,
        count: self.count,
        favoritePrimes: self.favoritePrimes
      )
    }
    set {
      (
        self.activityFeed,
        self.count,
        self.favoritePrimes
      ) = (
        newValue.activityFeed,
        newValue.count,
        newValue.favoritePrimes
      )
    }
  }
}


struct IsPrimeModalView: View {

  struct State {
    var activityFeed: [AppState.Activity]
    let count: Int
    var favoritePrimes: [Int]
  }
//  @Binding var state: State

  @Binding var activityFeed: [AppState.Activity]
  let count: Int
  @Binding var favoritePrimes: [Int]

  var body: some View {
    VStack {
      if isPrime(self.count) {
        Text("\(self.count) is prime 🎉")
        if self.favoritePrimes.contains(self.count) {
          Button(action: self.removeFavoritePrime) {
            Text("Remove from favorite primes")
          }
        } else {
          Button(action: self.saveFavoritePrime) {
            Text("Save to favorite primes")
          }
        }
      } else {
        Text("\(self.count) is not prime :(")
      }
    }
  }

  func removeFavoritePrime() {
    self.favoritePrimes.removeAll(where: { $0 == self.count })
    self.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(self.count)))
    self.activityFeed = []
  }

  func saveFavoritePrime() {
    self.favoritePrimes.append(self.count)
    self.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(self.count)))

  }
}

struct FavoritePrimesView: View {
//  struct
  @Binding var favoritePrimes: [Int]
  @Binding var activityFeed: [AppState.Activity]

  var body: some View {
    List {
      ForEach(self.favoritePrimes, id: \.self) { prime in
        Text("\(prime)")
      }
      .onDelete { indexSet in
        for index in indexSet {
          let prime = self.favoritePrimes[index]
          self.favoritePrimes.remove(at: index)
          self.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(prime)))
        }
      }
    }
    .navigationBarTitle(Text("Favorite Primes"))
    .navigationBarItems(
      trailing: HStack {
        Button("Save", action: self.saveFavoritePrimes)
        Button("Load", action: self.loadFavoritePrimes)
      }
    )
  }

  func saveFavoritePrimes() {
    let data = try! JSONEncoder().encode(self.favoritePrimes)
      let documentsPath = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        )[0]
      let documentsUrl = URL(fileURLWithPath: documentsPath)
      let favoritePrimesUrl = documentsUrl
        .appendingPathComponent("favorite-primes.json")
      try! data.write(to: favoritePrimesUrl)
  }

  func loadFavoritePrimes() {
    let documentsPath = NSSearchPathForDirectoriesInDomains(
      .documentDirectory, .userDomainMask, true
      )[0]
    let documentsUrl = URL(fileURLWithPath: documentsPath)
    let favoritePrimesUrl = documentsUrl
      .appendingPathComponent("favorite-primes.json")
    guard
      let data = try? Data(contentsOf: favoritePrimesUrl),
      let favoritePrimes = try? JSONDecoder().decode([Int].self, from: data)
      else { return }
    self.favoritePrimes = favoritePrimes
  }
}

private func ordinal(_ n: Int) -> String {
  let formatter = NumberFormatter()
  formatter.numberStyle = .ordinal
  return formatter.string(for: n) ?? ""
}

private func isPrime (_ p: Int) -> Bool {
  if p <= 1 { return false }
  if p <= 3 { return true }
  for i in 2...Int(sqrtf(Float(p))) {
    if p % i == 0 { return false }
  }
  return true
}
