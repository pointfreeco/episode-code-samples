import SQLiteData
import SwiftUI

@main
struct ModernPersistenceApp: App {
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
          RemindersListAsset.self,
//          startImmediately: false
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
      }
    }
  }
}
