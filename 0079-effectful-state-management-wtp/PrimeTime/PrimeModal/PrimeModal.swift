import ComposableArchitecture
import SwiftUI

public typealias PrimeModalState = (count: Int, favoritePrimes: [Int])

public enum PrimeModalAction {
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
  @ObservedObject var store: Store<PrimeModalState, PrimeModalAction>

  public init(store: Store<PrimeModalState, PrimeModalAction>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      if isPrime(self.store.value.count) {
        Text("\(self.store.value.count) is prime 🎉")
        if self.store.value.favoritePrimes.contains(self.store.value.count) {
          Button("Remove from favorite primes") {
            self.store.send(.removeFavoritePrimeTapped)
          }
        } else {
          Button("Save to favorite primes") {
            self.store.send(.saveFavoritePrimeTapped)
          }
        }
      } else {
        Text("\(self.store.value.count) is not prime :(")
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
