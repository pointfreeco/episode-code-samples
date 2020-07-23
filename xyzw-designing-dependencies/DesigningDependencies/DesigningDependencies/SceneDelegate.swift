import SwiftUI
import UIKit
import LocationClientLive
import PathMonitorClientLive
import WeatherClientLive
import WeatherFeature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    let contentView = ContentView(
      viewModel: AppViewModel(
        locationClient: .live,
        pathMonitorClient: .live(queue: .main),
        weatherClient: .live
      )
    )

    if let windowScene = scene as? UIWindowScene {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
    }
  }
}
