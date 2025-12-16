import SwiftUI
import Dependencies

@main
struct ScorekeeperApp: App {
  init() {
    prepareDependencies {
      try! $0.bootstrapDatabase()
    }
  }
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        GamesView()
      }
    }
  }
}
