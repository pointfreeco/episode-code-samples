import SharingGRDB
import SwiftUI

@main
struct ModernPersistenceApp: App {
  @Dependency(\.context) var context
  static let model = RemindersListsModel()

  init() {
    if context == .live {
      prepareDependencies {
        $0.defaultDatabase = try! appDatabase()
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
