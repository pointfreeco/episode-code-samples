import ComposableArchitecture
import SwiftUI

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

struct SettingsState: Equatable {
  var alert: AlertState? = nil
  var digest = Digest.daily
  var displayName = ""
  var protectMyPosts = false
  var sendNotifications = false
}

enum SettingsAction: Equatable {
  case authorizationResponse(Result<Bool, NSError>)
  case digestChanged(Digest)
  case dismissAlert
  case displayNameChanged(String)
  case notificationSettingsResponse(UserNotificationsClient.Settings)
  case protectMyPostsChanged(Bool)
  case resetButtonTapped
  case sendNotificationsChanged(Bool)
}

struct SettingsEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var userNotifications: UserNotificationsClient
}

let settingsReducer =
  Reducer<SettingsState, SettingsAction, SettingsEnvironment> { state, action, environment in
    
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

    case let .digestChanged(digest):
      state.digest = digest
      return .none
      
    case .dismissAlert:
      state.alert = nil
      return .none
      
    case let .displayNameChanged(displayName):
      state.displayName = String(displayName.prefix(16))
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
      
    case let .protectMyPostsChanged(protectMyPosts):
      state.protectMyPosts = protectMyPosts
      return .none
      
    case .resetButtonTapped:
      state = .init()
      return .none
      
    case let .sendNotificationsChanged(sendNotifications):
//      state.sendNotifications = sendNotifications
      guard sendNotifications
      else {
        state.sendNotifications = sendNotifications
        return .none
      }

      return environment.userNotifications
        .getNotificationSettings()
        .receive(on: environment.mainQueue)
        .map(SettingsAction.notificationSettingsResponse)
        .eraseToEffect()
    }
}

struct TCAFormView: View {
  let store: Store<SettingsState, SettingsAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      Form {
        Section(header: Text("Profile")) {
          TextField(
            "Display name",
            text: viewStore.binding(
              get: \.displayName,
              send: SettingsAction.displayNameChanged
            )
          )
          Toggle(
            "Protect my posts",
            isOn: viewStore.binding(
              get: \.protectMyPosts,
              send: SettingsAction.protectMyPostsChanged
            )
          )
        }
        Section(header: Text("Communication")) {
          Toggle(
            "Send notifications",
            isOn: viewStore.binding(
              get: \.sendNotifications,
              send: SettingsAction.sendNotificationsChanged
            )
          )

          if viewStore.sendNotifications {
            Picker(
              "Top posts digest",
              selection: viewStore.binding(
                get: \.digest,
                send: SettingsAction.digestChanged
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
          get: \.alert,
          send: SettingsAction.dismissAlert
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
          initialState: SettingsState(),
          reducer: settingsReducer,
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
