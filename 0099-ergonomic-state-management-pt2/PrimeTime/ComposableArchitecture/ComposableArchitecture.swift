import CasePaths
import Combine
import SwiftUI

//(inout RandomNumberGenerator) -> A
struct Gen<A> {
  let run: (inout RandomNumberGenerator) -> A
}

//(inout Substring) -> A?
struct Parser<A> {
  let run: (inout Substring) -> A?
}

//(@escaping (A) -> Void) -> Void
//struct Effect<A> {
//  let run: (@escaping (A) -> Void) -> Void
//}

//public typealias Reducer<Value, Action, Environment> = (inout Value, Action, Environment) -> [Effect<Action>]
public struct Reducer<Value, Action, Environment> {
  let reducer: (inout Value, Action, Environment) -> [Effect<Action>]
  
  public init(_ reducer: @escaping (inout Value, Action, Environment) -> [Effect<Action>]) {
    self.reducer = reducer
  }
}

extension Reducer {
  public func callAsFunction(_ value: inout Value, _ action: Action, _ environment: Environment) -> [Effect<Action>] {
    self.reducer(&value, action, environment)
  }
}

extension Reducer {
  public static func combine(_ reducers: Reducer...) -> Reducer {
    .init { value, action, environment in
      let effects = reducers.flatMap { $0(&value, action, environment) }
      return effects
    }
  }
}

//public func combine<Value, Action, Environment>(
//  _ reducers: Reducer<Value, Action, Environment>...
//) -> Reducer<Value, Action, Environment> {
//  .init { value, action, environment in
//    let effects = reducers.flatMap { $0(&value, action, environment) }
//    return effects
//  }
//}

extension Reducer {
  public func pullback<GlobalValue, GlobalAction, GlobalEnvironment>(
    value: WritableKeyPath<GlobalValue, Value>,
    action: CasePath<GlobalAction, Action>,
    environment: @escaping (GlobalEnvironment) -> Environment
  ) -> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
    .init { globalValue, globalAction, globalEnvironment in
      guard let localAction = action.extract(from: globalAction) else { return [] }
      let localEffects = self(&globalValue[keyPath: value], localAction, environment(globalEnvironment))

      return localEffects.map { localEffect in
        localEffect.map(action.embed)
          .eraseToEffect()
      }
    }
  }
}

//public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction, LocalEnvironment, GlobalEnvironment>(
//  _ reducer: Reducer<LocalValue, LocalAction, LocalEnvironment>,
//  value: WritableKeyPath<GlobalValue, LocalValue>,
//  action: CasePath<GlobalAction, LocalAction>,
//  environment: @escaping (GlobalEnvironment) -> LocalEnvironment
//) -> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
//  return .init { globalValue, globalAction, globalEnvironment in
//    guard let localAction = action.extract(from: globalAction) else { return [] }
//    let localEffects = reducer(&globalValue[keyPath: value], localAction, environment(globalEnvironment))
//
//    return localEffects.map { localEffect in
//      localEffect.map(action.embed)
//        .eraseToEffect()
//    }
//  }
//}

extension Reducer {
  public func logging(
    printer: @escaping (Environment) -> (String) -> Void = { _ in { print($0) } }
  ) -> Reducer {
    .init { value, action, environment in
      let effects = self(&value, action, environment)
      let newValue = value
      let print = printer(environment)
      return [.fireAndForget {
        print("Action: \(action)")
        print("Value:")
        var dumpedNewValue = ""
        dump(newValue, to: &dumpedNewValue)
        print(dumpedNewValue)
        print("---")
        }] + effects
    }
  }
}

//public func logging<Value, Action, Environment>(
//  _ reducer: Reducer<Value, Action, Environment>
//) -> Reducer<Value, Action, Environment> {
//  return .init { value, action, environment in
//    let effects = reducer(&value, action, environment)
//    let newValue = value
//    return [.fireAndForget {
//      print("Action: \(action)")
//      print("Value:")
//      dump(newValue)
//      print("---")
//      }] + effects
//  }
//}

public final class Store<Value, Action> {
  private let reducer: Reducer<Value, Action, Any>
  private let environment: Any
  @Published private var value: Value
  private var viewCancellable: Cancellable?
  private var effectCancellables: Set<AnyCancellable> = []

  public init<Environment>(
    initialValue: Value,
    reducer: Reducer<Value, Action, Environment>,
    environment: Environment
  ) {
    self.reducer = .init { value, action, environment in
      reducer(&value, action, environment as! Environment)
    }
    self.value = initialValue
    self.environment = environment
  }

  private func send(_ action: Action) {
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
      reducer: .init { localValue, localAction, _ in
        self.send(toGlobalAction(localAction))
        localValue = toLocalValue(self.value)
        return []
    },
      environment: self.environment
    )
    localStore.viewCancellable = self.$value
      .map(toLocalValue)
      .sink { [weak localStore] newValue in
        localStore?.value = newValue
      }
    return localStore
  }
}

@dynamicMemberLookup
public final class ViewStore<Value, Action>: ObservableObject {
  @Published public fileprivate(set) var value: Value
  fileprivate var cancellable: Cancellable?
  public let send: (Action) -> Void
  
  public subscript<LocalValue>(dynamicMember keyPath: KeyPath<Value, LocalValue>) -> LocalValue {
    self.value[keyPath: keyPath]
  }

  public init(
    initialValue value: Value,
    send: @escaping (Action) -> Void
  ) {
    self.value = value
    self.send = send
  }
}

extension Store where Value: Equatable {
  public var view: ViewStore<Value, Action> {
    self.view(removeDuplicates: ==)
  }
}

extension Store {
  public func view(
    removeDuplicates predicate: @escaping (Value, Value) -> Bool
  ) -> ViewStore<Value, Action> {
    let viewStore = ViewStore(
      initialValue: self.value,
      send: self.send
    )

    viewStore.cancellable = self.$value
      .removeDuplicates(by: predicate)
      .sink(receiveValue: { [weak viewStore] value in
        viewStore?.value = value
      })

    return viewStore
  }
}
