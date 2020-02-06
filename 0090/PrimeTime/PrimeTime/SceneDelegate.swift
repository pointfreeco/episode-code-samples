import ComposableArchitecture
import SwiftUI
import UIKit
import Counter

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(
        rootView: ContentView(
          store: Store(
            initialValue: AppState(count: 0, favoritePrimes: [2, 3, 5, 7]),
            reducer: with(
              appReducer,
              compose(
                logging,
                activityFeed
              )
            ),
            environment: (
              fileClient: .live,
              offlineNthPrime: offlineNthPrime,
              nthPrime: nthPrime
            )
          )
        )
      )
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}
