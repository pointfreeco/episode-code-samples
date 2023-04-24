import ComposableArchitecture
import SwiftUI

struct InventoryFeature: Reducer {
  struct State: Equatable {
    @PresentationState var destination: Destination.State?
    var items: IdentifiedArrayOf<Item> = []
  }
  enum Action: Equatable {
    case destination(PresentationAction<Destination.Action>)

    case addButtonTapped
    case cancelAddItemButtonTapped
    case cancelDuplicateItemButtonTapped
    case confirmAddItemButtonTapped
    case confirmDuplicateItemButtonTapped
    case deleteButtonTapped(id: Item.ID)
    case duplicateButtonTapped(id: Item.ID)
    case itemButtonTapped(id: Item.ID)

    enum Alert: Equatable {
      case confirmDeletion(id: Item.ID)
    }
    enum Dialog: Equatable {
      case confirmDuplication(id: Item.ID)
    }
  }

  struct Destination: Reducer {
//    @DerivingIdentifable
    enum State: Equatable, Identifiable /*, DerivingIdentifiable */ {
      case addItem(ItemFormFeature.State)
      case alert(AlertState<InventoryFeature.Action.Alert>)
      case duplicateItem(ItemFormFeature.State)
      case editItem(ItemFormFeature.State)
      var id: AnyHashable {
        switch self {
        case let .addItem(state):
          return state.id
        case let .alert(state):
          return state.id
        case let .editItem(state):
          return state.id
        case let .duplicateItem(state):
          return state.id
        }
      }
    }
    enum Action: Equatable {
      case addItem(ItemFormFeature.Action)
      case alert(InventoryFeature.Action.Alert)
      case duplicateItem(ItemFormFeature.Action)
      case editItem(ItemFormFeature.Action)
    }
    var body: some ReducerOf<Self> {
      Scope(state: /State.addItem, action: /Action.addItem) {
        ItemFormFeature()
      }
      Scope(state: /State.duplicateItem, action: /Action.duplicateItem) {
        ItemFormFeature()
      }
      Scope(state: /State.editItem, action: /Action.editItem) {
        ItemFormFeature()
      }
    }
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        state.destination = .addItem(
          ItemFormFeature.State(
            item: Item(name: "", status: .inStock(quantity: 1))
          )
        )
        return .none

//      case .addItem:
//        return .none

      case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
        state.items.remove(id: id)
        return .none

//      case .alert:
//        return .none

      case .cancelAddItemButtonTapped:
        state.destination = nil
        return .none

      case .cancelDuplicateItemButtonTapped:
        state.destination = nil
        return .none

      case .confirmAddItemButtonTapped:
        defer { state.destination = nil }
        guard case let .addItem(itemFormState) = state.destination
        else {
          XCTFail("Can't confirm add when destination is not 'addItem'")
          return .none
        }
        state.items.append(itemFormState.item)
        return .none

      case .confirmDuplicateItemButtonTapped:
        defer { state.destination = nil }
        guard case let .duplicateItem(itemFormState) = state.destination
        else {
          XCTFail("Can't confirm duplicate when destination is not 'duplicateItem'")
          return .none
        }
        state.items.append(itemFormState.item)
        return .none

      case let .deleteButtonTapped(id):
        guard let item = state.items[id: id]
        else { return .none }

        state.destination = .alert(.delete(item: item))
        return .none

      case let .duplicateButtonTapped(id):
        guard let item = state.items[id: id]
        else { return .none }

        state.destination = .duplicateItem(ItemFormFeature.State(item: item.duplicate()))
        return .none

//      case .duplicateItem:
//        return .none

      case .destination(.dismiss):
        guard case let .editItem(itemFormState) = state.destination
        else { return .none }
        state.items[id: itemFormState.id] = itemFormState.item
        return .none

//      case .editItem(.dismiss):
//        guard let item = state.editItem?.item
//        else { return .none }
//        state.items[id: item.id] = item
//        return .none
//      case .editItem:
//        return .none

      case let .itemButtonTapped(id: itemID):
        guard let item = state.items[id: itemID]
        else {
          XCTFail("Can't edit the item when it's not found in the list.")
          return .none
        }
        state.destination = .editItem(ItemFormFeature.State(item: item))
        return .none

      case .destination:
        return .none
      }
    }
    .ifLet(\.$destination, action: /Action.destination) {
      Destination()
    }
//    .ifLet(\.alert, action: /Action.alert)
//    .ifLet(\.addItem, action: /Action.addItem) {
//      ItemFormFeature()
//    }
//    .ifLet(\.duplicateItem, action: /Action.duplicateItem) {
//      ItemFormFeature()
//    }
//    .ifLet(\.editItem, action: /Action.editItem) {
//      ItemFormFeature()
//    }
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
    let items: IdentifiedArrayOf<Item>

    init(state: InventoryFeature.State) {
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
        store: self.store.scope(
          state: \.destination, action: InventoryFeature.Action.destination
        ),
        state: /InventoryFeature.Destination.State.alert,
        action: InventoryFeature.Destination.Action.alert
      )
      .popover(
        store: self.store.scope(
          state: \.destination, action: InventoryFeature.Action.destination
        ),
        state: /InventoryFeature.Destination.State.duplicateItem,
        action: InventoryFeature.Destination.Action.duplicateItem
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
        store: self.store.scope(
          state: \.destination, action: InventoryFeature.Action.destination
        ),
        state: /InventoryFeature.Destination.State.addItem,
        action: InventoryFeature.Destination.Action.addItem
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
          state: \.destination, action: InventoryFeature.Action.destination
        ),
        state: /InventoryFeature.Destination.State.editItem,
        action: InventoryFeature.Destination.Action.editItem
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
            destination: .editItem(
              ItemFormFeature.State(
                item: Item(
                  id: Item.keyboard.id,
                  name: "Bluetooth Keyboard",
                  color: .red,
                  status: .outOfStock(isOnBackOrder: true)
                )
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
