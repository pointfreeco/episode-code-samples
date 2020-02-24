import ComposableArchitecture
import Counter
import SwiftUI
import UIKit

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
//              compose(
//                logging,
                activityFeed
//              )
            ),
            environment: AppEnvironment(
              fileClient: .live,
              nthPrime: Counter.nthPrime,
              offlineNthPrime: Counter.offlineNthPrime
            )
          )
        )
      )
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}
