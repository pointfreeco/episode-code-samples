import Observation
import SwiftUI

// @ObservableValue
struct CounterState: Observable {
  var text = "Hello"
  private var _count  = 0
  var count: Int {
    @storageRestrictions(initializes: _count )
    init(initialValue) {
      _count  = initialValue
    }

    get {
      access(keyPath: \.count )
      return _count
    }

    set {
      withMutation(keyPath: \.count ) {
        _count  = newValue
      }
    }
  }
  private let _$observationRegistrar = Observation.ObservationRegistrar()

  internal nonisolated func access<Member>(
    keyPath: KeyPath<CounterState , Member>
  ) {
    _$observationRegistrar.access(self, keyPath: keyPath)
  }

  internal nonisolated func withMutation<Member, MutationResult>(
    keyPath: KeyPath<CounterState , Member>,
    _ mutation: () throws -> MutationResult
  ) rethrows -> MutationResult {
    try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
  }
}

//class Store<Value: ObservableValue> {}

@Observable
class CounterStateStore {
  @ObservationIgnored
  private var _state: CounterState
  var state: CounterState {
    get {
      self.access(keyPath: \.state)
      return self._state
    }
    set {
      withMutation(keyPath: \.state) {
        self._state = newValue
      }
    }
    _modify {
      yield &self._state
    }
  }
  init(state: CounterState) {
    self._state = state
  }
}

struct CounterView_StructState: View {
  @State var store = CounterStateStore(state: CounterState())
  @State var isCountObserved = true

  var body: some View {
    let _ = Self._printChanges()
    Form {
      Section {
        Text(self.store.state.text)
        if self.isCountObserved {
          Text(self.store.state.count.description)
        }
        Button("Decrement") { self.store.state.count -= 1 }
        Button("Increment") { self.store.state.count += 1 }
        Button("Reset") { self.store.state = CounterState() }
        Toggle(isOn: self.$isCountObserved) {
          Text("Observe count")
        }
      } header: {
        Text("Counter")
      }
    }
  }
}

#Preview {
  CounterView_StructState(store: CounterStateStore(state: CounterState()))
}

