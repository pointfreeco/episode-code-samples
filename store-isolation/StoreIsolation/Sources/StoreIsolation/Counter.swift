import SwiftUI

struct Counter: Feature {
  struct State {
    var count = 0
    var fact: String?
  }
  enum Action {
    case asyncIncrementThenDecrementButtonTapped
    case factButtonTapped
    case incrementButtonTapped
    case incrementThenDecrementButtonTapped
  }
  var fact: nonisolated(nonsending) (Int) async throws -> String = {
    let (data, _) = try await URLSession.shared.data(
      from: URL(string: "http://number-trivia.com/\($0)/trivia")!
        )
    return String(decoding: data, as: UTF8.self)
  }
  func _update(_ store: Store<State, Action>, action: Action) {
    switch action {
    case .asyncIncrementThenDecrementButtonTapped:
      store.state.count += 1
      store.addTask {
        await Task.yield()
        store.state.count -= 1
      }
    case .factButtonTapped:
      store.addTask {
        store.state.fact = try await fact(store.count)
      }
    case .incrementButtonTapped:
      store.state.count += 1
    case .incrementThenDecrementButtonTapped:
      store.state.count += 1
      store.addTask {
        store.state.count -= 1
      }
    }
  }
}

struct CounterView: View {
  let store: StoreOf<Counter>
  var body: some View {
    Form {
      Text("\(store.count)")
      Button("+") { store.send(.incrementButtonTapped) }
      Button("+/-") {
        store.send(.incrementThenDecrementButtonTapped)
        print(store.count) // 0
      }
      Button("Fact") {
        store.send(.factButtonTapped)
      }
      if let fact = store.fact {
        Text(fact)
      }
    }
  }
}

#Preview {
  CounterView(
    store: Store(
      initialState: Counter.State(),
      feature: Counter(fact: { "\($0) is a good number!" })
    )
  )
}
