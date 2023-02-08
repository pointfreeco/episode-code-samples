import ComposableArchitecture
import SwiftUI

struct AppFeature: Reducer {
  struct State {
    var selectedTab: Tab = .one
  }
  enum Action {
    case selectedTabChanged(Tab)
  }
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case let .selectedTabChanged(tab):
      state.selectedTab = tab
      return .none
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
        Button {
          viewStore.send(.selectedTabChanged(.inventory))
        } label: {
          Text("Go to inventory")
        }
        .tabItem { Text("One") }
        .tag(Tab.one)

        Text("Inventory")
          .tabItem { Text("Inventory") }
          .tag(Tab.inventory)

        Text("Three")
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
