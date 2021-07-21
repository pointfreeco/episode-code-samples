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
    _ keyPath: WritableKeyPath<Root, Value>,
    _ value: Value
  ) -> Self where Value: Equatable {
    .init(keyPath, value)
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

extension ViewStore {
  func binding<Value>(
    keyPath: WritableKeyPath<State, Value>,
    send action: @escaping (BindingAction<State>) -> Action
  ) -> Binding<Value> where Value: Equatable {
    self.binding(
      get: { $0[keyPath: keyPath] },
      send: { action(.set(keyPath, $0)) }
    )
  }
}

func ~= <Root, Value> (
  keyPath: WritableKeyPath<Root, Value>,
  bindingAction: BindingAction<Root>
) -> Bool {
  bindingAction.keyPath == keyPath
}
