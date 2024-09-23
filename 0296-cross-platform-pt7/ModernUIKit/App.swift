import Counter
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
//        CounterView(model: CounterModel())
        UIViewControllerRepresenting {
//          EpoxyCounterViewController(model: CounterModel())
          NavigationStackController(
            model: model
          )
        }
      }
    }
  }
}
