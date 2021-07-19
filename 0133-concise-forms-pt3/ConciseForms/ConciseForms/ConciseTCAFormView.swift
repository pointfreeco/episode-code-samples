import ComposableArchitecture
import SwiftUI
import UserNotifications

struct UserNotificationsClient {
  var getNotificationSettings: () -> Effect<Settings, Never>
  var registerForRemoteNotifications: () -> Effect<Never, Never>
  var requestAuthorization: (UNAuthorizationOptions) -> Effect<Bool, Error>

  struct Settings: Equatable {
    var authorizationStatus: UNAuthorizationStatus
  }
}

extension UserNotificationsClient.Settings {
  init(rawValue: UNNotificationSettings) {
    self.authorizationStatus = rawValue.authorizationStatus
  }
}

extension UserNotificationsClient {
  static let live = Self(
    getNotificationSettings: {
      .future { callback in
        UNUserNotificationCenter.current()
          .getNotificationSettings { settings in
            callback(.success(.init(rawValue: settings)))
          }
      }
    },
    registerForRemoteNotifications: {
      .fireAndForget {
        UIApplication.shared
          .registerForRemoteNotifications()
      }
    },
    requestAuthorization: { options in
      .future { callback in
        UNUserNotificationCenter.current()
          .requestAuthorization(options: options) { granted, error in
            if let error = error {
              callback(.failure(error))
            } else {
              callback(.success(granted))
            }
          }
      }
    }
  )
}

@propertyWrapper
struct BindableState<Value> {
  var wrappedValue: Value

  var projectedValue: Self {
    get { self }
    set { self = newValue }
  }
}

protocol BindableAction {
  associatedtype State

  static func binding(_ action: BindingAction<State>) -> Self
}

extension BindableState: Equatable where Value: Equatable {}

struct SettingsState: Equatable {
  @BindableState var alert: AlertState? = nil
  @BindableState var digest = Digest.daily
  @BindableState var displayName = ""
  @BindableState var protectMyPosts = false
  @BindableState var sendNotifications = false
  @BindableState var sendMobileNotifications = false
  @BindableState var sendEmailNotifications = false
}

enum ConciseSettingsAction: Equatable, BindableAction {
  case authorizationResponse(Result<Bool, NSError>)
  case notificationSettingsResponse(UserNotificationsClient.Settings)
  case resetButtonTapped
  case binding(BindingAction<SettingsState>)
}

struct BindingAction<Root>: Equatable {
  let keyPath: PartialKeyPath<Root>
  let value: AnyHashable
  let setter: (inout Root) -> Void

  init<Value>(
    _ keyPath: WritableKeyPath<Root, BindableState<Value>>,
    _ value: Value
  ) where Value: Hashable {
    self.keyPath = keyPath
    self.value = AnyHashable(value)
    self.setter = { $0[keyPath: keyPath].wrappedValue = value }
  }

  static func set<Value>(
    _ keyPath: WritableKeyPath<Root, BindableState<Value>>,
    _ value: Value
  ) -> Self where Value: Hashable {
    .init(keyPath, value)
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.keyPath == rhs.keyPath && lhs.value == rhs.value
  }
}

struct SettingsEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var userNotifications: UserNotificationsClient
}

let conciseSettingsReducer =
  Reducer<SettingsState, ConciseSettingsAction, SettingsEnvironment> { state, action, environment in

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

//    case let .digestChanged(digest):
//      state.digest = digest
//      return .none

//    case .dismissAlert:
//      state.alert = nil
//      return .none

//    case let .displayNameChanged(displayName):
//      state.displayName = String(displayName.prefix(16))
//      return .none

    case let .notificationSettingsResponse(settings):
      switch settings.authorizationStatus {
      case .notDetermined, .authorized, .provisional, .ephemeral:
        state.sendNotifications = true
        return environment.userNotifications
          .requestAuthorization(.alert)
          .receive(on: environment.mainQueue)
          .mapError { $0 as NSError }
          .catchToEffect()
          .map(ConciseSettingsAction.authorizationResponse)

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

    case .binding(\.displayName):
      state.displayName = String(state.displayName.prefix(16))
      return .none

    case .binding(\.sendNotifications):
      guard state.sendNotifications
      else {
        return .none
      }

      state.sendNotifications = false

      return environment.userNotifications
        .getNotificationSettings()
        .receive(on: environment.mainQueue)
        .map(ConciseSettingsAction.notificationSettingsResponse)
        .eraseToEffect()

    case .binding:
      return .none
    }
}
  .binding(action: /ConciseSettingsAction.binding)

func ~= <Root, Value> (
  keyPath: WritableKeyPath<Root, Value>,
  action: BindingAction<Root>
) -> Bool {
  action.keyPath == keyPath
}
//
//func foo() {
//  switch 42 {
//  case 10...:
//    print("10 or more")
//  default:
//    break
//  }
//
//  (1...10) ~= 42
//}

extension Reducer {
  func binding(
    action toBindingAction: CasePath<Action, BindingAction<State>>
  ) -> Self {
    Self { state, action, environment in
      guard let bindingAction = toBindingAction.extract(from: action)
      else {
        return self.run(&state, action, environment)
      }

      bindingAction.setter(&state)
      return self.run(&state, action, environment)
    }
  }
}

struct ConciseTCAFormView: View {
  let store: Store<SettingsState, ConciseSettingsAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      Form {
        Section(header: Text("Profile")) {
          TextField("Display name", text: viewStore.$displayName)
          Toggle("Protect my posts", isOn: viewStore.$protectMyPosts)
        }
        Section(header: Text("Communication")) {
          Toggle("Send notifications", isOn: viewStore.$sendNotifications)

          if viewStore.sendNotifications {
            Toggle("Mobile", isOn: viewStore.$sendMobileNotifications)
            Toggle("Email", isOn: viewStore.$sendEmailNotifications)
            Picker("Top posts digest", selection: viewStore.$digest) {
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
      .alert(item: viewStore.$alert) { alert in
        Alert(title: Text(alert.title))
      }
      .navigationTitle("Settings")
    }
  }
}

extension ViewStore {
  func binding<Value>(
    keyPath: WritableKeyPath<State, BindableState<Value>>,
    send action: @escaping (BindingAction<State>) -> Action
  ) -> Binding<Value> where Value: Hashable {
    self.binding(
      get: { $0[keyPath: keyPath].wrappedValue },
      send: { action(.init(keyPath, $0)) }
    )
  }

  subscript<Value>(
    dynamicMember keyPath: WritableKeyPath<State, BindableState<Value>>
  ) -> Binding<Value>
  where Action: BindableAction, Action.State == State, Value: Hashable {
    self.binding(
      get: { $0[keyPath: keyPath].wrappedValue },
      send: { Action.binding(.init(keyPath, $0)) }
    )
  }
}

struct ConciseTCAFormView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ConciseTCAFormView(
        store: Store(
          initialState: SettingsState(),
          reducer: conciseSettingsReducer,
          environment: SettingsEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            userNotifications: UserNotificationsClient(
              getNotificationSettings: { Effect(value: .init(authorizationStatus: .denied)) },
              registerForRemoteNotifications: { fatalError() },
              requestAuthorization: { _ in fatalError() }
            )
          )
        )
      )
    }
  }
}
