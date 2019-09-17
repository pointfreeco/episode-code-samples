import ComposableArchitecture
import PrimeModal

public struct CounterViewState {
  public var count: Int
  public var primeModal: PrimeModalState

  public init(count: Int, primeModal: PrimeModalState) {
    self.count = count
    self.primeModal = primeModal
  }
}

public enum CounterViewAction {
  case counter(CounterAction)
  case primeModal(PrimeModalAction)

  var counter: CounterAction? {
    get {
      guard case let .counter(value) = self else { return nil }
      return value
    }
    set {
      guard case .counter = self, let newValue = newValue else { return }
      self = .counter(newValue)
    }
  }

  var primeModal: PrimeModalAction? {
    get {
      guard case let .primeModal(value) = self else { return nil }
      return value
    }
    set {
      guard case .primeModal = self, let newValue = newValue else { return }
      self = .primeModal(newValue)
    }
  }
}

public let counterViewReducer = combine(
  pullback(counterReducer, value: \CounterViewState.count, action: \CounterViewAction.counter),
  pullback(primeModalReducer, value: \.primeModal, action: \.primeModal)
)

public enum CounterAction {
  case decrTapped
  case incrTapped
}

public func counterReducer(state: inout Int, action: CounterAction) {
  switch action {
  case .decrTapped:
    state -= 1

  case .incrTapped:
    state += 1
  }
}
