import SwiftUI

@main
struct ModernUIKitApp: App {
  var body: some Scene {
    WindowGroup {

      UIViewControllerRepresenting {
        NavigationStackController(
          model: AppModel(
            path: [
              .counter(CounterModel()),
              .settings(SettingsModel()),
              .counter(CounterModel()),
            ]
          )
        )
      }

      //AppView(model: AppModel())

//      CounterView(model: CounterModel())
//      UIViewControllerRepresenting {
//        UINavigationController(
//          rootViewController: CounterViewController(
//            model: CounterModel()
//          )
//        )
//      }
    }
  }
}
