import ComposableArchitecture
import SwiftUI

@main
struct CounterApp: App {
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
