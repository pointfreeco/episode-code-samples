import SwiftUI

@main
struct ModernUIKitApp: App {
  var body: some Scene {
    WindowGroup {
//      CounterView(model: CounterModel())
      UIViewControllerRepresenting {
        UINavigationController(
          rootViewController: CounterViewController(
            model: CounterModel()
          )
        )
      }
    }
  }
}
