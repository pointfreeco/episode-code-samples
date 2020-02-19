import ComposableArchitecture
import PrimeModal
import SwiftUI

public enum CounterAction: Equatable {
  case decrTapped
  case incrTapped
  case requestNthPrime
//  case nthPrimeButtonTapped
  case nthPrimeResponse(Int?)
  case alertDismissButtonTapped
  case isPrimeButtonTapped
  case primeModalDismissed
//  case doubleTap
}

public typealias CounterState = (
  alertNthPrime: PrimeAlert?,
  count: Int,
  isNthPrimeButtonDisabled: Bool,
  isPrimeModalShown: Bool
)

public func counterReducer(state: inout CounterState, action: CounterAction) -> [Effect<CounterAction>] {
  switch action {
  case .decrTapped:
    state.count -= 1
    return []

  case .incrTapped:
    state.count += 1
    return []

  case .requestNthPrime: //.nthPrimeButtonTapped, .doubleTap:
    state.isNthPrimeButtonDisabled = true
    return [
      Current.nthPrime(state.count)
        .map(CounterAction.nthPrimeResponse)
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
    ]

  case let .nthPrimeResponse(prime):
    state.alertNthPrime = prime.map(PrimeAlert.init(prime:))
    state.isNthPrimeButtonDisabled = false
    return []

  case .alertDismissButtonTapped:
    state.alertNthPrime = nil
    return []

  case .isPrimeButtonTapped:
    state.isPrimeModalShown = true
    return []

  case .primeModalDismissed:
    state.isPrimeModalShown = false
    return []
  }
}

struct CounterEnvironment {
  var nthPrime: (Int) -> Effect<Int?>
}

extension CounterEnvironment {
  static let live = CounterEnvironment(nthPrime: Counter.nthPrime)
}

var Current = CounterEnvironment.live

extension CounterEnvironment {
  static let mock = CounterEnvironment(nthPrime: { _ in .sync { 17 }})
}

import CasePaths

public let counterViewReducer = combine(
  pullback(
    counterReducer,
    value: \CounterViewState.counter,
    action: /CounterViewAction.counter
  ),
  pullback(
    primeModalReducer,
    value: \.primeModal,
    action: /CounterViewAction.primeModal
  )
)

public struct PrimeAlert: Equatable, Identifiable {
  let prime: Int
  public var id: Int { self.prime }
}

public struct CounterViewState: Equatable {
  public var alertNthPrime: PrimeAlert?
  public var count: Int
  public var favoritePrimes: [Int]
  public var isNthPrimeButtonDisabled: Bool
  public var isPrimeModalShown: Bool

  public init(
    alertNthPrime: PrimeAlert? = nil,
    count: Int = 0,
    favoritePrimes: [Int] = [],
    isNthPrimeButtonDisabled: Bool = false,
    isPrimeModalShown: Bool = false
  ) {
    self.alertNthPrime = alertNthPrime
    self.count = count
    self.favoritePrimes = favoritePrimes
    self.isNthPrimeButtonDisabled = isNthPrimeButtonDisabled
    self.isPrimeModalShown = isPrimeModalShown
  }

  var counter: CounterState {
    get { (self.alertNthPrime, self.count, self.isNthPrimeButtonDisabled, self.isPrimeModalShown) }
    set { (self.alertNthPrime, self.count, self.isNthPrimeButtonDisabled, self.isPrimeModalShown) = newValue }
  }

  var primeModal: PrimeModalState {
    get { (self.count, self.favoritePrimes) }
    set { (self.count, self.favoritePrimes) = newValue }
  }
}

public enum CounterViewAction: Equatable {
  case counter(CounterAction)
  case primeModal(PrimeModalAction)
}

extension Store where Value == CounterViewState, Action == CounterViewAction {
  var counterViewStore: ViewStore<CounterView.State, CounterView.Action> {
    self.view(
      value: { ($0.alertNthPrime, $0.count, $0.isNthPrimeButtonDisabled, $0.isPrimeModalShown) },
      action: counterViewAction,
      removeDuplicates: ==
    )
  }

  var primeModalStore: Store<PrimeModalState, PrimeModalAction> {
    self.scope(value: { $0.primeModal }, action: { .primeModal($0) })
  }
}

public struct CounterView: View {
  typealias State = (
    alertNthPrime: PrimeAlert?,
    count: Int,
    isNthPrimeButtonDisabled: Bool,
    isPrimeModalShown: Bool
  )
  enum Action {
    case decrTapped
    case incrTapped
    case nthPrimeButtonTapped
    case alertDismissButtonTapped
    case isPrimeButtonTapped
    case primeModalDismissed
    case doubleTap
  }
  var primeModalStore: Store<PrimeModalState, PrimeModalAction> {
    self.store.scope(value: { $0.primeModal }, action: { .primeModal($0) })
  }

  @ObservedObject var viewStore: ViewStore<State, Action>
  let store: Store<CounterViewState, CounterViewAction>

  public init(store: Store<CounterViewState, CounterViewAction>) {
    print("CounterView.init")
    self.store = store
    self.viewStore = store.counterViewStore
  }

  public var body: some View {
    print("CounterView.body")
    return VStack {
      HStack {
        Button("-") { self.viewStore.send(.decrTapped) }
        Text("\(self.viewStore.value.count)")
        Button("+") { self.viewStore.send(.incrTapped) }
      }
      Button("Is this prime?") { self.viewStore.send(.isPrimeButtonTapped) }
      Button("What is the \(ordinal(self.viewStore.value.count)) prime?") {
        self.viewStore.send(.nthPrimeButtonTapped)
      }
      .disabled(self.viewStore.value.isNthPrimeButtonDisabled)
    }
    .font(.title)
    .navigationBarTitle("Counter demo")
    .sheet(
      isPresented: .constant(self.viewStore.value.isPrimeModalShown),
      onDismiss: { self.viewStore.send(.primeModalDismissed) }
    ) {
      IsPrimeModalView(store: self.primeModalStore)
    }
    .alert(
      item: .constant(self.viewStore.value.alertNthPrime)
    ) { alert in
      Alert(
        title: Text("The \(ordinal(self.viewStore.value.count)) prime is \(alert.prime)"),
        dismissButton: .default(Text("Ok")) {
          self.viewStore.send(.alertDismissButtonTapped)
        }
      )
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//    .background(Color.white)
    .onTapGesture(count: 2) {
      self.viewStore.send(.doubleTap)
    }
  }
}

func ordinal(_ n: Int) -> String {
  let formatter = NumberFormatter()
  formatter.numberStyle = .ordinal
  return formatter.string(for: n) ?? ""
}

private func counterViewAction(for action: CounterView.Action) -> CounterViewAction {
  switch action {
  case .decrTapped:
    return .counter(.decrTapped)
  case .incrTapped:
    return .counter(.incrTapped)
  case .nthPrimeButtonTapped:
    return .counter(.requestNthPrime)
  case .alertDismissButtonTapped:
    return .counter(.alertDismissButtonTapped)
  case .isPrimeButtonTapped:
    return .counter(.isPrimeButtonTapped)
  case .primeModalDismissed:
    return .counter(.primeModalDismissed)
  case .doubleTap:
    return .counter(.requestNthPrime)
  }
}
