import ComposableArchitecture
import SwiftUI

struct InventoryFeature: Reducer {
  struct State: Equatable {
    var alert: AlertState<Action.Alert>?
    var items: IdentifiedArrayOf<Item> = []
  }
  enum Action: Equatable {
    case alert(Alert)
    case deleteButtonTapped(id: Item.ID)

    enum Alert: Equatable {
      case confirmDeletion(id: Item.ID)
      case dismiss
    }
  }

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case let .alert(.confirmDeletion(id)):
      state.items.remove(id: id)
      return .none

    case .alert(.dismiss):
      state.alert = nil
      return .none

    case let .deleteButtonTapped(id):
      guard let item = state.items[id: id]
      else { return .none }

      state.alert = .delete(item: item)
      return .none
    }
  }
}

extension AlertState where Action == InventoryFeature.Action.Alert {
  static func delete(item: Item) -> Self {
    AlertState {
      TextState(#"Delete "\#(item.name)""#)
    } actions: {
      ButtonState(role: .destructive, action: .send(.confirmDeletion(id: item.id), animation: .default)) {
        TextState("Delete")
      }
    } message: {
      TextState("Are you sure you want to delete this item?")
    }
  }
}

struct InventoryView: View {
  let store: StoreOf<InventoryFeature>
  
  var body: some View {
    WithViewStore(self.store, observe: \.items) { viewStore in
      List {
        ForEach(viewStore.state) { item in
          HStack {
            VStack(alignment: .leading) {
              Text(item.name)

              switch item.status {
              case let .inStock(quantity):
                Text("In stock: \(quantity)")
              case let .outOfStock(isOnBackOrder):
                Text("Out of stock" + (isOnBackOrder ? ": on back order" : ""))
              }
            }

            Spacer()

            if let color = item.color {
              Rectangle()
                .frame(width: 30, height: 30)
                .foregroundColor(color.swiftUIColor)
                .border(Color.black, width: 1)
            }

            Button {
              viewStore.send(.deleteButtonTapped(id: item.id))
            } label: {
              Image(systemName: "trash.fill")
            }
            .padding(.leading)
          }
          .buttonStyle(.plain)
          .foregroundColor(item.status.isInStock ? nil : Color.gray)
        }
      }
      .alert(
        self.store.scope(state: \.alert, action: InventoryFeature.Action.alert),
        dismiss: .dismiss
      )
    }
  }
}

struct Inventory_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      InventoryView(
        store: Store(
          initialState: InventoryFeature.State(
            items: [
              .headphones,
              .mouse,
              .keyboard,
              .monitor,
            ]
          ),
          reducer: InventoryFeature()
        )
      )
    }
  }
}
