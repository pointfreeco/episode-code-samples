import Observation

extension Store {
  var observableState: State {
    get {
      self._$observationRegistrar.access(self, keyPath: \.observableState)
      return self.stateSubject.value
    }
    set {
      self._$observationRegistrar.withMutation(of: self, keyPath: \.observableState) {
        self.stateSubject.value = newValue
      }
    }
  }
}

extension Store where State: Observable {
  public var state: State {
    self.observableState
  }

  public subscript<Member>(dynamicMember keyPath: KeyPath<State, Member>) -> Member {
    self.state[keyPath: keyPath]
  }
}

extension Store: Observable {}
