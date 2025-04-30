import SwiftUI

@main
struct ModernPersistenceApp: App {
  init() {
    let _ = try! appDatabase()
  }

  var body: some Scene {
    WindowGroup {
    }
  }
}
