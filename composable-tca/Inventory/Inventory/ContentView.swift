import ComposableArchitecture
import SwiftUI

struct AppFeature: Reducer {
  struct State: Equatable {
    var firstTab = FirstTabFeature.State()
    var inventory = InventoryFeature.State()
    var selectedTab: Tab = .one
    var thirdTab = ThirdTabFeature.State()
  }
  enum Action: Equatable {
    case firstTab(FirstTabFeature.Action)
    case inventory(InventoryFeature.Action)
    case selectedTabChanged(Tab)
    case thirdTab(ThirdTabFeature.Action)
  }
  var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .firstTab(.delegate(action)):
        switch action {
        case .switchToInventoryTab:
          state.selectedTab = .inventory
          return .none
        }

      case let .selectedTabChanged(tab):
        state.selectedTab = tab
        return .none

      case .firstTab, .inventory, .thirdTab:
        return .none
      }
    }
    Scope(state: \.firstTab, action: /Action.firstTab) {
      FirstTabFeature()
    }
    Scope(state: \.inventory, action: /Action.inventory) {
      InventoryFeature()
    }
    Scope(state: \.thirdTab, action: /Action.thirdTab) {
      ThirdTabFeature()
    }
  }
}

enum Tab {
  case one, inventory, three
}

struct ContentView: View {
  //@State var selectedTab: Tab = .one
  let store: StoreOf<AppFeature>
  // Store<AppFeature.State, AppFeature.Action>

  var body: some View {
    WithViewStore(self.store, observe: \.selectedTab) { viewStore in
      TabView(selection: viewStore.binding(send: AppFeature.Action.selectedTabChanged)) {
        FirstTabView(
          store: self.store.scope(
            state: \.firstTab,
            action: AppFeature.Action.firstTab
          )
        )
        .tabItem { Text("One") }
        .tag(Tab.one)

        NavigationView {
          InventoryView(
            store: self.store.scope(
              state: \.inventory,
              action: AppFeature.Action.inventory
            )
          )
        }
        .tabItem { Text("Inventory") }
        .tag(Tab.inventory)

        ThirdTabView(
          store: self.store.scope(
            state: \.thirdTab,
            action: AppFeature.Action.thirdTab
          )
        )
        .tabItem { Text("Three") }
        .tag(Tab.three)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      store: Store(
        initialState: AppFeature.State(),
        reducer: AppFeature()
      )
    )
  }
}
