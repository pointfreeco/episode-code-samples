import ComposableArchitecture
import SwiftUI

enum ConciseSettingsAction: Equatable {
  case authorizationResponse(Result<Bool, NSError>)
//  case digestChanged(Digest)
//  case dismissAlert
//  case displayNameChanged(String)
  case notificationSettingsResponse(UserNotificationsClient.Settings)
//  case protectMyPostsChanged(Bool)
  case resetButtonTapped
//  case sendNotificationsChanged(Bool)
  
//  case form((inout SettingsState) -> Void)
  case form(FormAction<SettingsState>)

//  ConciseSettingsAction.form(\.displayName, 1)
}

struct FormAction<Root>: Equatable {
  let keyPath: PartialKeyPath<Root>
  let value: AnyHashable
  let setter: (inout Root) -> Void

  init<Value>(
    _ keyPath: WritableKeyPath<Root, Value>,
    _ value: Value
  ) where Value: Hashable {
    self.keyPath = keyPath
    self.value = AnyHashable(value)
    self.setter = { $0[keyPath: keyPath] = value }
  }

  static func set<Value>(
    _ keyPath: WritableKeyPath<Root, Value>,
    _ value: Value
  ) -> Self where Value: Hashable {
    .init(keyPath, value)
  }

  static func == (lhs: FormAction<Root>, rhs: FormAction<Root>) -> Bool {
    lhs.keyPath == rhs.keyPath && lhs.value == rhs.value
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
      
//    case let .protectMyPostsChanged(protectMyPosts):
//      state.protectMyPosts = protectMyPosts
//      return .none
      
    case .resetButtonTapped:
      state = .init()
      return .none
      
//    case let .sendNotificationsChanged(sendNotifications):
////      state.sendNotifications = sendNotifications
//      guard sendNotifications
//      else {
//        state.sendNotifications = sendNotifications
//        return .none
//      }
//
//      return environment.userNotifications
//        .getNotificationSettings()
//        .receive(on: environment.mainQueue)
//        .map(ConciseSettingsAction.notificationSettingsResponse)
//        .eraseToEffect()
      
//    case let .form(update):
//      update(&state)
//      return .none


    case .form(\.displayName):
      state.displayName = String(state.displayName.prefix(16))
      return .none

    case .form(\.sendNotifications):
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

    case .form:
      return .none
    }
}
  .form(action: /ConciseSettingsAction.form)

func ~= <Root, Value> (
  keyPath: WritableKeyPath<Root, Value>,
  formAction: FormAction<Root>
) -> Bool {
  formAction.keyPath == keyPath
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
  func form(
    action formAction: CasePath<Action, FormAction<State>>
  ) -> Self {
    Self { state, action, environment in
      guard let formAction = formAction.extract(from: action)
      else {
        return self.run(&state, action, environment)
      }

      formAction.setter(&state)
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
          TextField(
            "Display name",
            text: viewStore.binding(
              keyPath: \.displayName,
              send: ConciseSettingsAction.form
            )

//              Binding(
//              get: { viewStore.displayName },
//              set: {
////                viewStore.send(.form { $0.displayName = displayName })
//                viewStore.send(.form(.init(\.displayName, $0)))
//              }
//            )
//            text: viewStore.binding(
//              get: \.displayName,
//              send: ConciseSettingsAction.displayNameChanged
//            )
          )
          Toggle(
            "Protect my posts",
            isOn: viewStore.binding(
              keyPath: \.protectMyPosts,
              send: ConciseSettingsAction.form
            )

//            viewStore.binding(
//              get: \.protectMyPosts,
//              send: ConciseSettingsAction.protectMyPostsChanged
//            )
          )
        }
        Section(header: Text("Communication")) {
          Toggle(
            "Send notifications",
            isOn: viewStore.binding(
              keyPath: \.sendNotifications,
              send: ConciseSettingsAction.form
            )

//              viewStore.binding(
//              get: \.sendNotifications,
//              send: ConciseSettingsAction.sendNotificationsChanged
//            )
          )

          if viewStore.sendNotifications {
            Toggle(
              "Mobile",
              isOn: viewStore.binding(
                keyPath: \.sendMobileNotifications,
                send: ConciseSettingsAction.form
              )
            )

            Toggle(
              "Email",
              isOn: viewStore.binding(
                keyPath: \.sendEmailNotifications,
                send: ConciseSettingsAction.form
              )
            )

            Picker(
              "Top posts digest",
              selection: viewStore.binding(
                keyPath: \.digest,
                send: ConciseSettingsAction.form
              )

//                viewStore.binding(
//                get: \.digest,
//                send: ConciseSettingsAction.digestChanged
//              )
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
          send: ConciseSettingsAction.form
        )

//          viewStore.binding(
//          get: \.alert,
//          send: ConciseSettingsAction.dismissAlert
//        )
      ) { alert in
        Alert(title: Text(alert.title))
      }
      .navigationTitle("Settings")
    }
  }
}

extension ViewStore {
  func binding<Value>(
    keyPath: WritableKeyPath<State, Value>,
    send action: @escaping (FormAction<State>) -> Action
  ) -> Binding<Value> where Value: Hashable {
    self.binding(
      get: { $0[keyPath: keyPath] },
      send: { action(.init(keyPath, $0)) }
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
