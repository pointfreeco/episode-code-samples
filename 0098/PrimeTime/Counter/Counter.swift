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
  isPrimeDetailShown: Bool
)

public enum CounterAction: Equatable {
  case decrTapped
  case incrTapped
  case requestNthPrime
  case nthPrimeResponse(n: Int, prime: Int?)
  case alertDismissButtonTapped
  case isPrimeButtonTapped
  case primeDetailDismissed
}

public typealias CounterEnvironment = (Int) -> Effect<Int?>

//public func counterReducer(
//  state: inout CounterState,
//  action: CounterAction,
//  environment: CounterEnvironment
//) -> [Effect<CounterAction>] {
public let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> { state, action, environment in
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
    state.isPrimeDetailShown = true
    return []

  case .primeDetailDismissed:
    state.isPrimeDetailShown = false
    return []
  }
}
.logging()

public let counterFeatureReducer = Reducer.combine(
  counterReducer.pullback(
    value: \CounterFeatureState.counter,
    action: /CounterFeatureAction.counter,
    environment: { $0 }
  ),
  primeModalReducer.pullback(
    value: \.primeModal,
    action: /CounterFeatureAction.primeModal,
    environment: { _ in () }
  )
)

public struct CounterFeatureState: Equatable {
  public var alertNthPrime: PrimeAlert?
  public var count: Int
  public var favoritePrimes: [Int]
  public var isNthPrimeRequestInFlight: Bool
  public var isPrimeDetailShown: Bool
  
  public init(
    alertNthPrime: PrimeAlert? = nil,
    count: Int = 0,
    favoritePrimes: [Int] = [],
    isNthPrimeRequestInFlight: Bool = false,
    isPrimeDetailShown: Bool = false
  ) {
    self.alertNthPrime = alertNthPrime
    self.count = count
    self.favoritePrimes = favoritePrimes
    self.isNthPrimeRequestInFlight = isNthPrimeRequestInFlight
    self.isPrimeDetailShown = isPrimeDetailShown
  }

  var counter: CounterState {
    get { (self.alertNthPrime, self.count, self.isNthPrimeRequestInFlight, self.isPrimeDetailShown) }
    set { (self.alertNthPrime, self.count, self.isNthPrimeRequestInFlight, self.isPrimeDetailShown) = newValue }
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
