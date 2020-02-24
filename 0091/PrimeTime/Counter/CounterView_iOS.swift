#if os(iOS)
import ComposableArchitecture
import PrimeAlert
import PrimeModal
import SwiftUI

public enum CounterViewAction: Equatable {
  case counter(CounterAction)
  case primeModal(PrimeModalAction)
}

public struct CounterView: View {
  struct State: Equatable {
    let alertNthPrime: PrimeAlert?
    let count: Int
    let isNthPrimeButtonDisabled: Bool
    let isPrimeModalShown: Bool
    let isDecrementButtonDisabled: Bool
    let isIncrementButtonDisabled: Bool
    let nthPrimeButtonTitle: String
  }
  enum Action {
    case decrTapped
    case incrTapped
    case nthPrimeButtonTapped
    case alertDismissButtonTapped
    case isPrimeButtonTapped
    case primeModalDismissed
    case doubleTap
  }

  let store: Store<CounterViewState, CounterViewAction>
  @ObservedObject var viewStore: ViewStore<State, Action>

  public init(store: Store<CounterViewState, CounterViewAction>) {
    self.store = store
    self.viewStore = self.store
      .scope(
        value: State.init(counterViewState:),
        action: Action.from(counterViewAction:)
    ).view
    print("CounterView.init")
  }

  public var body: some View {
    print("CounterView.body")
    return VStack {
      HStack {
        Button("-") { self.viewStore.send(.decrTapped) }
          .disabled(self.viewStore.value.isDecrementButtonDisabled)
        Text("\(self.viewStore.value.count)")
        Button("+") { self.viewStore.send(.incrTapped) }
          .disabled(self.viewStore.value.isIncrementButtonDisabled)
      }
      Button("Is this prime?") { self.viewStore.send(.isPrimeButtonTapped) }
      Button(self.viewStore.value.nthPrimeButtonTitle) {
        self.viewStore.send(.nthPrimeButtonTapped)
      }
      .disabled(self.viewStore.value.isNthPrimeButtonDisabled)
    }
    .font(.title)
    .navigationBarTitle("Counter demo")
    .popover(
      isPresented: Binding(
        get: { self.viewStore.value.isPrimeModalShown },
        set: { _ in self.viewStore.send(.primeModalDismissed) }
      )
    ) {
      IsPrimeModalView(
        store: self.store.scope(
          value: { ($0.count, $0.favoritePrimes) },
          action: { .primeModal($0) }
        )
      )
    }
    .alert(
      item: .constant(self.viewStore.value.alertNthPrime)
    ) { alert in
      Alert(
        title: Text(alert.title),
        dismissButton: .default(Text("Ok")) {
          self.viewStore.send(.alertDismissButtonTapped)
        }
      )
    }
     .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
     .background(Color.white)
     .onTapGesture(count: 2) {
       self.viewStore.send(.doubleTap)
     }
  }
}

extension CounterView.State {
  init(counterViewState state: CounterViewState) {
    self.alertNthPrime = state.alertNthPrime
    self.count = state.count
    self.isNthPrimeButtonDisabled = state.isNthPrimeRequestInFlight
    self.isDecrementButtonDisabled = state.isNthPrimeRequestInFlight
    self.isIncrementButtonDisabled = state.isNthPrimeRequestInFlight
    self.isPrimeModalShown = state.isPrimeDetailShown
    self.nthPrimeButtonTitle = "What is the \(ordinal(state.count)) prime?"
  }
}

extension CounterView.Action {
  static func from(counterViewAction action: CounterView.Action) -> CounterViewAction {
    switch action {
    case .decrTapped:
      return .counter(.decrTapped)
    case .incrTapped:
      return .counter(.incrTapped)
    case .nthPrimeButtonTapped:
      return .counter(.requestNthPrime)
    case .alertDismissButtonTapped:
      return .counter(.alertDismissButtonTapped)
    case .isPrimeButtonTapped:
      return .counter(.isPrimeButtonTapped)
    case .primeModalDismissed:
      return .counter(.primeDetailDismissed)
    case .doubleTap:
      return .counter(.requestNthPrime)
    }
  }
}
#endif
