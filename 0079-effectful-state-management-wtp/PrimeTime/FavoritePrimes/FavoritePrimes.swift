import ComposableArchitecture
import SwiftUI

public enum FavoritePrimesAction {
  case deleteFavoritePrimes(IndexSet)
  case loadButtonTapped
  case loadedFavoritePrimes([Int])
  case saveButtonTapped
}

public func favoritePrimesReducer(state: inout [Int], action: FavoritePrimesAction) -> [Effect<FavoritePrimesAction>] {
  switch action {
  case let .deleteFavoritePrimes(indexSet):
    for index in indexSet {
      state.remove(at: index)
    }
    return []

  case let .loadedFavoritePrimes(favoritePrimes):
    state = favoritePrimes
    return []

  case .saveButtonTapped:
//    let state = state
    return [saveEffect(favoritePrimes: state)]

  case .loadButtonTapped:
    return [loadEffect]
  }
}

private func saveEffect(favoritePrimes: [Int]) -> Effect<FavoritePrimesAction> {
  return Effect { _ in
    let data = try! JSONEncoder().encode(favoritePrimes)
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let documentsUrl = URL(fileURLWithPath: documentsPath)
    let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
    try! data.write(to: favoritePrimesUrl)
  }
}

private let loadEffect = Effect<FavoritePrimesAction> { callback in
  let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
  let documentsUrl = URL(fileURLWithPath: documentsPath)
  let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
  guard
    let data = try? Data(contentsOf: favoritePrimesUrl),
    let favoritePrimes = try? JSONDecoder().decode([Int].self, from: data)
    else { return }
  //      self.store.send(.loadedFavoritePrimes(favoritePrimes))
  callback(.loadedFavoritePrimes(favoritePrimes))
}

public struct FavoritePrimesView: View {
  @ObservedObject var store: Store<[Int], FavoritePrimesAction>

  public init(store: Store<[Int], FavoritePrimesAction>) {
    self.store = store
  }

  public var body: some View {
    List {
      ForEach(self.store.value, id: \.self) { prime in
        Text("\(prime)")
      }
      .onDelete { indexSet in
        self.store.send(.deleteFavoritePrimes(indexSet))
      }
    }
    .navigationBarTitle("Favorite primes")
    .navigationBarItems(
      trailing: HStack {
        Button("Save") {
          self.store.send(.saveButtonTapped)
//          let data = try! JSONEncoder().encode(self.store.value)
//          let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//          let documentsUrl = URL(fileURLWithPath: documentsPath)
//          let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
//          try! data.write(to: favoritePrimesUrl)
        }
        Button("Load") {
          self.store.send(.loadButtonTapped)
//          let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//          let documentsUrl = URL(fileURLWithPath: documentsPath)
//          let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
//          guard
//            let data = try? Data(contentsOf: favoritePrimesUrl),
//            let favoritePrimes = try? JSONDecoder().decode([Int].self, from: data)
//            else { return }
//          self.store.send(.loadedFavoritePrimes(favoritePrimes))
        }
      }
    )
  }
}
