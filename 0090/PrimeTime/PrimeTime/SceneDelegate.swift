import ComposableArchitecture
import SwiftUI
import UIKit
import WolframAlpha
import Counter
import PrimeModal
import FavoritePrimes

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)

      let nthPrime = WolframAlpha.nthPrime
      let counterEnv = CounterEnvironment(nthPrime: nthPrime)
      let primeModalEnv = FavoritePrimesEnvironment(fileClient: .live, nthPrime: nthPrime)

      window.rootViewController = UIHostingController(
        rootView: ContentView(
          store: Store(
            initialValue: AppState(count: 20_000, favoritePrimes: [2, 3, 5, 7, 11]),
            reducer: with(
              appReducer,
              compose(
                logging,
                activityFeed
              )
            ),
            environment: AppEnvironment(
              counter: counterEnv,
              favoritePrimes: primeModalEnv,
              offlineNthPrime: offlineNthPrime
            )
          )
        )
      )
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}
