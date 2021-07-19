import ComposableArchitecture
import SwiftUI

struct BindingAction<Root>: Equatable {
  let keyPath: PartialKeyPath<Root>
  let setter: (inout Root) -> Void
  let value: Any
  let isEqualTo: (Any) -> Bool

  init<Value>(
    _ keyPath: WritableKeyPath<Root, Value>,
    _ value: Value
  ) where Value: Equatable {
    self.keyPath = keyPath
    self.value = value
    self.setter = { $0[keyPath: keyPath] = value }
    self.isEqualTo = { $0 as? Value == value }
  }

  static func set<Value>(
    _ keyPath: WritableKeyPath<Root, Value>,
    _ value: Value
  ) -> Self where Value: Hashable {
    .init(keyPath, value)
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.keyPath == rhs.keyPath && lhs.isEqualTo(rhs.value)
  }
}

func ~= <Root, Value> (
  keyPath: WritableKeyPath<Root, Value>,
  bindingAction: BindingAction<Root>
) -> Bool {
  bindingAction.keyPath == keyPath
}

extension Reducer {
  func binding(
    action bindingAction: CasePath<Action, BindingAction<State>>
  ) -> Self {
    Self { state, action, environment in
      guard let bindingAction = bindingAction.extract(from: action)
      else {
        return self.run(&state, action, environment)
      }

      bindingAction.setter(&state)
      return self.run(&state, action, environment)
    }
  }
}

extension ViewStore {
  func binding<Value>(
    keyPath: WritableKeyPath<State, Value>,
    send action: @escaping (BindingAction<State>) -> Action
  ) -> Binding<Value> where Value: Hashable {
    self.binding(
      get: { $0[keyPath: keyPath] },
      send: { action(.init(keyPath, $0)) }
    )
  }
}

struct SettingsState: Equatable {
  var alert: AlertState? = nil
  var digest = Digest.daily
  var displayName = ""
  var protectMyPosts = false
  var sendNotifications = false
  var sendMobileNotifications = false
  var sendEmailNotifications = false
}

enum SettingsAction: Equatable {
  case authorizationResponse(Result<Bool, NSError>)
  case binding(BindingAction<SettingsState>)
  case notificationSettingsResponse(UserNotificationsClient.Settings)
  case resetButtonTapped
}

struct SettingsEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var userNotifications: UserNotificationsClient
}

let settingsReducer = Reducer<
  SettingsState,
  SettingsAction,
  SettingsEnvironment
> { state, action, environment in

  switch action {
  case .authorizationResponse(.failure):
    state.sendNotifications = false
    return .none

  case let .authorizationResponse(.success(granted)):
    state.sendNotifications = granted
    return granted
    ? environment.userNotifications
      .registerForRemoteNotifications()
      .fireAndForget()
    : .none

  case .binding(\.displayName):
    state.displayName = String(state.displayName.prefix(16))
    return .none

  case .binding(\.sendNotifications):
    guard state.sendNotifications
    else { return .none }

    state.sendNotifications = false

    return environment.userNotifications
      .getNotificationSettings()
      .receive(on: environment.mainQueue)
      .map(SettingsAction.notificationSettingsResponse)
      .eraseToEffect()

  case .binding:
    return .none

  case let .notificationSettingsResponse(settings):
    switch settings.authorizationStatus {
    case .notDetermined, .authorized, .provisional, .ephemeral:
      state.sendNotifications = true
      return environment.userNotifications
        .requestAuthorization(.alert)
        .receive(on: environment.mainQueue)
        .mapError { $0 as NSError }
        .catchToEffect()
        .map(SettingsAction.authorizationResponse)

    case .denied:
      state.sendNotifications = false
      state.alert = .init(title: "You need to enable permissions from iOS settings")
      return .none

    @unknown default:
      return .none
    }

  case .resetButtonTapped:
    state = .init()
    return .none
  }
}
.binding(action: /SettingsAction.binding)

struct TCAFormView: View {
  let store: Store<SettingsState, SettingsAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      Form {
        Section(header: Text("Profile")) {
          TextField(
            "Display name",
            text: viewStore.binding(
              keyPath: \.displayName,
              send: SettingsAction.binding
            )
          )
          Toggle(
            "Protect my posts",
            isOn: viewStore.binding(
              keyPath: \.protectMyPosts,
              send: SettingsAction.binding
            )
          )
        }
        Section(header: Text("Communication")) {
          Toggle(
            "Send notifications",
            isOn: viewStore.binding(
              keyPath: \.sendNotifications,
              send: SettingsAction.binding
            )
          )

          if viewStore.sendNotifications {
            Toggle(
              "Mobile",
              isOn: viewStore.binding(
                keyPath: \.sendMobileNotifications,
                send: SettingsAction.binding
              )
            )

            Toggle(
              "Email",
              isOn: viewStore.binding(
                keyPath: \.sendEmailNotifications,
                send: SettingsAction.binding
              )
            )

            Picker(
              "Top posts digest",
              selection: viewStore.binding(
                keyPath: \.digest,
                send: SettingsAction.binding
              )
            ) {
              ForEach(Digest.allCases, id: \.self) { digest in
                Text(digest.rawValue)
              }
            }
          }
        }
        
        Button("Reset") {
          viewStore.send(.resetButtonTapped)
        }
      }
      .alert(
        item: viewStore.binding(
          keyPath: \.alert,
          send: SettingsAction.binding
        )
      ) { alert in
        Alert(title: Text(alert.title))
      }
      .navigationTitle("Settings")
    }
  }
}

struct TCAFormView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TCAFormView(
        store: Store(
          initialState: .init(),
          reducer: settingsReducer,
          environment: .init(
            mainQueue: .main,
            userNotifications: .init(
              getNotificationSettings: { .init(value: .init(authorizationStatus: .denied)) },
              registerForRemoteNotifications: { fatalError() },
              requestAuthorization: { _ in fatalError() }
            )
          )
        )
      )
    }
  }
}
