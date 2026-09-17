actor StoreActor<State, Action> {
  private let core: any Core<State, Action>
  init(core: some Core<State, Action>) {
    self.core = core
  }
  init(
    initialState: State,
    feature: some Feature<State, Action>
  ) async {
    let core = RootCore(
      initialState: initialState,
      feature: feature
    )
    self.core = core
    core.setIsolation(self)
  }
  var state: State {
    core.state
  }
  @discardableResult
  func send(_ action: Action) -> Task<Void, Never> {
    core.send(action)
  }
  func scope<ChildState>(
    _ stateKeyPath: WritableKeyPath<State, ChildState>
  ) -> StoreActor<ChildState, Action> {
    nonisolated(unsafe) let core = ScopedCore(
      base: core,
      stateKeyPath: stateKeyPath
    )
    return StoreActor<ChildState, Action>(
      core: core
    )
  }
}
