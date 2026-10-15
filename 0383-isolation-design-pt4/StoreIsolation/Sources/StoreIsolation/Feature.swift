protocol Feature<State, Action> {
  associatedtype State
  associatedtype Action
  func _update(_ core: Core<State, Action>, action: Action)
}
