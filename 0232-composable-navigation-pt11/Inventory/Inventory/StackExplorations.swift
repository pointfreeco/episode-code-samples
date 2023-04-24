import ComposableArchitecture
import SwiftUI

struct CounterFeature: Reducer {
  struct State: Equatable, Hashable, Identifiable {
    let id = UUID()
    var count = 0
    var isLoading = false
    var isTimerOn = false
  }
  enum Action {
    case decrementButtonTapped
    case delegate(Delegate)
    case incrementButtonTapped
    case loadAndGoToCounterButtonTapped
    case loadResponse
    case timerTick
    case toggleTimerButtonTapped

    enum Delegate {
      case goToCounter(Int)
    }
  }
  private enum CancelID { case timer }
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .decrementButtonTapped:
      state.count -= 1
      return .none

    case .delegate:
      return .none

    case .incrementButtonTapped:
      state.count += 1
      return .none

    case .loadAndGoToCounterButtonTapped:
      state.isLoading = true
      return .run { send in
        try await Task.sleep(for: .seconds(2))
        await send(.loadResponse)
      }

    case .loadResponse:
      state.isLoading = false
      if Bool.random() {
        return .send(.delegate(.goToCounter(state.count)))
      } else {
        return .none
      }

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

        NavigationLink(value: CounterFeature.State(count: viewStore.count)) {
          Text("Push counter: \(viewStore.count)")
        }

        Button {
          viewStore.send(.loadAndGoToCounterButtonTapped)
        } label: {
          if viewStore.isLoading {
            ProgressView()
          }
          Text("Load and go to counter: \(viewStore.count)")
        }
      }
      .navigationTitle("Counter: \(viewStore.count)")
    }
  }
}

struct NumberFactFeature: Reducer {
  struct State: Equatable {
    @PresentationState var alert: AlertState<AlertAction>?
    let number: Int
  }
  enum Action {
    case alert(PresentationAction<AlertAction>)
    case factButtonTapped
    case factResponse(TaskResult<String>)
  }
  enum AlertAction: Equatable {
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .alert:
        return .none

      case .factButtonTapped:
        return .task { [number = state.number] in
          await .factResponse(
            TaskResult {
              try await String(
                decoding: URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)/trivia")!).0,
                as: UTF8.self
              )
            }
          )
        }

      case let .factResponse(.success(fact)):
        state.alert = AlertState {
          TextState(fact)
        }
        return .none

      case .factResponse(.failure):
        state.alert = AlertState {
          TextState("Could not load a number fact :(")
        }
        return .none
      }
    }
    .ifLet(\.$alert, action: /Action.alert)
  }
}

struct NumberFactView: View {
  let store: StoreOf<NumberFactFeature>
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        Text("Number: \(viewStore.number)")
        Button("Get fact") {
          viewStore.send(.factButtonTapped)
        }
      }
      .alert(store: self.store.scope(state: \.alert, action: NumberFactFeature.Action.alert))
    }
  }
}

struct RootFeature: Reducer {
  struct State: Equatable {
    var counters: IdentifiedArrayOf<CounterFeature.State> = []
  }
  enum Action {
    case counter(id: CounterFeature.State.ID, action: CounterFeature.Action)
    case goToCounterButtonTapped
    case setPath(IdentifiedArrayOf<CounterFeature.State>)
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .counter(id: _, action: .delegate(action)):
        switch action {
        case let .goToCounter(count):
          state.counters.append(CounterFeature.State(count: count))
          return .none
        }

      case .counter:
        return .none

      case .goToCounterButtonTapped:
        state.counters.append(CounterFeature.State())
        return .none

      case let .setPath(counters):
        state.counters = counters
        return .none
      }
    }
    .forEach(\.counters, action: /Action.counter) {
      CounterFeature()
    }
  }
}

struct RootView: View {
  let store: StoreOf<RootFeature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      NavigationStack(
        path: viewStore.binding(
          get: \.counters,
          send: RootFeature.Action.setPath
        )
      ) {
        Button("Go to counter") {
          viewStore.send(.goToCounterButtonTapped)
        }
        .navigationDestination(for: CounterFeature.State.self) { counterState in
          CounterView(
            store: self.store.scope(
              state: { $0.counters[id: counterState.id] ?? counterState },
              action: { .counter(id: counterState.id, action: $0) }
            )
          )
        }
      }
    }
  }
}

struct Previews: PreviewProvider {
  static var previews: some View {
    RootView(
      store: Store(
        initialState: RootFeature.State(),
        reducer: RootFeature()
          ._printChanges()
      )
    )
    .previewDisplayName("RootView")

    NumberFactView(
      store: Store(
        initialState: NumberFactFeature.State(number: 42),
        reducer: NumberFactFeature()
      )
    )
    .previewDisplayName("Fact")

    NavigationStack {
      CounterView(
        store: Store(
          initialState: CounterFeature.State(),
          reducer: CounterFeature()
        )
      )
    }
    .previewDisplayName("Counter")
  }
}
