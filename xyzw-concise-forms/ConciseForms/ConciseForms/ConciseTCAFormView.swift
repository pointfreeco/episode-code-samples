import ComposableArchitecture
import SwiftUI

enum ConciseSettingsAction: Equatable {
  case authorizationResponse(Result<Bool, NSError>)
  case digestChanged(Digest)
  case dismissAlert
  case displayNameChanged(String)
  case notificationSettingsResponse(UserNotificationsClient.Settings)
  case protectMyPostsChanged(Bool)
  case resetButtonTapped
  case sendNotificationsChanged(Bool)
  
//  case form((inout SettingsState) -> Void)
  case form<Value>(WritableKeyPath<SettingsState, Value>, Value)
  
  static func == (lhs: ConciseSettingsAction, rhs: ConciseSettingsAction) -> Bool {
    fatalError()
  }
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
          .map(ConciseSettingsAction.authorizationResponse)

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
        .map(ConciseSettingsAction.notificationSettingsResponse)
        .eraseToEffect()
      
//    case let .form(update):
//      update(&state)
//      return .none
    case let .form(keyPath, value):
      state[keyPath: keyPath] = value
      
      if keyPath == \SettingsState.displayName {
        // TODO: truncate name
      } else if keyPath == \SettingsState.sendNotifications {
        // TODO: request notifications authorization
      }
    }
}

struct ConciseTCAFormView: View {
  let store: Store<SettingsState, ConciseSettingsAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      Form {
        Section(header: Text("Profile")) {
          TextField(
            "Display name",
            text: Binding(
              get: { viewStore.displayName },
              set: {
//                viewStore.send(.form { $0.displayName = displayName })
                viewStore.send(.form(\.displayName, $0))
              }
            )
//            text: viewStore.binding(
//              get: \.displayName,
//              send: ConciseSettingsAction.displayNameChanged
//            )
          )
          Toggle(
            "Protect my posts",
            isOn: viewStore.binding(
              get: \.protectMyPosts,
              send: ConciseSettingsAction.protectMyPostsChanged
            )
          )
        }
        Section(header: Text("Communication")) {
          Toggle(
            "Send notifications",
            isOn: viewStore.binding(
              get: \.sendNotifications,
              send: ConciseSettingsAction.sendNotificationsChanged
            )
          )

          if viewStore.sendNotifications {
            Picker(
              "Top posts digest",
              selection: viewStore.binding(
                get: \.digest,
                send: ConciseSettingsAction.digestChanged
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
          send: ConciseSettingsAction.dismissAlert
        )
      ) { alert in
        Alert(title: Text(alert.title))
      }
      .navigationTitle("Settings")
    }
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
