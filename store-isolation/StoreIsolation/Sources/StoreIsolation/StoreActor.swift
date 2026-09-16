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
  func send(_ action: Action) {
    core.send(action)
  }
}
