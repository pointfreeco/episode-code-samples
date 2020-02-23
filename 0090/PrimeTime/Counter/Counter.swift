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

public struct IsPrimeDetail: Equatable, Identifiable {
  let count: Int
  public var id: Int { self.count }
}

public typealias CounterState = (
  alertNthPrime: PrimeAlert?,
  count: Int,
  isNthPrimeRequestInFlight: Bool,
  isPrimeModalShown: Bool,
  isPrimeDetail: IsPrimeDetail?
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
    state.isNthPrimeRequestInFlight = true
    return [
      Current.nthPrime(state.count)
        .map(CounterAction.nthPrimeResponse)
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
    ]

  case let .nthPrimeResponse(prime):
    state.alertNthPrime = prime.map(PrimeAlert.init(prime:))
    state.isNthPrimeRequestInFlight = false
    return []

  case .alertDismissButtonTapped:
    state.alertNthPrime = nil
    return []

  case .isPrimeButtonTapped:
    state.isPrimeDetail = IsPrimeDetail(count: state.count)
//    state.isPrimeModalShown = true
    return []

  case .primeModalDismissed:
    state.isPrimeDetail = nil
//    state.isPrimeModalShown = false
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
  public var isNthPrimeRequestInFlight: Bool
  public var isPrimeModalShown: Bool
  public var isPrimeDetail: IsPrimeDetail?

  public init(
    alertNthPrime: PrimeAlert? = nil,
    count: Int = 0,
    favoritePrimes: [Int] = [],
    isNthPrimeRequestInFlight: Bool = false,
    isPrimeModalShown: Bool = false,
    isPrimeDetail: IsPrimeDetail? = nil
  ) {
    self.alertNthPrime = alertNthPrime
    self.count = count
    self.favoritePrimes = favoritePrimes
    self.isNthPrimeRequestInFlight = isNthPrimeRequestInFlight
    self.isPrimeModalShown = isPrimeModalShown
    self.isPrimeDetail = isPrimeDetail
  }

  var counter: CounterState {
    get { (self.alertNthPrime, self.count, self.isNthPrimeRequestInFlight, self.isPrimeModalShown, self.isPrimeDetail) }
    set { (self.alertNthPrime, self.count, self.isNthPrimeRequestInFlight, self.isPrimeModalShown, self.isPrimeDetail) = newValue }
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

func ordinal(_ n: Int) -> String {
  let formatter = NumberFormatter()
  formatter.numberStyle = .ordinal
  return formatter.string(for: n) ?? ""
}
