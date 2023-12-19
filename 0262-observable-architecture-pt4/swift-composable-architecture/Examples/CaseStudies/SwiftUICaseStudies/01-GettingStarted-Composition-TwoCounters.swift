import ComposableArchitecture
import SwiftUI

private let readMe = """
  This screen demonstrates how to take small features and compose them into bigger ones using reducer builders and the `Scope` reducer, as well as the `scope` operator on stores.

  It reuses the domain of the counter screen and embeds it, twice, in a larger domain.
  """

// MARK: - Feature domain

@Reducer
struct TwoCounters {
  @ObservableState
  struct State: Equatable {
    var counter1 = Counter.State()
    var counter2 = Counter.State()
    var isDisplaySum = true
  }

  enum Action {
    case counter1(Counter.Action)
    case counter2(Counter.Action)
    case toggleSumDisplay
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.counter1, action: \.counter1) {
      Counter()
    }
    Scope(state: \.counter2, action: \.counter2) {
      Counter()
    }
    Reduce { state, action in
      switch action {
      case .counter1:
        return .none
      case .counter2:
        return .none
      case .toggleSumDisplay:
        state.isDisplaySum.toggle()
        return .none
      }
    }
  }
}

// MARK: - Feature view

struct TwoCountersView: View {
  @State var store = Store(initialState: TwoCounters.State()) {
    TwoCounters()
  }

  var body: some View {
    let _ = Self._printChanges()
    Form {
      Section {
        AboutView(readMe: readMe)
      }

      HStack {
        Text("Counter 1")
        Spacer()
        CounterView(store: self.store.scope(state: \.counter1, action: \.counter1))
      }

      HStack {
        Text("Counter 2")
        Spacer()
        CounterView(store: self.store.scope(state: \.counter2, action: \.counter2))
      }

      Section {
        if self.store.isDisplaySum {
          Text("Sum: \(self.store.counter1.count + self.store.counter2.count)")
        }
        Button("Toggle sum") {
          self.store.send(.toggleSumDisplay)
        }
      }
    }
    .buttonStyle(.borderless)
    .navigationTitle("Two counters demo")
  }
}

// MARK: - SwiftUI previews

struct TwoCountersView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TwoCountersView(
        store: Store(initialState: TwoCounters.State()) {
          TwoCounters()
        }
      )
    }
  }
}
