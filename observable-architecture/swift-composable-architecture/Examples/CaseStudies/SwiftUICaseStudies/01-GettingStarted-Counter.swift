import ComposableArchitecture
import SwiftUI

private let readMe = """
  This screen demonstrates the basics of the Composable Architecture in an archetypal counter \
  application.

  The domain of the application is modeled using simple data types that correspond to the mutable \
  state of the application and any actions that can affect that state or the outside world.
  """

// MARK: - Feature domain

@Reducer
struct Counter {
  struct State: Equatable, Observable {
    private var _count = 0
    var count: Int {
      @storageRestrictions(initializes: _count)
      init(initialValue) {
        _count = initialValue
      }
      get {
        self._$observationRegistrar.access(self, keyPath: \.count)
        return _count
      }
      set {
        self._$observationRegistrar.withMutation(of: self, keyPath: \.count) {
          _count = newValue
        }
      }
    }
    private var _isDisplayingCount = true
    var isDisplayingCount: Bool {
      @storageRestrictions(initializes: _isDisplayingCount)
      init(initialValue) {
        _isDisplayingCount = initialValue
      }
      get {
        self._$observationRegistrar.access(self, keyPath: \.isDisplayingCount)
        return _isDisplayingCount
      }
      set {
        self._$observationRegistrar.withMutation(of: self, keyPath: \.isDisplayingCount) {
          _isDisplayingCount  = newValue
        }
      }
    }
    init(count: Int = 0, isDisplayingCount: Bool = true) {
      self._count = count
      self._isDisplayingCount = isDisplayingCount
    }
    private let _$observationRegistrar = Observation.ObservationRegistrar()
  }

  enum Action {
    case decrementButtonTapped
    case incrementButtonTapped
    case toggleIsDisplayingCount
    case resetButtonTapped
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .decrementButtonTapped:
        state.count -= 1
        return .none
      case .incrementButtonTapped:
        state.count += 1
        return .none
      case .toggleIsDisplayingCount:
        state.isDisplayingCount.toggle()
        return .none
      case .resetButtonTapped:
        state = State()
        return .none
      }
    }
  }
}

// MARK: - Feature view

struct CounterView: View {
  let store: StoreOf<Counter>

  var body: some View {
    let _ = Self._printChanges()
    VStack {
      HStack {
        Button {
          self.store.send(.decrementButtonTapped)
        } label: {
          Image(systemName: "minus")
        }

        if self.store.isDisplayingCount {
          Text("\(self.store.count)")
            .monospacedDigit()
        }

        Button {
          self.store.send(.incrementButtonTapped)
        } label: {
          Image(systemName: "plus")
        }
      }
      .padding()

      Button("Toggle count display") {
        self.store.send(.toggleIsDisplayingCount)
      }
      Button("Reset") {
        self.store.send(.resetButtonTapped)
      }
    }
  }
}

struct CounterDemoView: View {
  @State var store = Store(initialState: Counter.State()) {
    Counter()
  }

  var body: some View {
    Form {
      Section {
        AboutView(readMe: readMe)
      }

      Section {
        CounterView(store: self.store)
          .frame(maxWidth: .infinity)
      }
    }
    .buttonStyle(.borderless)
    .navigationTitle("Counter demo")
  }
}

// MARK: - SwiftUI previews

struct CounterView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      CounterDemoView(
        store: Store(initialState: Counter.State()) {
          Counter()
        }
      )
    }
  }
}
