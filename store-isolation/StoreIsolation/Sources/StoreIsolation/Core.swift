import Observation

@dynamicMemberLookup
protocol Core<State, Action>: AnyObject {
  associatedtype State
  associatedtype Action
  var state: State { get set }
  func send(_ action: Action) -> Task<Void, Never>
  func addTask(
    operation: nonisolated(nonsending) @escaping () async throws -> Void
  )
}
extension Core {
  subscript<Member>(dynamicMember keyPath: KeyPath<State, Member>) -> Member {
    state[keyPath: keyPath]
  }
}

@Observable
class RootCore<State, Action>: Core {
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
    return isolation.assumeIsolated { isolation in
      Task.immediate {
        let tasks = operations.map { operation in
          nonisolated(unsafe) let operation = operation
          return isolation.assumeIsolated { _ in
            Task.immediate {
              try await operation()
            }
          }
        }
        for task in tasks { try? await task.value }
      }
    }
  }

  func addTask(operation: nonisolated(nonsending) @escaping () async throws -> Void) {
    operations.append(operation)
  }
}

class ScopedCore<BaseState, BaseAction, ChildState>: Core {
  let base: any Core<BaseState, BaseAction>
  let stateKeyPath: WritableKeyPath<BaseState, ChildState>
  init(
    base: any Core<BaseState, BaseAction>,
    stateKeyPath: WritableKeyPath<BaseState, ChildState>
  ) {
    self.base = base
    self.stateKeyPath = stateKeyPath
  }
  var state: ChildState {
    get { base.state[keyPath: stateKeyPath] }
    set { base.state[keyPath: stateKeyPath] = newValue }
  }
  func send(_ action: BaseAction) -> Task<Void, Never> {
    base.send(action)
  }
  func addTask(operation: nonisolated(nonsending) @escaping () async throws -> Void) {
    base.addTask(operation: operation)
  }
}
