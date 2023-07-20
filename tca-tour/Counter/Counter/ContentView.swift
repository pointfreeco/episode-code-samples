import ComposableArchitecture
import SwiftUI

struct CounterFeature: Reducer {
  struct State: Equatable {
    var count = 0
    var fact: String?
    var isTimerOn = false
  }
  enum Action {
    case decrementButtonTapped
    case getFactButtonTapped
    case incrementButtonTapped
    case toggleTimerButtonTapped
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .decrementButtonTapped:
        state.count -= 1
        return .none

      case .getFactButtonTapped:
        // TODO: perform network request
        return .none

      case .incrementButtonTapped:
        state.count += 1
        return .none

      case .toggleTimerButtonTapped:
        state.isTimerOn.toggle()
        // TODO: start a timer
        return .none
      }
    }
  }
}

struct ContentView: View {
  let store: StoreOf<CounterFeature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Section {
          Text("\(viewStore.count)")
          Button("Decrement") {
            viewStore.send(.decrementButtonTapped)
          }
          Button("Increment") {
            viewStore.send(.incrementButtonTapped)
          }
        }
        Section {
          Button("Get fact") {
            viewStore.send(.getFactButtonTapped)
          }
          if let fact = viewStore.fact {
            Text(fact)
          }
        }
        Section {
          if viewStore.isTimerOn {
            Button("Stop timer") {
              viewStore.send(.toggleTimerButtonTapped)
            }
          } else {
            Button("Start timer") {
              viewStore.send(.toggleTimerButtonTapped)
            }
          }
        }
      }
    }
  }
}

#Preview {
  ContentView(
    store: Store(initialState: CounterFeature.State()) {
      CounterFeature()
        ._printChanges()
    }
  )
}
