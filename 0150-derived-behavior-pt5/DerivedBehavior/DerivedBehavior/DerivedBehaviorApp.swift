import SwiftUI

@main
struct DerivedBehaviorApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
//      AppView(
//        store: .init(initialState: AppState.init(counters: []), reducer: appReducer, environment: AppEnvironment(fact: .live, mainQueue: .main, uuid: UUID.init))
//      )
        VanillaAppView(viewModel: AppViewModel(fact: .live, mainQueue: .main, uuid: UUID.init))
      }
    }
  }
}
