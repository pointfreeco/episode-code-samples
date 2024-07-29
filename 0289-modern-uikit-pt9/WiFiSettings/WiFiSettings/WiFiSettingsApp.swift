import SwiftUI
import UIKitNavigation

@main
struct WiFiSettingsApp: App {
  var body: some Scene {
    WindowGroup {
      UIViewControllerRepresenting {
        UINavigationController(
          rootViewController: WiFiSettingsViewController(
            model: WiFiSettingsModel(
              foundNetworks: .mocks
            )
          )
        )
      }
    }
  }
}
