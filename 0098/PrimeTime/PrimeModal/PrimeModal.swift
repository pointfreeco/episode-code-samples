import ComposableArchitecture
import SwiftUI

public typealias PrimeModalState = (count: Int, favoritePrimes: [Int])

public enum PrimeModalAction: Equatable {
  case saveFavoritePrimeTapped
  case removeFavoritePrimeTapped
}

//public func primeModalReducer(
//  state: inout PrimeModalState,
//  action: PrimeModalAction,
//  environment: Void
//) -> [Effect<PrimeModalAction>] {
public let primeModalReducer = Reducer<PrimeModalState, PrimeModalAction, Void> { state, action, _ in
  switch action {
  case .removeFavoritePrimeTapped:
    state.favoritePrimes.removeAll(where: { $0 == state.count })
    return []

  case .saveFavoritePrimeTapped:
    state.favoritePrimes.append(state.count)
    return []
  }
}

public struct IsPrimeModalView: View {
  struct State: Equatable {
    let count: Int
    let isFavorite: Bool
  }
  
  let store: Store<PrimeModalState, PrimeModalAction>
  @ObservedObject var viewStore: ViewStore<State, PrimeModalAction>

  public init(store: Store<PrimeModalState, PrimeModalAction>) {
    print("IsPrimeModalView.init")
    self.store = store
    self.viewStore = self.store
      .scope(value: State.init(primeModalState:), action: { $0 })
      .view
  }

  public var body: some View {
    print("IsPrimeModalView.body")
    return VStack {
      if isPrime(self.viewStore.value.count) {
        Text("\(self.viewStore.value.count) is prime 🎉")
        if self.viewStore.value.isFavorite {
          Button("Remove from favorite primes") {
            self.viewStore.send(.removeFavoritePrimeTapped)
          }
        } else {
          Button("Save to favorite primes") {
            self.viewStore.send(.saveFavoritePrimeTapped)
          }
        }
      } else {
        Text("\(self.viewStore.value.count) is not prime :(")
      }
    }
  }
}

func isPrime(_ p: Int) -> Bool {
  if p <= 1 { return false }
  if p <= 3 { return true }
  for i in 2...Int(sqrtf(Float(p))) {
    if p % i == 0 { return false }
  }
  return true
}

extension IsPrimeModalView.State {
  init(primeModalState state: PrimeModalState) {
    self.count = state.count
    self.isFavorite = state.favoritePrimes.contains(state.count)
  }
}
