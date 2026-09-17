actor StoreActor<State, Action> {
  private let core: Core<State, Action>
  init(core: Core<State, Action>) {
    self.core = core
  }
  init(
    initialState: State,
    feature: some Feature<State, Action>
  ) async {
    core = Core(
      initialState: initialState,
      feature: feature
    )
    core.setIsolation(self)
  }
  var state: State {
    core.state
  }
  @discardableResult
  func send(_ action: Action) -> Task<Void, Never> {
    core.send(action)
  }
}
