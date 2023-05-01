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

        NavigationLink(
          value: RootFeature.Path.State.counter(
            CounterFeature.State(count: viewStore.count)
          )
        ) {
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

        NavigationLink(
          value: RootFeature.Path.State.numberFact(
            NumberFactFeature.State(number: viewStore.count)
          )
        ) {
          Text("Go to fact for \(viewStore.count)")
        }
      }
      .navigationTitle("Counter: \(viewStore.count)")
    }
  }
}

struct NumberFactFeature: Reducer {
  struct State: Hashable, Identifiable {
    let id = UUID()
    @PresentationState var alert: AlertState<AlertAction>?
    let number: Int
  }
  enum Action {
    case alert(PresentationAction<AlertAction>)
    case factButtonTapped
    case factResponse(TaskResult<String>)
  }
  enum AlertAction: Hashable {
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
    var path: IdentifiedArrayOf<Path.State> = []
  }
  enum Action {
    case goToCounterButtonTapped
    case path(id: Path.State.ID, action: Path.Action)
    case setPath(IdentifiedArrayOf<Path.State>)
  }
  struct Path: Reducer {
    enum State: Hashable, Identifiable {
      case counter(CounterFeature.State)
      case numberFact(NumberFactFeature.State)
      var id: AnyHashable {
        switch self {
        case let .counter(state):
          return state.id
        case let .numberFact(state):
          return state.id
        }
      }
    }
    enum Action {
      case counter(CounterFeature.Action)
      case numberFact(NumberFactFeature.Action)
    }
    var body: some ReducerOf<Self> {
      Scope(state: /State.counter, action: /Action.counter) {
        CounterFeature()
      }
      Scope(state: /State.numberFact, action: /Action.numberFact) {
        NumberFactFeature()
      }
    }
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .path(id: _, action: .counter(.delegate(action))):
        switch action {
        case let .goToCounter(count):
          state.path.append(.counter(CounterFeature.State(count: count)))
          return .none
        }

      case .path:
        return .none

      case .goToCounterButtonTapped:
        state.path.append(.counter(CounterFeature.State()))
        return .none

      case let .setPath(path):
        state.path = path
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }
  }
}

struct RootView: View {
  let store: StoreOf<RootFeature>

  var body: some View {
    NavigationStackStore(
      self.store.scope(
        state: \.path,
        action: RootFeature.Action.path
      )
    ) {
      // ...
    } destination: { state in
      switch state {
      case .counter:
        CaseLet(
          state: /RootFeature.Path.State.counter,
          action: RootFeature.Path.Action.counter,
          then: CounterView.init(store:)
        )
      case .numberFact:
        CaseLet(
          state: /RootFeature.Path.State.numberFact,
          action: RootFeature.Path.Action.numberFact,
          then: NumberFactView.init(store:)
        )
      }
    }
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      NavigationStack(
        path: viewStore.binding(
          get: \.path,
          send: RootFeature.Action.setPath
        )
      ) {
        Button("Go to counter") {
          viewStore.send(.goToCounterButtonTapped)
        }
        .navigationDestination(for: RootFeature.Path.State.self) {
          switch $0 {
          case let .counter(counterState):
            CounterView(
              store: self.store.scope(
                state: {
                  guard case let .counter(state) = $0.path[id: counterState.id]
                  else { return counterState }
                  return state
                },
                action: {
                  .path(id: counterState.id, action: .counter($0))
                }
              )
            )

          case let .numberFact(numberFactState):
            NumberFactView(
              store: self.store.scope(
                state: {
                  guard case let .numberFact(state) = $0.path[id: numberFactState.id]
                  else { return numberFactState }
                  return state
                },
                action: {
                  .path(id: numberFactState.id, action: .numberFact($0))
                }
              )
            )
          }
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
