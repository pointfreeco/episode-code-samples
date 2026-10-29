actor StoreActor<State, Action> {
  private let core: any Core<State, Action>
  private let isolation: any Actor
  init(core: some Core<State, Action>, isolation: any Actor) {
    self.core = core
    self.isolation = isolation
  }
  init(
    initialState: State,
    feature: some Feature<State, Action>
  ) {
    let rootIsolation = RootIsolation()
    let core = RootCore(
      initialState: initialState,
      feature: feature,
      isolation: rootIsolation
    )
    self.core = core
    self.isolation = rootIsolation
  }
  nonisolated var unownedExecutor: UnownedSerialExecutor {
    unsafe isolation.unownedExecutor
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
      core: unsafe core,
      isolation: isolation
    )
  }

  private actor RootIsolation {}
}
