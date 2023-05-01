import ComposableArchitecture
import SwiftUI

@main
struct InventoryApp: App {
  var body: some Scene {
    WindowGroup {
      RootView(
        store: Store(
          initialState: RootFeature.State(
            path: [
              .counter(CounterFeature.State(count: 42)),
              .counter(CounterFeature.State(count: 1729)),
              .counter(CounterFeature.State(count: -999)),
            ]
          ),
          reducer: RootFeature()._printChanges()
        )
      )
//      ContentView(
//        store: Store(
//          initialState: AppFeature.State(
//            inventory: InventoryFeature.State(
//              destination: .addItem(ItemFormFeature.State(item: .headphones)),
////              addItem: ItemFormFeature.State(item: .headphones),
////              duplicateItem: ItemFormFeature.State(item: .headphones.duplicate()),
//              items: [
//                .monitor,
//                .mouse,
//                .keyboard,
//                .headphones
//              ]
//            ),
//            selectedTab: .inventory
//          ),
//          reducer: AppFeature()._printChanges()
//        )
//      )
    }
  }
}
