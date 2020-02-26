import CasePaths
import Combine
import ComposableArchitecture
import PrimeAlert
import PrimeModal
import SwiftUI

public typealias CounterState = (
  alertNthPrime: PrimeAlert?,
  count: Int,
  isNthPrimeButtonDisabled: Bool,
  isPrimeModalShown: Bool
)

public enum CounterAction: Equatable {
  case decrTapped
  case incrTapped
  case nthPrimeButtonTapped
  case nthPrimeResponse(n: Int, prime: Int?)
  case alertDismissButtonTapped
  case isPrimeButtonTapped
  case primeModalDismissed
}

public typealias CounterEnvironment = (Int) -> Effect<Int?>

public func counterReducer(
  state: inout CounterState,
  action: CounterAction,
  environment: CounterEnvironment
) -> [Effect<CounterAction>] {
  switch action {
  case .decrTapped:
    state.count -= 1
    return []

  case .incrTapped:
    state.count += 1
    return []

  case .nthPrimeButtonTapped:
    state.isNthPrimeButtonDisabled = true
    let n = state.count
    return [
      environment(state.count)
        .map { CounterAction.nthPrimeResponse(n: n, prime: $0) }
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
    ]

  case let .nthPrimeResponse(n, prime):
    state.alertNthPrime = prime.map { PrimeAlert(n: n, prime: $0) }
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

public let counterViewReducer: Reducer<CounterFeatureState, CounterFeatureAction, CounterEnvironment> = combine(
  pullback(
    counterReducer,
    value: \CounterFeatureState.counter,
    action: /CounterFeatureAction.counter,
    environment: { $0 }
  ),
  pullback(
    primeModalReducer,
    value: \.primeModal,
    action: /CounterFeatureAction.primeModal,
    environment: { _ in () }
  )
)

public struct CounterFeatureState: Equatable {
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

public enum CounterFeatureAction: Equatable {
  case counter(CounterAction)
  case primeModal(PrimeModalAction)
}

public struct CounterView: View {
  struct State: Equatable {
    let alertNthPrime: PrimeAlert?
    let count: Int
    let isNthPrimeButtonDisabled: Bool
    let isPrimeModalShown: Bool
  }
  let store: Store<CounterFeatureState, CounterFeatureAction>
  @ObservedObject var viewStore: ViewStore<State>

  public init(store: Store<CounterFeatureState, CounterFeatureAction>) {
    print("CounterView.init")
    self.store = store
    self.viewStore = self.store
      .scope(value: State.init(counterFeatureState:), action: { $0 })
      .view
  }

  public var body: some View {
    print("CounterView.body")
    return VStack {
      HStack {
        Button("-") { self.store.send(.counter(.decrTapped)) }
        Text("\(self.viewStore.value.count)")
        Button("+") { self.store.send(.counter(.incrTapped)) }
      }
      Button("Is this prime?") { self.store.send(.counter(.isPrimeButtonTapped)) }
      Button("What is the \(ordinal(self.viewStore.value.count)) prime?") {
        self.store.send(.counter(.nthPrimeButtonTapped))
      }
      .disabled(self.viewStore.value.isNthPrimeButtonDisabled)
    }
    .font(.title)
    .navigationBarTitle("Counter demo")
    .sheet(
      isPresented: .constant(self.viewStore.value.isPrimeModalShown),
      onDismiss: { self.store.send(.counter(.primeModalDismissed)) }
    ) {
      IsPrimeModalView(
        store: self.store.scope(
          value: { ($0.count, $0.favoritePrimes) },
          action: { .primeModal($0) }
        )
      )
    }
    .alert(
      item: .constant(self.viewStore.value.alertNthPrime)
    ) { alert in
      Alert(
        title: Text(alert.title),
        dismissButton: .default(Text("Ok")) {
          self.store.send(.counter(.alertDismissButtonTapped))
        }
      )
    }
  }
}

extension CounterView.State {
  init(counterFeatureState: CounterFeatureState) {
    self.alertNthPrime = counterFeatureState.alertNthPrime
    self.count = counterFeatureState.count
    self.isNthPrimeButtonDisabled = counterFeatureState.isNthPrimeButtonDisabled
    self.isPrimeModalShown = counterFeatureState.isPrimeModalShown
  }
}
