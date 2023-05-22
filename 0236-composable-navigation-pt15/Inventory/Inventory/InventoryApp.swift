import ComposableArchitecture
import SwiftUI

@main
struct InventoryApp: App {
  var body: some Scene {
    WindowGroup {
      RootView(
        store: Store(
          initialState: RootFeature.State(
            path: StackState([
              .counter(CounterFeature.State(count: 97)),
//              .counter(CounterFeature.State(count: 1729)),
//              .counter(CounterFeature.State(count: -999)),
            ])
            /*
             state.path = [
               state.path[0],
               .counter(…),
               state.path[1],
             ]
             */
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
