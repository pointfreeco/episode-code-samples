import ComposableArchitecture
import SwiftUI

struct InventoryFeature: Reducer {
  struct State: Equatable {}
  enum Action: Equatable {}

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
  }
}

struct InventoryView: View {
  let store: StoreOf<InventoryFeature>
  
  var body: some View {
    Text("Inventory")
  }
}
