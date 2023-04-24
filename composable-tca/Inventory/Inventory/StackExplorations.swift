import ComposableArchitecture
import SwiftUI

struct CounterFeature: Reducer {
  struct State: Equatable {
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
          state: RootFeature.Path.State.counter(
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
          state: RootFeature.Path.State.numberFact(
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
  struct State: Equatable {
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

func foo() {
  var path = NavigationPath()
  path.append(1)
  path.append(2)
  path.append(3)
  path.append("Hello")
  path.append(true)
  path.count
  path.isEmpty
  path.removeLast()
  path.removeLast(2)
//  path.insert
//  path.remove(at:)
//  for element in path {
//
//  }
}

struct RootFeature: Reducer {
  struct State: Equatable {
    var path: StackState<Path.State> = StackState()
    var sum: Int {
      self.path.reduce(into: 0) { sum, element in
        switch element {
        case let .counter(counterState):
          sum += counterState.count
        case .numberFact:
          break
        }
      }
    }
  }
  enum Action {
    case path(StackAction<Path.State, Path.Action>)
  }
  struct Path: Reducer {
    enum State: Equatable {
      case counter(CounterFeature.State = CounterFeature.State())
      case numberFact(NumberFactFeature.State)
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
      case let .path(.element(id: _, action: .counter(.delegate(action)))):
        switch action {
        case let .goToCounter(count):
          state.path.append(.counter(CounterFeature.State(count: count)))
          return .none
        }

      case .path:
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }
  }
}

struct RootView: View {
  struct ViewState: Equatable {
    let isSummaryVisible: Bool
    let sum: Int

    init(state: RootFeature.State) {
      self.isSummaryVisible = !state.path.isEmpty
      self.sum = state.sum
    }
  }

  let store: StoreOf<RootFeature>

  var body: some View {
    NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
      NavigationLink(state: RootFeature.Path.State.counter()) {
        Text("Go to counter")
      }
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
    .overlay(alignment: .bottom) {
      WithViewStore(self.store, observe: ViewState.init) { viewStore in
        if viewStore.isSummaryVisible {
          Text("Sum: \(viewStore.sum)")
            .padding()
            .background(Color.white)
            .transition(.opacity.animation(.default))
            .clipped()
            .shadow(color: .black.opacity(0.2), radius: 5, y: 5)
        }
      }
    }
  }
}

struct Previews: PreviewProvider {
  static var previews: some View {
    RootView(
      store: Store(
        initialState: RootFeature.State(
          path: StackState([
            .counter(CounterFeature.State(count: 100))
          ])
        ),
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
