import ComposableArchitecture

func pullback<GlobalValue, LocalValue, GlobalAction, LocalAction>(
  reducer: @escaping Reducer<LocalValue, LocalAction>,
  value: WritableKeyPath<GlobalValue, LocalValue>,
  action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
  return { globalValue, globalAction in
    guard let localAction = globalAction[keyPath: action] else { return [] }
    let localEffects = reducer(&globalValue[keyPath: value], localAction)
    return localEffects
      .map { localEffect in
        localEffect
          .map { localAction in
            var globalAction = globalAction
            globalAction[keyPath: action] = localAction
            return globalAction
        }
      .eraseToEffect()
    }
  }
}


