import ComposableArchitecture
import SwiftUI

@main
struct SearchApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        ContentView(
          store: .init(
            initialState: .init(),
            reducer: appReducer.debugActions(),
            environment: .init(
              localSearchCompleter: .live
            )
          )
        )
      }
    }
  }
}
