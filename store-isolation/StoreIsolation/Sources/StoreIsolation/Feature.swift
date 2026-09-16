protocol Feature<State, Action> {
  associatedtype State
  associatedtype Action
  func _update(_ core: some Core<State, Action>, action: Action)
}
