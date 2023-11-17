import ComposableArchitecture
import SwiftUI

@main
struct SneakPeekApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(initialState: CounterFeature.State()) {
          CounterFeature()
        }
      )
    }
  }
}
