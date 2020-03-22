import CompArch
import HistoryTransceiver
import SwiftUI
import UIKit

var appStore = HistoryTransceiverView<ContentView>.store()

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    Transceiver.shared.receive(Message.self) { msg in
        if msg.command == .reset {
            appStore.send(.updateState(msg.state))
        }
    }
    Transceiver.shared.resume()
    let contentView = HistoryTransceiverView<ContentView>(store: appStore)

    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(rootView: contentView)
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}
