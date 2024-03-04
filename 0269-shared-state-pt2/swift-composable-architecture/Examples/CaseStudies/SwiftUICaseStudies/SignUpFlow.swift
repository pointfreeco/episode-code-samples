import ComposableArchitecture
import SwiftUI

@Reducer
struct SignUpFeature {
  @Reducer
  enum Path {
    case basics(BasicsFeature)
  }

  @ObservableState
  struct State {
    var path = StackState<Path.State>()
  }

  enum Action {
    case path(StackAction<Path.State, Path.Action>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      // Core logic of the root feature
      return .none
    }
    .forEach(\.path, action: \.path)
  }
}

struct SignUpFlow: View {
  @Bindable var store = Store(initialState: SignUpFeature.State()) {
    SignUpFeature()
      ._printChanges()
  }

  var body: some View {
    NavigationStack(
      path: $store.scope(state: \.path, action: \.path)
    ) {
      Form {
        Section {
          Text("Welcome! Please sign up.")
          NavigationLink(
            "Sign up",
            state: SignUpFeature.Path.State.basics(BasicsFeature.State())
          )
        }
      }
      .navigationTitle("Sign up")
    } destination: { store in
      switch store.case {
      case let .basics(store):
        BasicsStep(store: store)
      }
    }
  }
}

#Preview("Sign up") {
  SignUpFlow()
}

@Reducer
struct BasicsFeature {
  @ObservableState
  struct State {
    var email = ""
    var password = ""
    var passwordConfirmation = ""
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
  }

  var body: some ReducerOf<Self> {
    BindingReducer()
  }
}

struct BasicsStep: View {
  @Bindable var store: StoreOf<BasicsFeature>

  var body: some View {
    Form {
      Section {
        TextField("Email", text: $store.email)
      }
      Section {
        SecureField("Password", text: $store.password)
        SecureField("Password confirmation", text: $store.passwordConfirmation)
      }
    }
    .navigationTitle("Basics")
    .toolbar {
      ToolbarItem {
        NavigationLink(
          "Next",
          state: SignUpFeature.Path.State?.none
        )
      }
    }
  }
}

#Preview("Basics") {
  NavigationStack {
    BasicsStep(
      store: Store(initialState: BasicsFeature.State()) {
        BasicsFeature()
      }
    )
  }
}
