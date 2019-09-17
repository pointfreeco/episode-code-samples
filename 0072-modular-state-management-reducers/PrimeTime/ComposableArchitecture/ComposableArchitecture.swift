import Combine
import SwiftUI

public final class Store<Value, Action>: ObservableObject {
  private let reducer: (inout Value, Action) -> Void
  @Published public private(set) var value: Value
  private let objectDidChange = PassthroughSubject<Void, Never>()
  private var cancellable: Cancellable?

  public init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
    self.reducer = reducer
    self.value = initialValue
  }

  public func send(_ action: Action) {
    self.reducer(&self.value, action)
    self.objectDidChange.send()
  }

  public func view<LocalValue, LocalAction>(
    value: @escaping (Value) -> LocalValue,
    action: @escaping (LocalAction) -> Action
  ) -> Store<LocalValue, LocalAction> {
    let store = Store<LocalValue, LocalAction>(
      initialValue: value(self.value)
    ) { localValue, localAction in
      self.send(action(localAction))
      localValue = value(self.value)
    }
    store.cancellable = self.objectDidChange.sink { [weak store] in
      store?.value = value(self.value)
    }
    return store
  }
}

public func combine<Value, Action>(
  _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
  return { value, action in
    for reducer in reducers {
      reducer(&value, action)
    }
  }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
  _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
  value: WritableKeyPath<GlobalValue, LocalValue>,
  action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
  return { globalValue, globalAction in
    guard let localAction = globalAction[keyPath: action] else { return }
    reducer(&globalValue[keyPath: value], localAction)
  }
}

public func logging<Value, Action>(
  _ reducer: @escaping (inout Value, Action) -> Void
) -> (inout Value, Action) -> Void {
  return { value, action in
    reducer(&value, action)
    print("Action: \(action)")
    print("Value:")
    dump(value)
    print("---")
  }
}

