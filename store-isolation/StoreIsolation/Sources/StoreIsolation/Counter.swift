import SwiftUI

struct Counter: Feature {
  struct State {
    var count = 0
  }
  enum Action {
    case incrementButtonTapped
  }
  func _update(_ store: Store<State, Action>, action: Action) {
    switch action {
    case .incrementButtonTapped:
      store.state.count += 1
    }
  }
}

struct CounterView: View {
  let store: StoreOf<Counter>
  var body: some View {
    Form {
      Text("\(store.count)")
      Button("+") { store.send(.incrementButtonTapped) }
    }
  }
}

#Preview {
  CounterView(
    store: Store(
      initialState: Counter.State(),
      feature: Counter()
    )
  )
}
