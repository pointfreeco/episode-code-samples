import ComposableArchitecture
import SwiftUI

private let readMe = """
  This screen demonstrates how to show and hide views based on the presence of some optional child \
  state.

  The parent state holds a `Counter.State?` value. When it is `nil` we will default to a plain text \
  view. But when it is non-`nil` we will show a view fragment for a counter that operates on the \
  non-optional counter state.

  Tapping "Toggle counter state" will flip between the `nil` and non-`nil` counter states.
  """

// MARK: - Feature domain

@Reducer
struct OptionalBasics {
  @ObservableState
  struct State: Equatable {
    var nonOptionalCounter = Counter.State()
    var optionalCounter: Counter.State?
  }

  enum Action {
    case nonOptionalCounter(Counter.Action)
    case optionalCounter(Counter.Action)
    case toggleCounterButtonTapped
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.nonOptionalCounter, action: \.nonOptionalCounter) {
      Counter()
    }
    Reduce { state, action in
      switch action {
      case .nonOptionalCounter:
        return .none
      case .toggleCounterButtonTapped:
        state.optionalCounter =
          state.optionalCounter == nil
          ? Counter.State()
          : nil
        return .none
      case .optionalCounter:
        return .none
      }
    }
    .ifLet(\.optionalCounter, action: \.optionalCounter) {
      Counter()
    }
  }
}

// MARK: - Feature view

struct OptionalBasicsView: View {
  @State var store = Store(initialState: OptionalBasics.State()) {
    OptionalBasics()
  }

  var body: some View {
    let _ = Self._printChanges()
    Form {
      Section {
        AboutView(readMe: readMe)
      }

      Button("Toggle counter state") {
        self.store.send(.toggleCounterButtonTapped)
      }

      if let store = self.store.scope(state: \.optionalCounter, action: \.optionalCounter) {
        Text(template: "`Counter.State` is non-`nil`")
        CounterView(store: store)
          .buttonStyle(.borderless)
          .frame(maxWidth: .infinity)
      } else {
        Text(template: "`Counter.State` is `nil`")
      }

      Section {
        CounterView(
          store: self.store.scope(state: \.nonOptionalCounter, action: \.nonOptionalCounter)
        )
        .buttonStyle(.borderless)
        .frame(maxWidth: .infinity)
      }

      Section {
        Text(
          ((self.store.optionalCounter?.count ?? 0) + self.store.nonOptionalCounter.count).description
        )
      } header: {
        Text("Sum")
      }
    }
    .navigationTitle("Optional state")
  }
}

// MARK: - SwiftUI previews

struct OptionalBasicsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        OptionalBasicsView(
          store: Store(initialState: OptionalBasics.State()) {
            OptionalBasics()
          }
        )
      }

      NavigationView {
        OptionalBasicsView(
          store: Store(
            initialState: OptionalBasics.State(optionalCounter: Counter.State(count: 42))
          ) {
            OptionalBasics()
          }
        )
      }
    }
  }
}
