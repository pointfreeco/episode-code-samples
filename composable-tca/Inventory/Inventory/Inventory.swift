import ComposableArchitecture
import SwiftUI

struct InventoryFeature: Reducer {
  struct State: Equatable {
    var alert: AlertState<Action.Alert>?
    var confirmationDialog: ConfirmationDialogState<Action.Dialog>?
    var items: IdentifiedArrayOf<Item> = []
  }
  enum Action: Equatable {
    case alert(AlertAction<Alert>)
    case confirmationDialog(ConfirmationDialogAction<Dialog>)
    case deleteButtonTapped(id: Item.ID)
    case duplicateButtonTapped(id: Item.ID)

    enum Alert: Equatable {
      case confirmDeletion(id: Item.ID)
    }
    enum Dialog: Equatable {
      case confirmDuplication(id: Item.ID)
    }
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .alert(.presented(.confirmDeletion(id))):
        state.items.remove(id: id)
        return .none

//      case .alert(.dismiss):
//        state.alert = nil
//        return .none
        
      case .alert:
        return .none

      case let .confirmationDialog(.presented(.confirmDuplication(id: id))):
        guard
          let item = state.items[id: id],
          let index = state.items.index(id: id)
        else {
          return .none
        }
        state.items.insert(item.duplicate(), at: index)
        return .none

      case .confirmationDialog(.dismiss):
        return .none

      case let .deleteButtonTapped(id):
        guard let item = state.items[id: id]
        else { return .none }

        state.alert = .delete(item: item)
        return .none

      case let .duplicateButtonTapped(id):
        guard let item = state.items[id: id]
        else { return .none }

        // show a confirmation dialog
        state.confirmationDialog = .duplicate(item: item)
        return .none
      }
    }
    .alert(state: \.alert, action: /Action.alert)
    .confirmationDialog(state: \.confirmationDialog, action: /Action.confirmationDialog)
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

extension ConfirmationDialogState where Action == InventoryFeature.Action.Dialog {
  static func duplicate(item: Item) -> Self {
    ConfirmationDialogState {
      TextState(#"Duplicate "\#(item.name)""#)
    } actions: {
      ButtonState(action: .send(.confirmDuplication(id: item.id), animation: .default)) {
        TextState("Duplicate")
      }
    } message: {
      TextState("Are you sure you want to duplicate this item?")
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
              viewStore.send(.duplicateButtonTapped(id: item.id))
            } label: {
              Image(systemName: "doc.on.doc.fill")
            }
            .padding(.leading)

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
        store: self.store.scope(state: \.alert, action: InventoryFeature.Action.alert)
      )
      .confirmationDialog(
        store: self.store.scope(state: \.confirmationDialog, action: InventoryFeature.Action.confirmationDialog)
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
