import ComposableArchitecture
import SwiftUI

@main
struct ConciseFormsApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
//        VanillaSwiftUIFormView(viewModel: .init())

        TCAFormView(
          store: Store(
            initialState: .init(),
            reducer: settingsReducer,
            environment: .init(
              mainQueue: .main,
              userNotifications: .live
            )
          )
        )
      }
    }
  }
}
