import ComposableArchitecture
import SwiftUI

struct InventoryFeature: Reducer {
  struct State: Equatable {
    var addItem: ItemFormFeature.State?
    var alert: AlertState<Action.Alert>?
    var duplicateItem: ItemFormFeature.State?
    var editItem: ItemFormFeature.State?
    var items: IdentifiedArrayOf<Item> = []
  }
  enum Action: Equatable {
    case addButtonTapped
    case addItem(PresentationAction<ItemFormFeature.Action>)
    case alert(PresentationAction<Alert>)
    case cancelAddItemButtonTapped
    case cancelDuplicateItemButtonTapped
    case confirmAddItemButtonTapped
    case confirmDuplicateItemButtonTapped
    case duplicateItem(PresentationAction<ItemFormFeature.Action>)
    case deleteButtonTapped(id: Item.ID)
    case duplicateButtonTapped(id: Item.ID)
    case editItem(PresentationAction<ItemFormFeature.Action>)
    case itemButtonTapped(id: Item.ID)

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
      case .addButtonTapped:
        state.addItem = ItemFormFeature.State(
          item: Item(name: "", status: .inStock(quantity: 1))
        )
        return .none

      case .addItem:
        return .none

      case let .alert(.presented(.confirmDeletion(id))):
        state.items.remove(id: id)
        return .none

      case .alert:
        return .none

      case .cancelAddItemButtonTapped:
        state.addItem = nil
        return .none

      case .cancelDuplicateItemButtonTapped:
        state.duplicateItem = nil
        return .none

      case .confirmAddItemButtonTapped:
        defer { state.addItem = nil }
        guard let item = state.addItem?.item
        else {
          XCTFail("Can't confirm add when item is nil")
          return .none
        }
        state.items.append(item)
        return .none

      case .confirmDuplicateItemButtonTapped:
        defer { state.duplicateItem = nil }
        guard let item = state.duplicateItem?.item
        else {
          XCTFail("Can't confirm duplicate when item is nil")
          return .none
        }
        state.items.append(item)
        return .none

      case let .deleteButtonTapped(id):
        guard let item = state.items[id: id]
        else { return .none }

        state.alert = .delete(item: item)
        return .none

      case let .duplicateButtonTapped(id):
        guard let item = state.items[id: id]
        else { return .none }

        state.duplicateItem = ItemFormFeature.State(item: item.duplicate())
        return .none

      case .duplicateItem:
        return .none

      case .editItem(.dismiss):
        guard let item = state.editItem?.item
        else { return .none }
        state.items[id: item.id] = item
        return .none
      case .editItem:
        return .none

      case let .itemButtonTapped(id: itemID):
        guard let item = state.items[id: itemID]
        else {
          XCTFail("Can't edit the item when it's not found in the list.")
          return .none
        }
        state.editItem = ItemFormFeature.State(item: item)
        return .none
      }
    }
    .ifLet(\.alert, action: /Action.alert)
    .ifLet(\.addItem, action: /Action.addItem) {
      ItemFormFeature()
    }
    .ifLet(\.duplicateItem, action: /Action.duplicateItem) {
      ItemFormFeature()
    }
    .ifLet(\.editItem, action: /Action.editItem) {
      ItemFormFeature()
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

  struct ViewState: Equatable {
    let editItemID: Item.ID?
    let items: IdentifiedArrayOf<Item>

    init(state: InventoryFeature.State) {
      self.editItemID = state.editItem?.item.id
      self.items = state.items
    }
  }
  
  var body: some View {
    WithViewStore(self.store, observe: ViewState.init) { (viewStore: ViewStore<ViewState, InventoryFeature.Action>) in
      List {
        ForEach(viewStore.items) { item in
//          NavigationLinkStore(
//            store: self.store.scope(
//              state: \.editItem,
//              action: InventoryFeature.Action.editItem
//            ),
//            id: item.id
//          ) {
//            viewStore.send(.itemButtonTapped(id: item.id))
//          } destination: { store in
//            ItemFormView(store: store)
//              .navigationTitle("Edit item")
          Button {
            viewStore.send(.itemButtonTapped(id: item.id))
          } label: {
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
            }          }
          .buttonStyle(.plain)
          .foregroundColor(item.status.isInStock ? nil : Color.gray)
        }
      }
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button("Add") {
            viewStore.send(.addButtonTapped)
          }
        }
      }
      .alert(
        store: self.store.scope(state: \.alert, action: InventoryFeature.Action.alert)
      )
      .popover(
        store: self.store.scope(state: \.duplicateItem, action: InventoryFeature.Action.duplicateItem)
      ) { store in
        NavigationStack {
          ItemFormView(store: store)
            .toolbar {
              ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                  viewStore.send(.cancelDuplicateItemButtonTapped)
                }
              }
              ToolbarItem(placement: .primaryAction) {
                Button("Add") {
                  viewStore.send(.confirmDuplicateItemButtonTapped)
                }
              }
            }
            .navigationTitle("Duplicate item")
        }
      }
      .sheet(
        store: self.store.scope(state: \.addItem, action: InventoryFeature.Action.addItem)
      ) { store in
        NavigationStack {
          ItemFormView(store: store)
            .toolbar {
              ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                  viewStore.send(.cancelAddItemButtonTapped)
                }
              }
              ToolbarItem(placement: .primaryAction) {
                Button("Add") {
                  viewStore.send(.confirmAddItemButtonTapped)
                }
              }
            }
            .navigationTitle("New item")
        }
      }
      .navigationDestination(
        store: self.store.scope(
          state: \.editItem,
          action: InventoryFeature.Action.editItem
        )
      ) { store in
        ItemFormView(store: store)
          .navigationTitle("Edit item")
      }
    }
  }
}

struct Inventory_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      InventoryView(
        store: Store(
          initialState: InventoryFeature.State(
            editItem: ItemFormFeature.State(
              item: Item(
                id: Item.keyboard.id,
                name: "Bluetooth Keyboard",
                color: .red,
                status: .outOfStock(isOnBackOrder: true)
              )
            ),
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
