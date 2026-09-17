@dynamicMemberLookup
@MainActor
class Store<State, Action> {
  private let core: any Core<State, Action>
  init(core: some Core<State, Action>) {
    self.core = core
  }
  init(initialState: State, feature: some Feature<State, Action>) {
    let core = RootCore(
      initialState: initialState,
      feature: feature
    )
    self.core = core
    core.setIsolation(MainActor.shared)
  }
  var state: State {
    core.state
  }
  @discardableResult
  func send(_ action: Action) -> Task<Void, Never> {
    core.send(action)
  }
  subscript<Member>(dynamicMember keyPath: KeyPath<State, Member>) -> Member {
    core[dynamicMember: keyPath]
  }
  func scope<ChildState>(
    _ stateKeyPath: WritableKeyPath<State, ChildState>
  ) -> Store<ChildState, Action> {
    Store<ChildState, Action>(
      core: ScopedCore(
        base: core,
        stateKeyPath: stateKeyPath
      )
    )
  }
}

typealias StoreOf<F: Feature> = Store<F.State, F.Action>
