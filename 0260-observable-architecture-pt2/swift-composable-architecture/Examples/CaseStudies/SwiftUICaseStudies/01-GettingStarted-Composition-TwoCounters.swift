import ComposableArchitecture
import SwiftUI

private let readMe = """
  This screen demonstrates how to take small features and compose them into bigger ones using reducer builders and the `Scope` reducer, as well as the `scope` operator on stores.

  It reuses the domain of the counter screen and embeds it, twice, in a larger domain.
  """

// MARK: - Feature domain

@Reducer
struct TwoCounters {
  struct State: Equatable, ObservableState {
    let _$id = UUID()

    var _counter1 = Counter.State()
    var counter1: Counter.State {
      @storageRestrictions(initializes: _counter1 )
      init(initialValue) {
        _counter1  = initialValue
      }
      get {
        self._$observationRegistrar.access(self, keyPath: \.counter1)
        return _counter1
      }
      set {
        self._$observationRegistrar.withMutation(of: self, keyPath: \.counter1) {
          _counter1  = newValue
        }
      }
    }
    var _counter2 = Counter.State()
    var counter2: Counter.State {
      @storageRestrictions(initializes: _counter2 )
      init(initialValue) {
        _counter2  = initialValue
      }
      get {
        self._$observationRegistrar.access(self, keyPath: \.counter2)
        return _counter2
      }
      set {
        self._$observationRegistrar.withMutation(of: self, keyPath: \.counter2) {
          _counter2  = newValue
        }
      }
    }
    private var _isDisplaySum = true
    var isDisplaySum: Bool {
      @storageRestrictions(initializes: _isDisplaySum)
      init(initialValue) {
        _isDisplaySum = initialValue
      }
      get {
        self._$observationRegistrar.access(self, keyPath: \.isDisplaySum)
        return _isDisplaySum
      }
      set {
        self._$observationRegistrar.withMutation(of: self, keyPath: \.isDisplaySum) {
          _isDisplaySum  = newValue
        }
      }
    }

    private let _$observationRegistrar = Observation.ObservationRegistrar()
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
