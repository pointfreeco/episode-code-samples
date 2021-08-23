import ComposableArchitecture
import SwiftUI

struct BindingAction<Root>: Equatable {
  let keyPath: PartialKeyPath<Root>
  let setter: (inout Root) -> Void
  let value: Any
  let valueIsEqualTo: (Any) -> Bool

  init<Value>(
    _ keyPath: WritableKeyPath<Root, Value>,
    _ value: Value
  ) where Value: Equatable {
    self.keyPath = keyPath
    self.value = value
    self.setter = { $0[keyPath: keyPath] = value }
    self.valueIsEqualTo = { $0 as? Value == value }
  }

  static func set<Value>(
    _ keyPath: WritableKeyPath<Root, BindableState<Value>>,
    _ value: Value
  ) -> Self where Value: Equatable {
    .init(keyPath.appending(path: \.wrappedValue), value)
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.keyPath == rhs.keyPath && lhs.valueIsEqualTo(rhs.value)
  }
}

extension Reducer {
  func binding(
    action bindingAction: CasePath<Action, BindingAction<State>>
  ) -> Self {
    Self { state, action, environment in
      guard let bindingAction = bindingAction.extract(from: action)
      else {
        return self.run(&state, action, environment)
      }

      bindingAction.setter(&state)
      return self.run(&state, action, environment)
    }
  }
}

extension Reducer where Action: BindableAction, Action.State == State {
  func binding() -> Self {
    Self { state, action, environment in
      guard let bindingAction = (/Action.binding).extract(from: action)
      else {
        return self.run(&state, action, environment)
      }

      bindingAction.setter(&state)
      return self.run(&state, action, environment)
    }
  }
}

extension ViewStore {
  func binding<Value>(
    keyPath: WritableKeyPath<State, BindableState<Value>>,
    send action: @escaping (BindingAction<State>) -> Action
  ) -> Binding<Value> where Value: Equatable {
    self.binding(
      get: { $0[keyPath: keyPath].wrappedValue },
      send: { action(.set(keyPath, $0)) }
    )
  }

  func binding<Value>(
    keyPath: WritableKeyPath<State, BindableState<Value>>
  ) -> Binding<Value>
  where
    Value: Equatable,
    Action: BindableAction,
    Action.State == State
  {
    self.binding(
      get: { $0[keyPath: keyPath].wrappedValue },
      send: { .binding(.set(keyPath, $0)) }
    )
  }
}

extension ViewStore {
  subscript<Value>(
    dynamicMember keyPath: WritableKeyPath<State, BindableState<Value>>
  ) -> Binding<Value>
  where Action: BindableAction, Action.State == State, Value: Equatable
  {
    self.binding(
      get: { $0[keyPath: keyPath].wrappedValue },
      send: { .binding(.set(keyPath, $0)) }
    )
  }
}

protocol BindableAction {
  associatedtype State
  static func binding(_: BindingAction<State>) -> Self
}

func ~= <Root, Value> (
  keyPath: WritableKeyPath<Root, Value>,
  bindingAction: BindingAction<Root>
) -> Bool {
  bindingAction.keyPath == keyPath
}
