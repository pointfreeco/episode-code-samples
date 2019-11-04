import ComposableArchitecture
import FavoritePrimes
import PlaygroundSupport
import SwiftUI

PlaygroundPage.current.liveView = UIHostingController(
  rootView: NavigationView {
    FavoritePrimesView(
      store: Store<[Int], FavoritePrimesAction>(
        initialValue: [2, 3, 5, 7, 11],
        reducer: favoritePrimesReducer
      )
    )
  }
)

//
//func compute(_ x: Int) -> Int {
//  let computation = x * x + 1
//  print("Computed \(computation)")
//  return computation
//}
//
//func computeAndPrint(_ x: Int) -> (Int, [String]) {
//  let computation = x * x + 1
//  return (computation, ["Computed \(computation)"])
//}
