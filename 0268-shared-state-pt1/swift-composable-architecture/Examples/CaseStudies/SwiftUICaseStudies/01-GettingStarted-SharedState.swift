import ComposableArchitecture
import SwiftUI

private let readMe = """
  This screen demonstrates how multiple independent screens can share state in the Composable \
  Architecture. Each tab manages its own state, and could be in separate modules, but changes in \
  one tab are immediately reflected in the other.

  This tab has its own state, consisting of a count value that can be incremented and decremented, \
  as well as an alert value that is set when asking if the current count is prime.

  Internally, it is also keeping track of various stats, such as min and max counts and total \
  number of count events that occurred. Those states are viewable in the other tab, and the stats \
  can be reset from the other tab.
  """

@Reducer
struct CounterTab {
  @ObservableState
  struct State: Equatable {
    @Presents var alert: AlertState<Action.Alert>?
    var stats = Stats()
  }

  enum Action {
    case alert(PresentationAction<Alert>)
    case decrementButtonTapped
    case incrementButtonTapped
    case isPrimeButtonTapped
    case onAppear

    enum Alert: Equatable {}
  }

  @Dependency(StatsClient.self) var stats

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .alert:
        return .none

      case .decrementButtonTapped:
        state.stats.decrement()
        return .none

      case .incrementButtonTapped:
        state.stats.increment()
        return .none

      case .isPrimeButtonTapped:
        state.alert = AlertState {
          TextState(
            isPrime(state.stats.count)
            ? "👍 The number \(state.stats.count) is prime!"
            : "👎 The number \(state.stats.count) is not prime :("
          )
        }
        return .none

      case .onAppear:
        state.stats = stats.get()
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
    .onChange(of: \.stats) { _, newStats in
      let _ = stats.set(newStats)
    }
  }
}

struct CounterTabView: View {
  @Bindable var store: StoreOf<CounterTab>

  var body: some View {
    Form {
      Text(template: readMe, .caption)

      VStack(spacing: 16) {
        HStack {
          Button {
            store.send(.decrementButtonTapped)
          } label: {
            Image(systemName: "minus")
          }

          Text("\(store.stats.count)")
            .monospacedDigit()

          Button {
            store.send(.incrementButtonTapped)
          } label: {
            Image(systemName: "plus")
          }
        }

        Button("Is this prime?") { store.send(.isPrimeButtonTapped) }
      }
    }
    .buttonStyle(.borderless)
    .navigationTitle("Shared State Demo")
    .alert($store.scope(state: \.alert, action: \.alert))
    .onAppear { store.send(.onAppear) }
  }
}

@Reducer
struct ProfileTab {
  @ObservableState
  struct State: Equatable {
    var stats = Stats()
  }

  enum Action {
    case onAppear
    case resetStatsButtonTapped
  }

  @Dependency(StatsClient.self) var stats

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .resetStatsButtonTapped:
        state.stats.reset()
        return .none
      case .onAppear:
        state.stats = stats.get()
        return .none
      }
    }
    .onChange(of: \.stats) { _, newStats in
      let _ = stats.set(newStats)
    }
  }
}

struct ProfileTabView: View {
  let store: StoreOf<ProfileTab>

  var body: some View {
    Form {
      Text(
        template: """
          This tab shows state from the previous tab, and it is capable of reseting all of the \
          state back to 0.

          This shows that it is possible for each screen to model its state in the way that makes \
          the most sense for it, while still allowing the state and mutations to be shared \
          across independent screens.
          """,
        .caption
      )

      VStack(spacing: 16) {
        Text("Current count: \(store.stats.count)")
        Text("Max count: \(store.stats.maxCount)")
        Text("Min count: \(store.stats.minCount)")
        Text("Total number of count events: \(store.stats.numberOfCounts)")
        Button("Reset") { store.send(.resetStatsButtonTapped) }
      }
    }
    .buttonStyle(.borderless)
    .navigationTitle("Profile")
    .onAppear { store.send(.onAppear) }
  }
}

@Reducer
struct SharedState {
  enum Tab { case counter, profile }

  @ObservableState
  struct State: Equatable {
    var currentTab = Tab.counter
    var counter = CounterTab.State()
    var profile = ProfileTab.State()
  }

  enum Action {
    case counter(CounterTab.Action)
    case profile(ProfileTab.Action)
    case selectTab(Tab)
  }

  @Dependency(StatsClient.self) var stats

  var body: some Reducer<State, Action> {
    CombineReducers {
      Scope(state: \.counter, action: \.counter) {
        CounterTab()
      }

      Scope(state: \.profile, action: \.profile) {
        ProfileTab()
      }

      Reduce { state, action in
        switch action {
        case .counter, .profile:
          return .none
        case let .selectTab(tab):
          state.currentTab = tab
          stats.modify { $0.increment() }
          //state.counter.stats.increment()
          //state.profile.stats.increment()
          return .none
        }
      }
      }
//    .onChange(of: \.counter.stats) { _, stats in
//      Reduce { state, _ in
//        state.profile.stats = stats
//        return .none
//      }
//    }
//    .onChange(of: \.profile.stats) { _, stats in
//      Reduce { state, _ in
//        state.counter.stats = stats
//        return .none
//      }
//    }
  }
}

struct SharedStateView: View {
  @Bindable var store: StoreOf<SharedState>

  var body: some View {
    TabView(selection: $store.currentTab.sending(\.selectTab)) {
      NavigationStack {
        CounterTabView(
          store: self.store.scope(state: \.counter, action: \.counter)
        )
      }
      .tag(SharedState.Tab.counter)
      .tabItem { Text("Counter") }

      NavigationStack {
        ProfileTabView(
          store: self.store.scope(state: \.profile, action: \.profile)
        )
      }
      .tag(SharedState.Tab.profile)
      .tabItem { Text("Profile") }
    }
  }
}

@dynamicMemberLookup
struct StatsClient: DependencyKey {
  var get: @Sendable () -> Stats
  var set: @Sendable (Stats) -> Void
  var stream: @Sendable () -> AsyncStream<Stats>

  static var liveValue: StatsClient {
    let stats = LockIsolated(Stats())
    return StatsClient(
      get: { stats.value },
      set: { stats.setValue($0) }
    )
  }
  static let testValue = liveValue
  func modify(_ operation: (inout Stats) -> Void) {
    var stats = self.get()
    operation(&stats)
    self.set(stats)
  }
  subscript<Value>(dynamicMember keyPath: KeyPath<Stats, Value>) -> Value {
    self.get()[keyPath: keyPath]
  }
}

struct Stats: Equatable {
  private(set) var count = 0
  private(set) var maxCount = 0
  private(set) var minCount = 0
  private(set) var numberOfCounts = 0
  mutating func increment() {
    count += 1
    numberOfCounts += 1
    maxCount = max(maxCount, count)
  }
  mutating func decrement() {
    count -= 1
    numberOfCounts += 1
    minCount = min(minCount, count)
  }
  mutating func reset() {
    self = Self()
  }
}

/// Checks if a number is prime or not.
private func isPrime(_ p: Int) -> Bool {
  if p <= 1 { return false }
  if p <= 3 { return true }
  for i in 2...Int(sqrtf(Float(p))) {
    if p % i == 0 { return false }
  }
  return true
}

#Preview {
  SharedStateView(
    store: Store(initialState: SharedState.State()) {
      SharedState()
    }
  )
}
