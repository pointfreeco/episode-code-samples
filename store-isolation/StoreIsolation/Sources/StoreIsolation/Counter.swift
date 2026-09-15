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
  func _update(_ core: Core<State, Action>, action: Action) {
    switch action {
    case .asyncIncrementThenDecrementButtonTapped:
      core.state.count += 1
      core.addTask {
        await Task.yield()
        core.state.count -= 1
      }
    case .factButtonTapped:
      core.addTask {
        core.state.fact = try await fact(core.count)
      }
    case .incrementButtonTapped:
      core.state.count += 1
    case .incrementThenDecrementButtonTapped:
      core.state.count += 1
      core.addTask {
        core.state.count -= 1
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
