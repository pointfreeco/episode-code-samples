import ComposableArchitecture
import SwiftUI

@propertyWrapper
struct BindableState<Value> {
  var wrappedValue: Value
  
  var projectedValue: Self {
    get { self }
    set { self = newValue }
  }
}

extension BindableState: Equatable where Value: Equatable {}

struct SettingsState: Equatable {
  @BindableState var alert: AlertState? = nil
  @BindableState var digest = Digest.daily
  @BindableState var displayName = ""
  var isLoading = false
  @BindableState var protectMyPosts = false
  @BindableState var sendNotifications = false
  @BindableState var sendMobileNotifications = false
  @BindableState var sendEmailNotifications = false
  
  func f() {
    self._displayName as BindableState<String>
    self.$displayName as BindableState<String>
  }
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
              keyPath: \.$displayName,
              send: SettingsAction.binding
            )
          )
          Toggle(
            "Protect my posts",
            isOn: viewStore.binding(
              keyPath: \.$protectMyPosts,
              send: SettingsAction.binding
            )
          )
        }
        Section(header: Text("Communication")) {
          Toggle(
            "Send notifications",
            isOn: viewStore.binding(
              keyPath: \.$sendNotifications,
              send: SettingsAction.binding
            )
          )

          if viewStore.sendNotifications {
            Toggle(
              "Mobile",
              isOn: viewStore.binding(
                keyPath: \.$sendMobileNotifications,
                send: SettingsAction.binding
              )
            )

            Toggle(
              "Email",
              isOn: viewStore.binding(
                keyPath: \.$sendEmailNotifications,
                send: SettingsAction.binding
              )
            )

            Picker(
              "Top posts digest",
              selection: viewStore.binding(
                keyPath: \.$digest,
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
//          viewStore.send(.binding(.set(\.$isLoading, true)))
          viewStore.send(.resetButtonTapped)
        }
      }
      .alert(
        item: viewStore.binding(
          keyPath: \.$alert,
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
    NavigationStack {
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
