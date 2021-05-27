import Combine
import ComposableArchitecture
import SwiftUI

struct CounterState: Equatable {
  var alert: Alert?
  var count = 0

  struct Alert: Equatable, Identifiable {
    var message: String
    var title: String

    var id: String {
      self.title + self.message
    }
  }
}
enum CounterAction: Equatable {
  case decrementButtonTapped
  case dismissAlert
  case incrementButtonTapped
  case factButtonTapped
  case factResponse(Result<String, FactClient.Error>)
}

struct CounterEnvironment {
  let fact: FactClient
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> {
  state, action, environment in

  switch action {
  case .decrementButtonTapped:
    state.count -= 1
    return .none

  case .dismissAlert:
    state.alert = nil
    return .none

  case .incrementButtonTapped:
    state.count += 1
    return .none

  case .factButtonTapped:
    return environment.fact.fetch(state.count)
      .receive(on: environment.mainQueue.animation())
      .catchToEffect()
      .map(CounterAction.factResponse)

  case let .factResponse(.success(fact)):
    state.alert = .init(message: fact, title: "Fact")
    return .none

  case .factResponse(.failure):
    state.alert = .init(message: "Couldn't load fact.", title: "Error")
    return .none
  }
}

struct CounterView: View {
  let store: Store<CounterState, CounterAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack {
          Button("-") { viewStore.send(.decrementButtonTapped) }
          Text("\(viewStore.count)")
          Button("+") { viewStore.send(.incrementButtonTapped) }
        }

        Button("Fact") { viewStore.send(.factButtonTapped) }
      }
      .alert(item: viewStore.binding(get: \.alert, send: .dismissAlert)) { alert in
        Alert(
          title: Text(alert.title),
          message: Text(alert.message)
        )
      }
    }
  }
}

struct CounterRowState: Equatable, Identifiable {
  var counter: CounterState
  let id: UUID
}

enum CounterRowAction: Equatable {
  case counter(CounterAction)
  case removeButtonTapped
}

struct CounterRowView: View {
  let store: Store<CounterRowState, CounterRowAction>
  
  var body: some View {
    HStack {
      CounterView(
        store: self.store.scope(
          state: \.counter,
          action: CounterRowAction.counter
        )
      )
      
      Spacer()
      
      WithViewStore(self.store.stateless) { viewStore in
        Button("Remove") {
          viewStore.send(.removeButtonTapped, animation: .default)
        }
      }
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct AppState: Equatable {
  var counters: IdentifiedArrayOf<CounterRowState>
}
enum AppAction: Equatable {
  case addButtonTapped
  case counterRow(id: UUID, action: CounterRowAction)
}
struct AppEnvironment {
  var fact: FactClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var uuid: () -> UUID
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(

  counterReducer
    .pullback(
      state: \CounterRowState.counter,
      action: /CounterRowAction.counter,
      environment: { $0 }
    )
    .forEach(
      state: \AppState.counters,
      action: /AppAction.counterRow(id:action:),
      environment: {
        CounterEnvironment(
          fact: $0.fact,
          mainQueue: $0.mainQueue
        )
      }
    ),

  .init { state, action, environment in
    switch action {
    case .addButtonTapped:
      state.counters.append(
        .init(counter: .init(), id: environment.uuid())
      )
      return .none

    case let .counterRow(id: id, action: .removeButtonTapped):
      state.counters.remove(id: id)
      return .none

    case .counterRow:
      return .none
    }
  }
)

struct AppView: View {
  let store: Store<AppState, AppAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      List {
//        ForEach(viewStore.counters) { counter in
        ForEachStore(
          self.store.scope(
            state: \.counters,
            action: AppAction.counterRow(id:action:)
          ),
          content: CounterRowView.init(store:)
        )
      }
      .navigationTitle("Counters")
      .navigationBarItems(
        trailing: Button("Add") {
          viewStore.send(.addButtonTapped, animation: .default)
        }
      )
    }
  }
}


struct CounterView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AppView(
        store: .init(
          initialState: .init(counters: []),
          reducer: appReducer,
          environment: AppEnvironment(
            fact: .live,
            mainQueue: .main,
            uuid: UUID.init
          )
        )
      )
    }

    CounterView(
      store: .init(
        initialState: .init(),
        reducer: counterReducer,
        environment: .init(
          fact: .live,
          mainQueue: .main
        )
      )
    )
  }
}
