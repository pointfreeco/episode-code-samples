import CloudKit
import SQLiteData
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    let configuration = UISceneConfiguration(
      name: "Default Configuration",
      sessionRole: connectingSceneSession.role
    )
    configuration.delegateClass = SceneDelegate.self
    return configuration
  }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  @Dependency(\.defaultSyncEngine) var syncEngine

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let cloudKitShareMetadata = connectionOptions.cloudKitShareMetadata
    else { return }
    Task {
      do {
        try await syncEngine.acceptShare(metadata: cloudKitShareMetadata)
      } catch {
        // TODO: Let user know CloudKit is having problems
      }
    }
  }

  func windowScene(_ windowScene: UIWindowScene, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
    Task {
      do {
        try await syncEngine.acceptShare(metadata: cloudKitShareMetadata)
      } catch {
        // TODO: Let user know CloudKit is having problems
      }
    }
  }
}

@main
struct ModernPersistenceApp: App {
  @UIApplicationDelegateAdaptor var delegate: AppDelegate

  @Dependency(\.context) var context
  @Dependency(\.defaultSyncEngine) var syncEngine
  static let model = RemindersListsModel()
  @State var syncEngineDelegate = RemindersSyncEngineDelegate()

  init() {
    if context == .live {
      prepareDependencies {
        $0.defaultDatabase = try! appDatabase()
        $0.defaultSyncEngine = try! SyncEngine(
          for: $0.defaultDatabase,
          tables: RemindersList.self,
          Reminder.self,
          Tag.self,
          ReminderTag.self,
          RemindersListAsset.self,
          delegate: syncEngineDelegate
        )
      }
    }
  }

  var body: some Scene {
    WindowGroup {
      if context == .live {
        NavigationStack {
          RemindersListsView(model: Self.model)
        }
        .alert(
          "Reset local data?",
          isPresented: $syncEngineDelegate.isDeleteLocalDataAlertPresented
        ) {
          Button("Delete local data", role: .destructive) {
            Task {
              await withErrorReporting {
                try await syncEngine.deleteLocalData()
              }
            }
          }
        } message: {
          Text("""
              You are no longer logged into iCloud. Would you like \
              to reset your local data to the defaults? This will \
              not affect your data in iCloud.
              """)
        }
      }
    }
  }
}

@MainActor
@Observable
final class RemindersSyncEngineDelegate: SyncEngineDelegate {
  var isDeleteLocalDataAlertPresented = false

  func syncEngine(
    _ syncEngine: SyncEngine,
    accountChanged changeType: CKSyncEngine.Event.AccountChange.ChangeType
  ) async {
    switch changeType {
    case .signIn:
      break
    case .signOut, .switchAccounts:
      isDeleteLocalDataAlertPresented = true
    @unknown default:
      break
    }
  }
}
