import Observation

@dynamicMemberLookup
@MainActor
@Observable
class Store<State, Action> {
  var state: State
  var feature: any Feature<State, Action>
  init(initialState: State, feature: some Feature<State, Action>) {
    self.state = initialState
    self.feature = feature
  }
  func send(_ action: Action) {
    feature._update(self, action: action)
  }
  subscript<Member>(dynamicMember keyPath: KeyPath<State, Member>) -> Member {
    state[keyPath: keyPath]
  }

  func addTask(operation: sending @MainActor @escaping () async throws -> Void) {
    Task {
      try await operation()
    }
  }
}

typealias StoreOf<F: Feature> = Store<F.State, F.Action>
