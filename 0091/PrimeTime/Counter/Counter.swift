import CasePaths
import Combine
import ComposableArchitecture
import PrimeAlert
import PrimeModal
import SwiftUI

public enum CounterAction: Equatable {
  case decrTapped
  case incrTapped
  case requestNthPrime
  case nthPrimeResponse(n: Int, prime: Int?)
  case alertDismissButtonTapped
  case isPrimeButtonTapped
  case primeDetailDismissed
}

public typealias CounterState = (
  alertNthPrime: PrimeAlert?,
  count: Int,
  isNthPrimeRequestInFlight: Bool,
  isPrimeDetailShown: Bool
)

public func counterReducer(
  state: inout CounterState,
  action: CounterAction,
  environment: CounterEnvironment
) -> [Effect<CounterAction>] {
  switch action {
  case .decrTapped:
    state.count -= 1
//    let count = state.count
    return [
//      .fireAndForget {
//        print(count)
//      },
//
//      Just(CounterAction.incrTapped)
//        .delay(for: 1, scheduler: DispatchQueue.main)
//        .eraseToEffect()
    ]

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

//public struct CounterEnvironment {
//  var nthPrime: (Int) -> Effect<Int?>
//}

public typealias CounterEnvironment = (Int) -> Effect<Int?>

//extension CounterEnvironment {
//  public static let live = CounterEnvironment(nthPrime: Counter.nthPrime)
//}

//var Current = CounterEnvironment.live

//extension CounterEnvironment {
//  static let mock = CounterEnvironment(nthPrime: { _ in .sync { 17 }})
//}

public let counterViewReducer: Reducer<CounterViewState, CounterViewAction, CounterEnvironment> = combine(
  pullback(
    counterReducer,
    value: \CounterViewState.counter,
    action: /CounterViewAction.counter,
    environment: { $0 }
  ),
  pullback(
    primeModalReducer,
    value: \.primeModal,
    action: /CounterViewAction.primeModal,
    environment: { _ in () }
  )
)

public struct CounterViewState: Equatable {
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
