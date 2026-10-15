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

    case factResponse(String)
  }
  var fact: nonisolated(nonsending) (Int) async throws -> String = {
    let (data, _) = try await URLSession.shared.data(
      from: URL(string: "http://number-trivia.com/\($0)/trivia")!
        )
    return String(decoding: data, as: UTF8.self)
  }

//  var body: some Feature {
//    Update { state, action in
//      state.fact = nil
//      store.addTask {
//
//      }
//      print(state.fact)
//    }
//  }

  func _update(_ core: Core<State, Action>, action: Action) {
//    print("Starting", action)
//    defer {
//      print("Ending", action)
//    }
    switch action {
    case .asyncIncrementThenDecrementButtonTapped:
      core.state.count += 1
      core.addTask {
        await Task.yield()
        core.state.count -= 1
      }
    case .factButtonTapped:
      // Track some analytics about the previous fact
      // Log the previous fact to the console
      // Store the previous fact in user defaults
      defer { core.state.fact = nil }
//      print("Before addTask", core.fact ?? "(nil)")
      core.addTask {
        //core.state.fact = try await fact(core.count)
        core.send(.factResponse(try await fact(core.count)))
      }
    case .factResponse(let fact):
      core.state.fact = fact
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
      feature: Counter(fact: {
        try await Task.sleep(for: .seconds(1))
        return "\($0) is a good number!"
      })
    )
  )
}
