import Combine

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

extension Publisher where Output == Never, Failure == Never {
  public func fireAndForget<A>() -> Effect<A> {
    return self.map(absurd).eraseToEffect()
  }
}

private func absurd<A>(_ never: Never) -> A {}
