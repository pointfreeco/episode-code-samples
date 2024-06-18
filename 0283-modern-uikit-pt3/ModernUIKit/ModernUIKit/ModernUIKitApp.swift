import SwiftUI

@main
struct ModernUIKitApp: App {
  var body: some Scene {
    WindowGroup {
      CounterView(model: CounterModel())
//      UIViewControllerRepresenting {
//        CounterViewController(model: CounterModel())
//      }
    }
  }
}
