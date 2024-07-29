import SwiftUI

@main
struct ModernUIKitApp: App {
  var body: some Scene {
    WindowGroup {

      UIViewControllerRepresenting {
        NavigationStackController(
          model: AppModel(
            path: [
//              .counter(CounterModel()),
//              .settings(SettingsModel()),
//              .counter(
//                CounterModel(
//                  destination: .fact(
//                    CounterModel.Fact(
//                      value: "0 is a really good number"
//                    )
//                  )
//                )
//              ),
            ]
          )
        )
      }

//      AppView(
//        model: AppModel(
//          path: [
////            .counter(CounterModel()),
////            .settings(SettingsModel()),
////            .counter(
////              CounterModel(
////                destination: .fact(
////                  CounterModel.Fact(
////                    value: "0 is a really good number"
////                  )
////                )
////              )
////            ),
//          ]
//        )
//      )

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
