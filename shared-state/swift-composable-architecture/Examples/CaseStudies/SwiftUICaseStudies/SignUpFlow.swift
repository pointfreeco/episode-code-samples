import ComposableArchitecture
import SwiftUI

struct SignUpData: Equatable {
  var email = ""
  var firstName = ""
  var lastName = ""
  var password = ""
  var passwordConfirmation = ""
  var phoneNumber = ""
}

@Reducer
struct SignUpFeature {
  @Reducer
  enum Path {
    case basics(BasicsFeature)
    case personalInfo(PersonalInfoFeature)
  }

  @ObservableState
  struct State {
    var path = StackState<Path.State>()
    @Shared var signUpData: SignUpData
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
  @Bindable var store = Store(initialState: SignUpFeature.State(signUpData: Shared(SignUpData()))) {
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
            state: SignUpFeature.Path.State.basics(BasicsFeature.State(signUpData: store.$signUpData))
          )
        }
      }
      .navigationTitle("Sign up")
    } destination: { store in
      switch store.case {
      case let .basics(store):
        BasicsStep(store: store)
      case let .personalInfo(store):
        PersonalInfoStep(store: store)
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
    @Shared var signUpData: SignUpData
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
        TextField("Email", text: $store.signUpData.email)
      }
      Section {
        SecureField("Password", text: $store.signUpData.password)
        SecureField("Password confirmation", text: $store.signUpData.passwordConfirmation)
      }
    }
    .navigationTitle("Basics")
    .toolbar {
      ToolbarItem {
        NavigationLink(
          "Next",
          state: SignUpFeature.Path.State.personalInfo(PersonalInfoFeature.State(signUpData: store.$signUpData))
        )
      }
    }
  }
}

#Preview("Basics") {
  NavigationStack {
    BasicsStep(
      store: Store(initialState: BasicsFeature.State(signUpData: Shared(SignUpData()))) {
        BasicsFeature()
      }
    )
  }
}

@Reducer
struct PersonalInfoFeature {
  @ObservableState
  struct State {
    @Shared var signUpData: SignUpData
  }
  enum Action: BindableAction {
    case binding(BindingAction<State>)
  }
  var body: some ReducerOf<Self> {
    BindingReducer()
  }
}

struct PersonalInfoStep: View {
  @Bindable var store: StoreOf<PersonalInfoFeature>

  var body: some View {
    Form {
      Section {
        TextField("First name", text: $store.signUpData.firstName)
        TextField("Last name", text: $store.signUpData.lastName)
        TextField("Phone number", text: $store.signUpData.phoneNumber)
      }
    }
    .navigationTitle("Personal info")
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

#Preview("Personal info") {
  NavigationStack {
    PersonalInfoStep(
      store: Store(initialState: PersonalInfoFeature.State(signUpData: Shared(SignUpData()))) {
        PersonalInfoFeature()
      }
    )
  }
}
