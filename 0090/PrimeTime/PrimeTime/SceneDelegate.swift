import ComposableArchitecture
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
              compose(
                logging,
                activityFeed
              )
            ),
            environment: AppEnvironment(
              counter: .live,
              favoritePrimes: .live,
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

import Combine
import PrimeModal

private func offlineNthPrime(_ n: Int) -> Effect<Int?> {
  return Future { callback in
    var primeCount = 0
    var index = 1
    while primeCount < n {
      index += 1
      if isPrime(index) {
        primeCount += 1
      }
    }
    callback(.success(index))
  }
  .subscribe(on: DispatchQueue.global())
  .receive(on: DispatchQueue.main)
  .eraseToEffect()
}
