import SwiftUI
import UIKitNavigation

@main
struct ModernUIKitApp: App {
  let model = AppModel()
  init() {
    isPerceptionCheckingEnabled = false
  }
  var body: some Scene {
    WithPerceptionTracking {
      WindowGroup {
        UIViewControllerRepresenting {
          NavigationStackController(
            model: model
          )
        }
      }
    }
  }
}
