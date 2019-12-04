import Combine
import SwiftUI
import RxSwift

//public struct Effect<A> {
//  public let run: (@escaping (A) -> Void) -> Void
//
//  public init(run: @escaping (@escaping (A) -> Void) -> Void) {
//    self.run = run
//  }
//
//  public func map<B>(_ f: @escaping (A) -> B) -> Effect<B> {
//    return Effect<B> { callback in self.run { a in callback(f(a)) } }
//  }
//}

public struct Effect<Element>: ObservableType {
  let _source: Observable<Element>

  init(_ source: Observable<Element>) {
    self._source = source
  }

  public func subscribe<Observer>(
    _ observer: Observer
  ) -> Disposable where Observer : ObserverType, Element == Observer.Element {
    _source.subscribe(observer)
  }
}

extension ObservableType {
  public func asEffect() -> Effect<Element> {
    return Effect(self.asObservable())
  }
}

public typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

public final class Store<Value, Action>: ObservableObject {
  private let reducer: Reducer<Value, Action>
  @Published public private(set) var value: Value
  private var viewCancellable: Cancellable?
  private let bag = DisposeBag()
  private var effectCancellables: Set<AnyCancellable> = []

  public init(initialValue: Value, reducer: @escaping Reducer<Value, Action>) {
    self.reducer = reducer
    self.value = initialValue
  }

  public func send(_ action: Action) {
    let effects = self.reducer(&self.value, action)
    effects.forEach { effect in
      effect
        .subscribe({ [weak self] (event) in
          switch event {
          case let .next(action):
            self?.send(action)
          case .error(_):
            fatalError("Effect contract violation: received an error.")
          case .completed:
            break // just no-op
          }
        })
        .disposed(by: bag)
    }
  }

  public func view<LocalValue, LocalAction>(
    value toLocalValue: @escaping (Value) -> LocalValue,
    action toGlobalAction: @escaping (LocalAction) -> Action
  ) -> Store<LocalValue, LocalAction> {
    let localStore = Store<LocalValue, LocalAction>(
      initialValue: toLocalValue(self.value),
      reducer: { localValue, localAction in
        self.send(toGlobalAction(localAction))
        localValue = toLocalValue(self.value)
        return []
    }
    )
    localStore.viewCancellable = self.$value.sink { [weak localStore] newValue in
      localStore?.value = toLocalValue(newValue)
    }
    return localStore
  }
}

public func combine<Value, Action>(
  _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
  return { value, action in
    let effects = reducers.flatMap { $0(&value, action) }
    return effects
  }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
  _ reducer: @escaping Reducer<LocalValue, LocalAction>,
  value: WritableKeyPath<GlobalValue, LocalValue>,
  action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
  return { globalValue, globalAction in
    guard let localAction = globalAction[keyPath: action] else { return [] }
    let localEffects = reducer(&globalValue[keyPath: value], localAction)

    return localEffects.map { localEffect in
      localEffect.map { localAction -> GlobalAction in
        var globalAction = globalAction
        globalAction[keyPath: action] = localAction
        return globalAction
      }
      .asEffect()
//      Effect { callback in
//        localEffect.sink { localAction in
//          var globalAction = globalAction
//          globalAction[keyPath: action] = localAction
//          callback(globalAction)
//        }
//      }
    }
  }
}

public func logging<Value, Action>(
  _ reducer: @escaping Reducer<Value, Action>
) -> Reducer<Value, Action> {
  return { value, action in
    let effects = reducer(&value, action)
    let newValue = value
    return [.fireAndForget {
      print("Action: \(action)")
      print("Value:")
      dump(newValue)
      print("---")
      }] + effects
  }
}

extension Effect {
  public static func fireAndForget(work: @escaping () -> Void) -> Effect {
    return Observable.create { (observer) -> Disposable in
      work()
      observer.onCompleted()
      return Disposables.create()
    }
    .asEffect()
  }
}
