import SwiftUI
import UIKitNavigation

@main
struct ModernUIKitApp: App {
  var body: some Scene {
    WindowGroup {
      UIViewControllerRepresenting {
        NavigationStackController(
          model: AppModel()
        )
      }
    }
  }
}
