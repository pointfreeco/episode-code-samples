import ComposableArchitecture
import SwiftUI

struct SignUpData: Equatable {
  var email = ""
  var firstName = ""
  var lastName = ""
  var password = ""
  var passwordConfirmation = ""
  var phoneNumber = ""
  var topics: Set<Topic> = []

  enum Topic: String, Identifiable, CaseIterable {
    case advancedSwift = "Advanced Swift"
    case composableArchitecture = "Composable Architecture"
    case concurrency = "Concurrency"
    case modernSwiftUI = "Modern SwiftUI"
    case swiftUI = "SwiftUI"
    case testing = "Testing"
    var id: Self { self }
  }
}

@Reducer
struct SignUpFeature {
  @Reducer
  enum Path {
    case basics(BasicsFeature)
    case personalInfo(PersonalInfoFeature)
    case summary(SummaryFeature)
    case topics(TopicsFeature)
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
      switch action {
      case let .path(.element(id: _, action: .topics(.delegate(delegateAction)))):
        switch delegateAction {
        case .stepFinished:
          state.path.append(.summary(SummaryFeature.State(signUpData: state.$signUpData)))
          return .none
        }
      case .path:
        return .none
      }
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
      case let .summary(store):
        SummaryStep(store: store)
      case let .topics(store):
        TopicsStep(store: store)
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
  var isEditingFromSummary = false
  @Environment(\.dismiss) var dismiss

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
        if !isEditingFromSummary {
          NavigationLink(
            "Next",
            state: SignUpFeature.Path.State.topics(TopicsFeature.State(signUpData: store.$signUpData))
          )
        } else {
          Button("Done") {
            dismiss()
          }
        }
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

@Reducer
struct TopicsFeature {
  @ObservableState
  struct State {
    @Presents var alert: AlertState<Never>?
    @Shared var signUpData: SignUpData
  }
  enum Action: BindableAction {
    case alert(PresentationAction<Never>)
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case doneButtonTapped
    case nextButtonTapped
    enum Delegate {
      case stepFinished
    }
  }
  @Dependency(\.dismiss) var dismiss
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .alert:
        return .none
      case .binding:
        return .none
      case .delegate:
        return .none
      case .doneButtonTapped:
        if state.signUpData.topics.isEmpty {
          state.alert = AlertState {
            TextState("Please choose at least one topic.")
          }
          return .none
        } else {
          return .run { _ in await dismiss() }
        }
      case .nextButtonTapped:
        if state.signUpData.topics.isEmpty {
          state.alert = AlertState {
            TextState("Please choose at least one topic.")
          }
        } else {
          return .send(.delegate(.stepFinished))
        }
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
}

struct TopicsStep: View {
  @Bindable var store: StoreOf<TopicsFeature>
  var isEditingFromSummary = false

  var body: some View {
    Form {
      Section {
        Text("Please choose all the topics you are interested in.")
      }
      Section {
        ForEach(SignUpData.Topic.allCases) { topic in
          Toggle(
            topic.rawValue,
            isOn: $store.signUpData.topics[contains: topic]
          )
        }
      }
    }
    .alert($store.scope(state: \.alert, action: \.alert))
    .navigationTitle("Topics")
    .toolbar {
      ToolbarItem {
        if !isEditingFromSummary {
          Button("Next") {
            store.send(.nextButtonTapped)
          }
        } else {
          Button("Done") {
            store.send(.doneButtonTapped)
          }
        }
      }
    }
    .interactiveDismissDisabled(store.signUpData.topics.isEmpty)
  }
}

extension Set {
  fileprivate subscript(contains element: Element) -> Bool {
    get { self.contains(element) }
    set {
      if newValue {
        self.insert(element)
      } else {
        self.remove(element)
      }
    }
  }
}

#Preview("Topics") {
  NavigationStack {
    TopicsStep(
      store: Store(initialState: TopicsFeature.State(signUpData: Shared(SignUpData()))) {
        TopicsFeature()
      }
    )
  }
}

@Reducer
struct SummaryFeature {
  @Reducer
  enum Destination {
    case personalInfo(PersonalInfoFeature)
    case topics(TopicsFeature)
  }

  @ObservableState
  struct State {
    @Presents var destination: Destination.State?
    @Shared var signUpData: SignUpData
  }
  enum Action {
    case destination(PresentationAction<Destination.Action>)
    case editPersonalInfoButtonTapped
    case editFavoriteTopicsButtonTapped
    case submitButtonTapped
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .destination:
        return .none
      case .editPersonalInfoButtonTapped:
        state.destination = .personalInfo(
          PersonalInfoFeature.State(
            signUpData: state.$signUpData
          )
        )
        return .none
      case .editFavoriteTopicsButtonTapped:
        state.destination = .topics(
          TopicsFeature.State(
            signUpData: state.$signUpData
          )
        )
        return .none
      case .submitButtonTapped:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}

struct SummaryStep: View {
  @Bindable var store: StoreOf<SummaryFeature>

  var body: some View {
    Form {
      Section {
        Text(store.signUpData.email)
        Text(String(repeating: "•", count: store.signUpData.password.count))
      } header: {
        Text("Required info")
      }

      Section {
        Text(store.signUpData.firstName)
        Text(store.signUpData.lastName)
        Text(store.signUpData.phoneNumber)
      } header: {
        HStack {
          Text("Personal info")
          Spacer()
          Button("Edit") {
            store.send(.editPersonalInfoButtonTapped)
          }
          .font(.caption)
        }
      }

      Section {
        ForEach(store.signUpData.topics.sorted(by: { $0.rawValue < $1.rawValue })) { topic in
          Text(topic.rawValue)
        }
      } header: {
        HStack {
          Text("Favorite topics")
          Spacer()
          Button("Edit") {
            store.send(.editFavoriteTopicsButtonTapped)
          }
          .font(.caption)
        }
      }

      Section {
        Button {
          store.send(.submitButtonTapped)
        } label: {
          Text("Submit")
        }
      }
    }
    .navigationTitle("Summary")
    .sheet(
      item: $store.scope(state: \.destination?.personalInfo, action: \.destination.personalInfo)
    ) { store in
      NavigationStack {
        PersonalInfoStep(store: store, isEditingFromSummary: true)
      }
      .presentationDetents([.medium])
    }
    .sheet(
      item: $store.scope(state: \.destination?.topics, action: \.destination.topics)
    ) { store in
      NavigationStack {
        TopicsStep(store: store, isEditingFromSummary: true)
      }
      .presentationDetents([.medium])
    }
  }
}

#Preview("Summary") {
  NavigationStack {
    SummaryStep(
      store: Store(
        initialState: SummaryFeature.State(
          signUpData: Shared(
            SignUpData(
              email: "blob@pointfree.co",
              firstName: "Blob",
              lastName: "McBlob",
              password: "blob is awesome",
              passwordConfirmation: "blob is awesome",
              phoneNumber: "212-555-1234",
              topics: [
                .composableArchitecture,
                .concurrency,
                .modernSwiftUI
              ]
            )
          )
        )
      ) {
        SummaryFeature()
      }
    )
  }
}
