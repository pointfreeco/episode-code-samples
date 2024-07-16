import SwiftUI

@main
struct ModernUIKitApp: App {
  init() {
    @State var model = CounterModel()
    model.fact = CounterModel.Fact(value: "good number!")
    dump(Binding($model.fact)!.value)
  }


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
