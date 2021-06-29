import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
  var count = 0
  var favorites: Set<Int> = []
  var slider = SliderState()

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
  case slider(SliderAction)
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
  ),
  sliderReducer.pullback(
    state: \.slider,
    action: /AppAction.slider,
    environment: { (_: AppEnvironment) in SliderEnvironment() }
  )
)

struct TcaContentView: View {
  let store: Store<AppState, AppAction>

//  @ObservedObject var viewStore: ViewStore<AppState, AppAction>
//
//  init(store: Store<AppState, AppAction>) {
//    self.store = store
//    self.viewStore = ViewStore(self.store)
//  }

  struct ViewState: Equatable {
    let count: Int
//    let favorites: Set<Int>
    let favoritesCount: Int

    init(state: AppState) {
      self.count = state.count
//      self.favorites = state.favorites
      self.favoritesCount = state.favorites.count
    }
  }
  
  var body: some View {
    WithViewStore(self.store.scope(state: ViewState.init)) { viewStore in
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
          .tabItem { Text("Profile \(viewStore.favoritesCount)") }

        SliderView(
          store: self.store.scope(
            state: \.slider,
            action: AppAction.slider
          )
        )
          .tabItem { Text("Slider") }
      }
    }
    .debug("ContentView")
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
    .debug("CounterView")
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
    .debug("ProfileView")
  }
}

struct SliderState: Equatable {
  var value = 0.0
}
enum SliderAction {
  case setValue(Double)
}
struct SliderEnvironment {}

let sliderReducer = Reducer<SliderState, SliderAction, SliderEnvironment> { state, action, _ in
  switch action {
  case let .setValue(value):
    state.value = value
    return .none
  }
}

struct SliderView: View {
  let store: Store<SliderState, SliderAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      Slider(value: viewStore.binding(get: \.value, send: SliderAction.setValue))
    }
    .debug("SliderView")
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
