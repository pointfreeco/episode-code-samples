import CasePaths
import Combine
import SwiftUI

public typealias Reducer<Value, Action, Environment> = (inout Value, Action, Environment) -> [Effect<Action>]

public func combine<Value, Action, Environment>(
  _ reducers: Reducer<Value, Action, Environment>...
) -> Reducer<Value, Action, Environment> {
  return { value, action, environment in
    let effects = reducers.flatMap { $0(&value, action, environment) }
    return effects
  }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction, LocalEnvironment, GlobalEnvironment>(
  _ reducer: @escaping Reducer<LocalValue, LocalAction, LocalEnvironment>,
  value: WritableKeyPath<GlobalValue, LocalValue>,
  action: CasePath<GlobalAction, LocalAction>,
  environment: @escaping (GlobalEnvironment) -> LocalEnvironment
) -> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
  return { globalValue, globalAction, globalEnvironment in
    guard let localAction = action.extract(from: globalAction) else { return [] }
    let localEffects = reducer(&globalValue[keyPath: value], localAction, environment(globalEnvironment))

    return localEffects.map { localEffect in
      localEffect.map(action.embed)
        .eraseToEffect()
    }
  }
}

public func logging<Value, Action, Environment>(
  _ reducer: @escaping Reducer<Value, Action, Environment>
) -> Reducer<Value, Action, Environment> {
  return { value, action, environment in
    let effects = reducer(&value, action, environment)
    let newValue = value
    return [.fireAndForget {
      print("Action: \(action)")
      print("Value:")
      dump(newValue)
      print("---")
      }] + effects
  }
}

public final class ViewStore<Value>: ObservableObject {
  @Published public fileprivate(set) var value: Value
  fileprivate var cancellable: Cancellable?
  
  public init(initialValue value: Value) {
    self.value = value
  }
}

extension Store where Value: Equatable {
  public var view: ViewStore<Value> {
    self.view(removeDuplicates: ==)
  }
}

extension Store {
  public func view(
    removeDuplicates predicate: @escaping (Value, Value) -> Bool
  ) -> ViewStore<Value> {
    let viewStore = ViewStore(initialValue: self.value)
    
    viewStore.cancellable = self.$value
      .removeDuplicates(by: predicate)
      .sink(receiveValue: { [weak viewStore] value in
        viewStore?.value = value
        self
      })
    
    return viewStore
  }
}

public final class Store<Value, Action> /*: ObservableObject */ {
  private let reducer: Reducer<Value, Action, Any>
  private let environment: Any
  @Published private var value: Value
  private var viewCancellable: Cancellable?
  private var effectCancellables: Set<AnyCancellable> = []

  public init<Environment>(
    initialValue: Value,
    reducer: @escaping Reducer<Value, Action, Environment>,
    environment: Environment
  ) {
    self.reducer = { value, action, environment in
      reducer(&value, action, environment as! Environment)
    }
    self.value = initialValue
    self.environment = environment
  }

  public func send(_ action: Action) {
    let effects = self.reducer(&self.value, action, self.environment)
    effects.forEach { effect in
      var effectCancellable: AnyCancellable?
      var didComplete = false
      effectCancellable = effect.sink(
        receiveCompletion: { [weak self, weak effectCancellable] _ in
          didComplete = true
          guard let effectCancellable = effectCancellable else { return }
          self?.effectCancellables.remove(effectCancellable)
      },
        receiveValue: { [weak self] in self?.send($0) }
      )
      if !didComplete, let effectCancellable = effectCancellable {
        self.effectCancellables.insert(effectCancellable)
      }
    }
  }

  public func scope<LocalValue, LocalAction>(
    value toLocalValue: @escaping (Value) -> LocalValue,
    action toGlobalAction: @escaping (LocalAction) -> Action
  ) -> Store<LocalValue, LocalAction> {
    let localStore = Store<LocalValue, LocalAction>(
      initialValue: toLocalValue(self.value),
      reducer: { localValue, localAction, _ in
        self.send(toGlobalAction(localAction))
        localValue = toLocalValue(self.value)
        return []
    },
      environment: self.environment
    )
    localStore.viewCancellable = self.$value
      .map(toLocalValue)
//      .removeDuplicates()
      .sink { [weak localStore] newValue in
        localStore?.value = newValue
      }
    return localStore
  }
}
