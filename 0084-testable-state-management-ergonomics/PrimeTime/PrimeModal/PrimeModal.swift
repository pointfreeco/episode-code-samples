import ComposableArchitecture
import SwiftUI

public typealias PrimeModalState = (count: Int, favoritePrimes: [Int])

public enum PrimeModalAction: Equatable {
  case saveFavoritePrimeTapped
  case removeFavoritePrimeTapped
}

public func primeModalReducer(state: inout PrimeModalState, action: PrimeModalAction) -> [Effect<PrimeModalAction>] {
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
    typealias State = (
        count: Int,
        countIsFavorited: Bool
    )

    @ObservedObject var viewState: ViewState<State>
  let store: Store<PrimeModalState, PrimeModalAction>

  public init(store: Store<PrimeModalState, PrimeModalAction>) {
    self.store = store
    self.viewState = store
        .viewState(
            { ($0.count, $0.favoritePrimes.contains($0.count)) },
            isEqual: ==
    )
  }

  public var body: some View {
    VStack {
      if isPrime(self.viewState.value.count) {
        Text("\(self.viewState.value.count) is prime 🎉")
        if self.viewState.value.countIsFavorited {
          Button("Remove from favorite primes") {
            self.store.send(.removeFavoritePrimeTapped)
          }
        } else {
          Button("Save to favorite primes") {
            self.store.send(.saveFavoritePrimeTapped)
          }
        }
      } else {
        Text("\(self.viewState.value.count) is not prime :(")
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
