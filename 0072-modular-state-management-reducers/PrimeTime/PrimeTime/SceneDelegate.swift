import ComposableArchitecture
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var timer: Timer?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      let store = Store(
        initialValue: AppState(),
        reducer: with(
          appReducer,
          compose(
            logging,
            activityFeed
          )
        )
      )
      window.rootViewController = UIHostingController(
        rootView: ContentView(
          store: store
        )
      )
//      timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//        store.send(.primeModal(.saveFavoritePrimeTapped))
//      }
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}
