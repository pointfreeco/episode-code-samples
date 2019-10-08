import ComposableArchitecture
import PrimeModal
import SwiftUI

public enum CounterAction {
  case decrTapped
  case incrTapped
}

public func counterReducer(state: inout Int, action: CounterAction) {
  switch action {
  case .decrTapped:
    state -= 1

  case .incrTapped:
    state += 1
  }
}

public let counterViewReducer = combine(
  pullback(counterReducer, value: \CounterViewState.count, action: \CounterViewAction.counter),
  pullback(primeModalReducer, value: \.self, action: \.primeModal)
)

struct PrimeAlert: Identifiable {
  let prime: Int
  var id: Int { self.prime }
}

public typealias CounterViewState = (count: Int, favoritePrimes: [Int])

public enum CounterViewAction {
  case counter(CounterAction)
  case primeModal(PrimeModalAction)

  var counter: CounterAction? {
    get {
      guard case let .counter(value) = self else { return nil }
      return value
    }
    set {
      guard case .counter = self, let newValue = newValue else { return }
      self = .counter(newValue)
    }
  }

  var primeModal: PrimeModalAction? {
    get {
      guard case let .primeModal(value) = self else { return nil }
      return value
    }
    set {
      guard case .primeModal = self, let newValue = newValue else { return }
      self = .primeModal(newValue)
    }
  }

}

public struct CounterView: View {
  @ObservedObject var store: Store<CounterViewState, CounterViewAction>
  @State var isPrimeModalShown = false
  @State var alertNthPrime: PrimeAlert?
  @State var isNthPrimeButtonDisabled = false

  public init(store: Store<CounterViewState, CounterViewAction>) {
    self.store = store
  }

  public var body: some View {
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
      IsPrimeModalView(
        store: self.store
          .view(
            value: { ($0.count, $0.favoritePrimes) },
            action: { .primeModal($0) }
        )
      )
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

func ordinal(_ n: Int) -> String {
  let formatter = NumberFormatter()
  formatter.numberStyle = .ordinal
  return formatter.string(for: n) ?? ""
}
