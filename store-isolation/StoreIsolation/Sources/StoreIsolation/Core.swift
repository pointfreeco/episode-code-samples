import Observation

@dynamicMemberLookup
@Observable
class Core<State, Action> {
  var state: State
  var feature: any Feature<State, Action>
  var isolation: any Actor!
  init(
    initialState: State,
    feature: some Feature<State, Action>
  ) {
    self.state = initialState
    self.feature = feature
  }
  func setIsolation(_ isolation: isolated any Actor) {
    precondition(self.isolation == nil)
    self.isolation = isolation
  }
  func send(_ action: Action) {
    feature._update(self, action: action)
  }
  subscript<Member>(dynamicMember keyPath: KeyPath<State, Member>) -> Member {
    state[keyPath: keyPath]
  }

  func addTask(operation: nonisolated(nonsending) @escaping () async throws -> Void) {
    nonisolated(unsafe) let operation = operation
    isolation.assumeIsolated { _ in
      Task.immediate {
        try await operation()
      }
    }
  }
}
