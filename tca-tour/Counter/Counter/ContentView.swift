import ComposableArchitecture
import SwiftUI

struct CounterFeature: Reducer {
  struct State: Equatable {
    var count = 0
    var fact: String?
    var isLoadingFact = false
    var isTimerOn = false
  }
  enum Action {
    case decrementButtonTapped
    case factResponse(String)
    case getFactButtonTapped
    case incrementButtonTapped
    case timerTicked
    case toggleTimerButtonTapped
  }
  private enum CancelID {
    case timer
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .decrementButtonTapped:
        state.count -= 1
        state.fact = nil
        return .none

      case let .factResponse(fact):
        state.fact = fact
        state.isLoadingFact = false
        return .none

      case .getFactButtonTapped:
        state.fact = nil
        state.isLoadingFact = true
        return .run { [count = state.count] send in
          try await Task.sleep(for: .seconds(1))
          let (data, _) = try await URLSession.shared.data(
            from: URL(string: "http://www.numbersapi.com/\(count)")!
          )
          let fact = String(decoding: data, as: UTF8.self)
          await send(.factResponse(fact))
        }

      case .incrementButtonTapped:
        state.count += 1
        state.fact = nil
        return .none

      case .timerTicked:
        state.count += 1
        return .none

      case .toggleTimerButtonTapped:
        state.isTimerOn.toggle()
        if state.isTimerOn {
          return .run { send in
            while true {
              try await Task.sleep(for: .seconds(1))
              await send(.timerTicked)
            }
          }
          .cancellable(id: CancelID.timer)
        } else {
          return .cancel(id: CancelID.timer)
        }
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
          Button {
            viewStore.send(.getFactButtonTapped)
          } label: {
            HStack {
              Text("Get fact")
              if viewStore.isLoadingFact {
                Spacer()
                ProgressView()
              }
            }
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
