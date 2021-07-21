import ComposableArchitecture
import SwiftUI

struct InconciseSettingsState: Equatable {
  var alert: AlertState? = nil
  var digest = Digest.daily
  var displayName = ""
  var protectMyPosts = false
  var sendNotifications = false
  var sendMobileNotifications = false
  var sendEmailNotifications = false
}

enum InconciseSettingsAction: Equatable {
  case authorizationResponse(Result<Bool, NSError>)
  case digestChanged(Digest)
  case dismissAlert
  case displayNameChanged(String)
  case notificationSettingsResponse(UserNotificationsClient.Settings)
  case protectMyPostsChanged(Bool)
  case resetButtonTapped
  case sendNotificationsChanged(Bool)
  case sendMobileNotificationsChanged(Bool)
  case sendEmailNotificationsChanged(Bool)
}

struct InconciseSettingsEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var userNotifications: UserNotificationsClient
}

let InconciseSettingsReducer =
  Reducer<InconciseSettingsState, InconciseSettingsAction, InconciseSettingsEnvironment> { state, action, environment in

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
          .map(InconciseSettingsAction.authorizationResponse)

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
      guard sendNotifications
      else {
        state.sendNotifications = sendNotifications
        return .none
      }

      return environment.userNotifications
        .getNotificationSettings()
        .receive(on: environment.mainQueue)
        .map(InconciseSettingsAction.notificationSettingsResponse)
        .eraseToEffect()

    case let .sendEmailNotificationsChanged(isOn):
      state.sendEmailNotifications = true
      return .none

    case let .sendMobileNotificationsChanged(isOn):
      state.sendMobileNotifications = isOn
      return .none
    }
}

struct InconciseSettingsView: View {
  let store: Store<InconciseSettingsState, InconciseSettingsAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      Form {
        Section(header: Text("Profile")) {
          TextField(
            "Display name",
            text: viewStore.binding(
              get: \.displayName,
              send: InconciseSettingsAction.displayNameChanged
            )
          )
          Toggle(
            "Protect my posts",
            isOn: viewStore.binding(
              get: \.protectMyPosts,
              send: InconciseSettingsAction.protectMyPostsChanged
            )
          )
        }
        Section(header: Text("Communication")) {
          Toggle(
            "Send notifications",
            isOn: viewStore.binding(
              get: \.sendNotifications,
              send: InconciseSettingsAction.sendNotificationsChanged
            )
          )

          if viewStore.sendNotifications {
            Toggle(
              "Mobile",
              isOn: viewStore.binding(
                get: \.sendMobileNotifications,
                send: InconciseSettingsAction.sendMobileNotificationsChanged
              )
            )

            Toggle(
              "Email",
              isOn: viewStore.binding(
                get: \.sendEmailNotifications,
                send: InconciseSettingsAction.sendEmailNotificationsChanged
              )
            )

            Picker(
              "Top posts digest",
              selection: viewStore.binding(
                get: \.digest,
                send: InconciseSettingsAction.digestChanged
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
          send: InconciseSettingsAction.dismissAlert
        )
      ) { alert in
        Alert(title: Text(alert.title))
      }
      .navigationTitle("Settings")
    }
  }
}

struct InconciseSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      InconciseSettingsView(
        store: Store(
          initialState: InconciseSettingsState(),
          reducer: InconciseSettingsReducer,
          environment: InconciseSettingsEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            userNotifications: UserNotificationsClient(
              getNotificationSettings: { Effect(value: .init(authorizationStatus: .authorized)) },
              registerForRemoteNotifications: { .none },
              requestAuthorization: { _ in .init(value: true) }
            )
          )
        )
      )
    }
  }
}
