import Observation

@dynamicMemberLookup
@Observable
class Core<State, Action> {
  var state: State
  var feature: any Feature<State, Action>
  var isolation: any Actor!
  var operations: [nonisolated(nonsending) () async throws -> Void] = []
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
  func send(_ action: Action) -> Task<Void, Never> {
    feature._update(self, action: action)
    nonisolated(unsafe) let operations = operations
    self.operations.removeAll()
    return Task.immediate { [isolation] in
      let tasks = operations.map { operation in
        nonisolated(unsafe) let operation = operation
        return isolation!.assumeIsolated { _ in
          return Task.immediate {
            try await operation()
          }
        }
      }
      for task in tasks { try? await task.value }
    }
  }
  subscript<Member>(dynamicMember keyPath: KeyPath<State, Member>) -> Member {
    state[keyPath: keyPath]
  }

  func addTask(
    operation: nonisolated(nonsending) @escaping () async throws -> Void
  ) {
    operations.append(operation)
  }
}
