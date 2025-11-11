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
  static let model = RemindersListsModel()

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
          RemindersListAsset.self
        )
      }
    }
  }

  var body: some Scene {
    WindowGroup {
//      if context == .live {
//        NavigationStack {
//          RemindersListsView(model: Self.model)
//        }
//      }
      CounterView()
    }
  }
}

struct CounterView: View {
  @State var count1 = 0
  @State var count2 = 0
  @State var count3 = 0

  var body: some View {
    VStack {
      Stepper("1: \(count1)", value: $count1)
      Stepper("2: \(count2)", value: $count2)
      Stepper("3: \(count3)", value: $count3)
    }
    .onChange(of: count2) {
      count3 += 1
    }
    .onChange(of: count1) {
      count2 += 1
    }
  }
}
