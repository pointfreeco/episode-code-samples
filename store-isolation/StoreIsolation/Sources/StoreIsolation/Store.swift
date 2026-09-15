@dynamicMemberLookup
@MainActor
class Store<State, Action> {
  let core: Core<State, Action>
  init(core: Core<State, Action>) {
    self.core = core
  }
  init(initialState: State, feature: some Feature<State, Action>) {
    core = Core(initialState: initialState, feature: feature)
  }
  var state: State {
    core.state
  }
  func send(_ action: Action) {
    core.send(action)
  }
  subscript<Member>(dynamicMember keyPath: KeyPath<State, Member>) -> Member {
    core[dynamicMember: keyPath]
  }
}

typealias StoreOf<F: Feature> = Store<F.State, F.Action>
