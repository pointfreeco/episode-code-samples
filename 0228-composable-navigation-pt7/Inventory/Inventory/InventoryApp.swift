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
              editItem: ItemFormFeature.State(item: .headphones),
              items: (1...100).map { Item(name: "Item \($0)", status: .inStock(quantity: $0)) }
              + [
                .monitor,
                .mouse,
                .keyboard,
                .headphones
              ]
            ),
            selectedTab: .inventory
          ),
          reducer: AppFeature()
            //._printChanges()
        )
      )
    }
  }
}
