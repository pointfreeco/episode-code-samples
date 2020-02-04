import Combine
import SwiftUI

public struct Effect<Output>: Publisher {
  public typealias Failure = Never

  let publisher: AnyPublisher<Output, Failure>

  public func receive<S>(
    subscriber: S
  ) where S: Subscriber, Failure == S.Failure, Output == S.Input {
    self.publisher.receive(subscriber: subscriber)
  }
}

extension Effect {
  public static func fireAndForget(work: @escaping () -> Void) -> Effect {
    return Deferred { () -> Empty<Output, Never> in
      work()
      return Empty(completeImmediately: true)
    }.eraseToEffect()
  }

  public static func sync(work: @escaping () -> Output) -> Effect {
    return Deferred {
      Just(work())
    }.eraseToEffect()
  }
}

extension Publisher where Failure == Never {
  public func eraseToEffect() -> Effect<Output> {
    return Effect(publisher: self.eraseToAnyPublisher())
  }
}

public typealias Reducer<Value, Action, Environment> = (inout Value, Action, Environment) -> [Effect<Action>]

public final class Store<Value, Action>: ObservableObject {
  private let reducer: Reducer<Value, Action, Void>
  @Published public private(set) var value: Value
  private var viewCancellable: Cancellable?
  private var effectCancellables: Set<AnyCancellable> = []

  public init<Environment>(
    initialValue: Value,
    reducer: @escaping Reducer<Value, Action, Environment>,
    environment: Environment
  ) {
    self.reducer = { value, action, _ in
      reducer(&value, action, environment)
    }
    self.value = initialValue
  }

  public func send(_ action: Action) {
    let effects = self.reducer(&self.value, action, ())
    effects.forEach { effect in
      var effectCancellable: AnyCancellable?
      var didComplete = false
      effectCancellable = effect.sink(
        receiveCompletion: { [weak self] _ in
          didComplete = true
          guard let effectCancellable = effectCancellable else { return }
          self?.effectCancellables.remove(effectCancellable)
      },
        receiveValue: self.send
      )
      if !didComplete, let effectCancellable = effectCancellable {
        self.effectCancellables.insert(effectCancellable)
      }
    }
  }

  public func view<LocalValue, LocalAction>(
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
      environment: ()
    )
    localStore.viewCancellable = self.$value.sink { [weak localStore] newValue in
      localStore?.value = toLocalValue(newValue)
    }
    return localStore
  }
}

public func combine<Value, Action, Environment>(
  _ reducers: Reducer<Value, Action, Environment>...
) -> Reducer<Value, Action, Environment> {
  return { value, action, environment in
    let effects = reducers.flatMap { $0(&value, action, environment) }
    return effects
  }
}


//struct CasePath<Root, Value> {
//  let extract: (Root) -> Value?
//  let embed: (Value) -> Root
//}

import CasePaths

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

extension Publisher {
  func cancellable<Id: Hashable>(id: Id) -> AnyPublisher<Output, Failure> {
    return Deferred { () -> PassthroughSubject<Output, Failure> in
      cancellables[id]?.cancel()
      let subject = PassthroughSubject<Output, Failure>()
      cancellables[id] = self.subscribe(subject)
      return subject
    }
    .eraseToAnyPublisher()
  }
}

private var cancellables: [AnyHashable: AnyCancellable] = [:]
