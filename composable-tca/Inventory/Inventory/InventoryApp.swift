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
//              addItem: ItemFormFeature.State(item: Item(name: "Laptop", status: .inStock(quantity: 100))),
              items: [
                .monitor,
                .mouse,
                .keyboard,
                .headphones
              ]
            )//,
//            selectedTab: .inventory
          ),
          reducer: AppFeature()
            ._printChanges()
        )
      )
    }
  }
}
