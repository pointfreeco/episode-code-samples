protocol Feature<State, Action> {
  associatedtype State
  associatedtype Action
  func _update(_ store: Store<State, Action>, action: Action)
}
