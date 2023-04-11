import ComposableArchitecture
import SwiftUI

struct CounterFeature: Reducer {
  struct State: Equatable {
    var count = 0
    var isTimerOn = false
  }
  enum Action {
    case decrementButtonTapped
    case incrementButtonTapped
    case timerTick
    case toggleTimerButtonTapped
  }
  private enum CancelID { case timer }
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .decrementButtonTapped:
      state.count -= 1
      return .none
    case .incrementButtonTapped:
      state.count += 1
      return .none

    case .timerTick:
      state.count += 1
      return .none

    case .toggleTimerButtonTapped:
      state.isTimerOn.toggle()
      if state.isTimerOn {
        // Start up a timer
        return .run { send in
          while true {
            try await Task.sleep(for: .seconds(1))
            await send(.timerTick)
          }
        }
        .cancellable(id: CancelID.timer)
      } else {
        return .cancel(id: CancelID.timer)
      }
    }
  }
}

struct CounterView: View {
  let store: StoreOf<CounterFeature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        HStack {
          Button("-") {
            viewStore.send(.decrementButtonTapped)
          }
          Text("\(viewStore.count)")
          Button("+") {
            viewStore.send(.incrementButtonTapped)
          }
        }

        Button(viewStore.isTimerOn ? "Stop timer" : "Start timer") {
          viewStore.send(.toggleTimerButtonTapped)
        }
      }
      .navigationTitle("Counter: \(viewStore.count)")
    }
  }
}

struct Previews: PreviewProvider {
  static var previews: some View {
    CounterView(
      store: Store(
        initialState: CounterFeature.State(),
        reducer: CounterFeature()
      )
    )
    .previewDisplayName("Counter")
  }
}
