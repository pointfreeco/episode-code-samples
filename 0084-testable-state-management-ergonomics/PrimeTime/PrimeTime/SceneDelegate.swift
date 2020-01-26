import ComposableArchitecture
import Counter
import SwiftUI
import UIKit

import Combine
import PrimeModal

func newNthPrime(_ n: Int) -> Int? {
  guard n >= 1 else { return nil }
  var nthPrimeCount = 0
  var possiblePrime = 1
  while nthPrimeCount != n {
    possiblePrime += 1
    if isPrime(possiblePrime) {
      nthPrimeCount += 1
    }
  }
  return possiblePrime
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(
        rootView: ContentView(
          store: Store(
            initialValue: AppState(),
            reducer: with(
              appReducer,
              compose(
                logging,
                activityFeed
              )
            ),
            environment: AppEnvironment(
              counterEnvironment: CounterEnvironment(
                nthPrime: { n in Effect.sync(work: { newNthPrime(n) }) }
              ),
              favoritePrimesEnvironment: .live
            )
          )
        )
      )
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}
