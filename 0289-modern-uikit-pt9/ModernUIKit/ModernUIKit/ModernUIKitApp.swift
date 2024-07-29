import SwiftUI

@main
struct ModernUIKitApp: App {
  var body: some Scene {
    WindowGroup {
      UIViewControllerRepresenting {
        NavigationStackController(
          model: AppModel(
            path: []
          )
        )
      }
    }
  }
}
