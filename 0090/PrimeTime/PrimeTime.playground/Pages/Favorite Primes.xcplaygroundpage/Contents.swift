import ComposableArchitecture
@testable import FavoritePrimes
import PlaygroundSupport
import SwiftUI

PlaygroundPage.current.liveView = UIHostingController(
  rootView: NavigationView {
    FavoritePrimesView(
      store: Store(
        initialValue: (
          alertNthPrime: nil,
          favoritePrimes: [2, 3, 5, 7, 11]
        ),
        reducer: favoritePrimesReducer,
        environment: (
          fileClient: FileClient.mock,
          nthPrime: { _ in .sync { 17 } }
        )
      )
    )
  }
)
