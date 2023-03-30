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
              destination: .addItem(ItemFormFeature.State(item: .headphones)),
//              addItem: ItemFormFeature.State(item: .headphones),
//              duplicateItem: ItemFormFeature.State(item: .headphones.duplicate()),
              items: [
                .monitor,
                .mouse,
                .keyboard,
                .headphones
              ]
            ),
            selectedTab: .inventory
          ),
          reducer: AppFeature()._printChanges()
        )
      )
    }
  }
}
