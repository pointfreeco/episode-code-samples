import Observation
import SwiftUI

extension Binding {
  public func scope<State: ObservableState, Action, ChildState, ChildAction>(
    state: KeyPath<State, ChildState?>,
    action: CaseKeyPath<Action, PresentationAction<ChildAction>>
  )
  -> Binding<Store<ChildState, ChildAction>?>
  where
    Value == Store<State, Action>
  {
    Binding<Store<ChildState, ChildAction>?>(
      get: {
        self.wrappedValue.scope(
          state: state,
          action: action.appending(path: \.presented)
        )
      },
      set: { childStore in
        if childStore == nil {
          self.wrappedValue.send(action(.dismiss))
        }
      }
    )
  }
}

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

extension Store
where
  State: ObservableState,
  Action: BindableAction,
  Action.State == State
{
  public subscript<Member: Equatable>(dynamicMember keyPath: WritableKeyPath<State, Member>) -> Member {
    get {
      self.state[keyPath: keyPath]
    }
    set {
      self.send(.binding(.set(keyPath, newValue)))
    }
  }
}

extension BindingAction {
  public static func set<Value: Equatable & Sendable>(
    _ keyPath: WritableKeyPath<Root, Value>,
    _ value: Value
  ) -> Self
  where Root: ObservableState
  {
    return .init(
      keyPath: keyPath,
      set: { $0[keyPath: keyPath] = value },
      value: AnySendable(value),
      valueIsEqualTo: {
        ($0 as? AnySendable)?.base as? Value == value
      }
    )
  }

  public static func ~= <Value>(
    keyPath: WritableKeyPath<Root, Value>,
    bindingAction: Self
  ) -> Bool {
    keyPath == bindingAction.keyPath
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

import OrderedCollections
public struct StoreCollection<ID: Hashable, State, Action>: RandomAccessCollection {
  private let store: Store<
    IdentifiedArray<ID, State>,
    IdentifiedAction<ID, Action>
  >
  private let ids: OrderedSet<ID>
  init(store: Store<IdentifiedArray<ID, State>, IdentifiedAction<ID, Action>>) {
    self.store = store
    self.ids = store.stateSubject.value.ids
  }

  public var startIndex: Int {
    self.ids.startIndex
  }
  public var endIndex: Int {
    self.ids.endIndex
  }

  public subscript(position: Int) -> Store<State, Action> {
    let id = self.ids[position]
    return self.store.scope(
      state: {
        $0[id: id]!
      },
      id: { _ in id },
      action: {
        .element(id: id, action: $0)
      },
      isInvalid: {
        !$0.ids.contains(id)
      },
      removeDuplicates: nil
    )
  }
}

extension Store where State: ObservableState {
  public func scope<ElementID, ElementState, ElementAction>(
    state: KeyPath<State, IdentifiedArray<ElementID, ElementState>>,
    action: CaseKeyPath<Action, IdentifiedAction<ElementID, ElementAction>>
  //) -> [Store<ElementState, ElementAction>] {
  ) -> StoreCollection<ElementID, ElementState, ElementAction> {

    StoreCollection(store: self.scope(state: state, action: action))
  }
}

extension Store: Identifiable {}

public func _$isIdentityEqual<T>(_ lhs: T, _ rhs: T) -> Bool {
  if let lhs = lhs as? ObservableState,
     let rhs = rhs as? ObservableState {
    return lhs._$id == rhs._$id
  } else {
    return false
  }
}

public func _$isIdentityEqual<T>(
  _ lhs: IdentifiedArrayOf<T>,
  _ rhs: IdentifiedArrayOf<T>
) -> Bool {
  areOrderedSetsDuplicates(lhs.ids, rhs.ids)
}
