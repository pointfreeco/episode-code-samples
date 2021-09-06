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

