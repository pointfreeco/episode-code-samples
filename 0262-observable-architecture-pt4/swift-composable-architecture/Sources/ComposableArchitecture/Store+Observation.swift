import Observation

extension Store {
  var observableState: State {
    get {
      if State.self is ObservableState.Type {
        self._$observationRegistrar.access(self, keyPath: \.observableState)
      }
      return self.stateSubject.value
    }
    set {
      if
        let old = self.stateSubject.value as? ObservableState,
        let new = newValue as? ObservableState,
        old._$id == new._$id
      {
        self.stateSubject.value = newValue
      } else {
        self._$observationRegistrar.withMutation(of: self, keyPath: \.observableState) {
          self.stateSubject.value = newValue
        }
      }
    }
  }
}

extension Store where State: ObservableState {
  public var state: State {
    self.observableState
  }

  public subscript<Member>(dynamicMember keyPath: KeyPath<State, Member>) -> Member {
    self.state[keyPath: keyPath]
  }
}

extension Store: Observable {}

import Foundation

public protocol ObservableState: Observable {
  var _$id: UUID { get }
}

extension Store where State: ObservableState {
  public func scope<ChildState, ChildAction>(
    state: KeyPath<State, ChildState?>,
    action: CaseKeyPath<Action, ChildAction>
  ) -> Store<ChildState, ChildAction>? {

    guard let childState = self.state[keyPath: state]
    else { return nil }

    return self.scope(
      state: {
        $0[keyPath: state] ?? childState
      },
      id: { _ in [state, action] as [AnyHashable] },
      action: {
        action($0)
      },
      isInvalid: {
        $0[keyPath: state] == nil
      },
      removeDuplicates: nil
    )
  }
}
