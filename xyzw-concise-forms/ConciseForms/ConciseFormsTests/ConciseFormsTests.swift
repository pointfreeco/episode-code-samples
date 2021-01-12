import ComposableArchitecture
import XCTest
@testable import ConciseForms

class ConciseFormsTests: XCTestCase {
  func testBasics() {
    let store = TestStore(
      initialState: SettingsState(),
      reducer: settingsReducer,
      environment: SettingsEnvironment(
        mainQueue: DispatchQueue.immediateScheduler.eraseToAnyScheduler(),
        userNotifications: UserNotificationsClient(
          getNotificationSettings: { fatalError() },
          registerForRemoteNotifications: { fatalError() },
          requestAuthorization: { _ in fatalError() }
        )
      )
    )
    store.assert(
      .send(.displayNameChanged("Blob")) {
        $0.displayName = "Blob"
      },
      .send(.displayNameChanged("Blob McBlob, Esq.")) {
        $0.displayName = "Blob McBlob, Esq"
      },
      .send(.protectMyPostsChanged(true)) {
        $0.protectMyPosts = true
      },
      .send(.digestChanged(.weekly)) {
        $0.digest = .weekly
      }
    )
  }
}
