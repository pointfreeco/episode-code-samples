import ComposableArchitecture
import SwiftUI

@main
struct InventoryApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(
          initialState: AppFeature.State(
            inventory: InventoryFeature.State(
              items: [
                .monitor,
                .mouse,
                .keyboard,
                .headphones
              ]
            )
          ),
          reducer: AppFeature()
            ._printChanges()
        )
      )
    }
  }
}
