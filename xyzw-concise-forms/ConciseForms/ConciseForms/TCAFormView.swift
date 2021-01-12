import ComposableArchitecture
import SwiftUI

struct SettingsState: Equatable {
  var alert: AlertState? = nil
  var digest = Digest.daily
  var displayName = ""
  var protectMyPosts = false
  var sendNotifications = false
}

enum SettingsAction {
  case digestChanged(Digest)
  case dismissAlert
  case displayNameChanged(String)
  case protectMyPostsChanged(Bool)
  case resetButtonTapped
  case sendNotificationsChanged(Bool)
}

struct SettingsEnvironment {}

let settingsReducer =
  Reducer<SettingsState, SettingsAction, SettingsEnvironment> { state, action, environment in
    
    switch action {
    case let .digestChanged(digest):
      state.digest = digest
      return .none
      
    case .dismissAlert:
      state.alert = nil
      return .none
      
    case let .displayNameChanged(displayName):
      state.displayName = displayName
      return .none
      
    case let .protectMyPostsChanged(protectMyPosts):
      state.protectMyPosts = protectMyPosts
      return .none
      
    case .resetButtonTapped:
      state = .init()
      return .none
      
    case let .sendNotificationsChanged(sendNotifications):
      state.sendNotifications = sendNotifications
      return .none
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
          environment: SettingsEnvironment()
        )
      )
    }
  }
}
