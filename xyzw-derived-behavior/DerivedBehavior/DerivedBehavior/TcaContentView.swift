import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
  var count = 0
  var favorites: Set<Int> = []
}

enum AppAction {
  case incrementButtonTapped
  case decrementButtonTapped
  case saveButtonTapped
  case removeButtonTapped
  case profileRemoveButtonTapped(Int)
}

struct AppEnvironment {}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, _ in
  switch action {
  case .incrementButtonTapped:
    state.count += 1
    return .none
  case .decrementButtonTapped:
    state.count -= 1
    return .none
  case .saveButtonTapped:
    state.favorites.insert(state.count)
    return .none
  case .removeButtonTapped:
    state.favorites.remove(state.count)
    return .none
  case let .profileRemoveButtonTapped(number):
    state.favorites.remove(number)
    return .none
  }
}

struct TcaContentView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      TabView {
        TcaCounterView(store: self.store)
          .tabItem { Text("Counter \(viewStore.count)") }

        TcaProfileView(store: self.store)
          .tabItem { Text("Profile \(viewStore.favorites.count)") }
      }
    }
  }
}

struct TcaCounterView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack {
          Button("-") { viewStore.send(.decrementButtonTapped) }
          Text("\(viewStore.count)")
          Button("+") { viewStore.send(.incrementButtonTapped) }
        }

        if viewStore.favorites.contains(viewStore.count) {
          Button("Remove") {
            viewStore.send(.removeButtonTapped)
          }
        } else {
          Button("Save") {
            viewStore.send(.saveButtonTapped)
          }
        }
      }
    }
  }
}

struct TcaProfileView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      List {
        ForEach(viewStore.favorites.sorted(), id: \.self) { number in
          HStack {
            Text("\(number)")
            Spacer()
            Button("Remove") {
              viewStore.send(.profileRemoveButtonTapped(number))
            }
          }
        }
      }
    }
  }
}

struct TcaContentView_Previews: PreviewProvider {
  static var previews: some View {
    TcaContentView(
      store: Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
      )
    )
  }
}
