import ComposableArchitecture
import SwiftUI

@main
struct SearchApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView(
          store: .init(
            initialState: .init(),
            reducer: appReducer.debugActions(),
            environment: .init()
          )
        )
      }
    }
  }
}
