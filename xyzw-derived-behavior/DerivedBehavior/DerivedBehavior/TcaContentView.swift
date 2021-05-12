import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
  var count = 0
  var favorites: Set<Int> = []

  var counter: CounterState {
    get {
      .init(count: self.count, favorites: self.favorites)
    }
    set {
      self.count = newValue.count
      self.favorites = newValue.favorites
    }
  }
  var profile: ProfileState {
    get {
      .init(favorites: self.favorites)
    }
    set {
      self.favorites = newValue.favorites
    }
  }
}

enum AppAction {
  case counter(CounterAction)
  case profile(ProfileAction)

//  case incrementButtonTapped
//  case decrementButtonTapped
//  case saveButtonTapped
//  case removeButtonTapped
//  case profileRemoveButtonTapped(Int)
}

struct AppEnvironment {}

let appReducer = Reducer.combine(
  counterReducer.pullback(
    state: \AppState.counter,
    action: /AppAction.counter,
    environment: { (_: AppEnvironment) in CounterEnvironment() }
  ),
  profileReducer.pullback(
    state: \AppState.profile,
    action: /AppAction.profile,
    environment: { (_: AppEnvironment) in ProfileEnvironment() }
  )
)

//  Reducer<AppState, AppAction, AppEnvironment> { state, action, _ in
//  switch action {
//  case let .counter(counterAction):
//    return counterReducer.run(&state.counter, counterAction, CounterEnvironment())
//      .map(AppAction.counter)
//
//  case let .profile(profileAction):
//    return profileReducer.run(&state.profile, profileAction, ProfileEnvironment())
//      .map(AppAction.profile)
//  }
//}

struct TcaContentView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      TabView {
        TcaCounterView(
          store: self.store
            .scope(
              state: \.counter,
              action: AppAction.counter
            )
        )
          .tabItem { Text("Counter \(viewStore.count)") }

        TcaProfileView(
          store: self.store
            .scope(
              state: \.profile,
              action: AppAction.profile
            )
        )
          .tabItem { Text("Profile \(viewStore.favorites.count)") }
      }
    }
  }
}

struct CounterState: Equatable {
  var count = 0
  var favorites: Set<Int> = []
}
enum CounterAction {
  case incrementButtonTapped
  case decrementButtonTapped
  case saveButtonTapped
  case removeButtonTapped
}
struct CounterEnvironment {}

let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> { state, action, _ in
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
  }
}

struct TcaCounterView: View {
  let store: Store<CounterState, CounterAction>
  
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

struct ProfileState: Equatable {
  var favorites: Set<Int> = []
}
enum ProfileAction {
  case removeButtonTapped(Int)
}
struct ProfileEnvironment {}

let profileReducer = Reducer<ProfileState, ProfileAction, ProfileEnvironment> { state, action, _ in
  switch action {
  case let .removeButtonTapped(number):
    state.favorites.remove(number)
    return .none
  }
}

struct TcaProfileView: View {
  let store: Store<ProfileState, ProfileAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      List {
        ForEach(viewStore.favorites.sorted(), id: \.self) { number in
          HStack {
            Text("\(number)")
            Spacer()
            Button("Remove") {
              viewStore.send(.removeButtonTapped(number))
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
