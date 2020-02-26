import CasePaths
import Combine
import ComposableArchitecture
import PrimeAlert
import PrimeModal
import SwiftUI

public typealias CounterState = (
  alertNthPrime: PrimeAlert?,
  count: Int,
  isNthPrimeRequestInFlight: Bool,
  isPrimeModalShown: Bool
)

public enum CounterAction: Equatable {
  case decrTapped
  case incrTapped
//  case nthPrimeButtonTapped
  case requestNthPrime
  case nthPrimeResponse(n: Int, prime: Int?)
  case alertDismissButtonTapped
  case isPrimeButtonTapped
  case primeModalDismissed
//  case doubleTap
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

  case .requestNthPrime:
    state.isNthPrimeRequestInFlight = true
    let n = state.count
    return [
      environment(state.count)
        .map { CounterAction.nthPrimeResponse(n: n, prime: $0) }
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
    ]

  case let .nthPrimeResponse(n, prime):
    state.alertNthPrime = prime.map { PrimeAlert(n: n, prime: $0) }
    state.isNthPrimeRequestInFlight = false
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
    
//  case .doubleTap:
//        state.isNthPrimeRequestInFlight = true
//    let n = state.count
//    return [
//      environment(state.count)
//        .map { CounterAction.nthPrimeResponse(n: n, prime: $0) }
//        .receive(on: DispatchQueue.main)
//        .eraseToEffect()
//    ]
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
//  public var isNthPrimeButtonDisabled: Bool
  public var isNthPrimeRequestInFlight: Bool
  public var isPrimeModalShown: Bool
  
//  public var isLoadingIndicatorHidden: Bool

  public init(
    alertNthPrime: PrimeAlert? = nil,
    count: Int = 0,
    favoritePrimes: [Int] = [],
    isNthPrimeRequestInFlight: Bool = false,
    isPrimeModalShown: Bool = false
  ) {
    self.alertNthPrime = alertNthPrime
    self.count = count
    self.favoritePrimes = favoritePrimes
    self.isNthPrimeRequestInFlight = isNthPrimeRequestInFlight
    self.isPrimeModalShown = isPrimeModalShown
  }

  var counter: CounterState {
    get { (self.alertNthPrime, self.count, self.isNthPrimeRequestInFlight, self.isPrimeModalShown) }
    set { (self.alertNthPrime, self.count, self.isNthPrimeRequestInFlight, self.isPrimeModalShown) = newValue }
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
    let isIncrementButtonDisabled: Bool
    let isDecrementButtonDisabled: Bool
    let nthPrimeButtonTitle: String
  }
  public enum Action {
    case decrTapped
    case incrTapped
    case nthPrimeButtonTapped
    case alertDismissButtonTapped
    case isPrimeButtonTapped
    case primeModalDismissed
    case doubleTap
  }
  
  let store: Store<CounterFeatureState, CounterFeatureAction>
  @ObservedObject var viewStore: ViewStore<State, Action>

  public init(store: Store<CounterFeatureState, CounterFeatureAction>) {
    print("CounterView.init")
    self.store = store
    self.viewStore = self.store
      .scope(
        value: State.init,
        action: CounterFeatureAction.init
    )
      .view
  }

  public var body: some View {
    print("CounterView.body")
    return VStack {
      HStack {
        Button("-") { self.viewStore.send(.decrTapped) }
          .disabled(self.viewStore.value.isDecrementButtonDisabled)
        Text("\(self.viewStore.value.count)")
        Button("+") { self.viewStore.send(.incrTapped) }
          .disabled(self.viewStore.value.isIncrementButtonDisabled)
      }
      Button("Is this prime?") { self.viewStore.send(.isPrimeButtonTapped) }
      Button(self.viewStore.value.nthPrimeButtonTitle) {
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
          self.viewStore.send(.alertDismissButtonTapped)
        }
      )
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    .background(Color.white)
    .onTapGesture(count: 2) {
      self.viewStore.send(.doubleTap)
    }
  }
}

extension CounterView.State {
  init(counterFeatureState: CounterFeatureState) {
    self.alertNthPrime = counterFeatureState.alertNthPrime
    self.count = counterFeatureState.count
    self.isNthPrimeButtonDisabled = counterFeatureState.isNthPrimeRequestInFlight
    self.isPrimeModalShown = counterFeatureState.isPrimeModalShown
    self.isIncrementButtonDisabled = counterFeatureState.isNthPrimeRequestInFlight
    self.isDecrementButtonDisabled = counterFeatureState.isNthPrimeRequestInFlight
    self.nthPrimeButtonTitle = "What is the \(ordinal(counterFeatureState.count)) prime?"
  }
}

extension CounterFeatureAction {
  init(action: CounterView.Action) {
    switch action {
    case .decrTapped:
      self = .counter(.decrTapped)
    case .incrTapped:
      self = .counter(.incrTapped)
    case .nthPrimeButtonTapped:
      self = .counter(.requestNthPrime)
    case .alertDismissButtonTapped:
      self = .counter(.alertDismissButtonTapped)
    case .isPrimeButtonTapped:
      self = .counter(.isPrimeButtonTapped)
    case .primeModalDismissed:
      self = .counter(.primeModalDismissed)
    case .doubleTap:
      self = .counter(.requestNthPrime)
    }
  }
}
