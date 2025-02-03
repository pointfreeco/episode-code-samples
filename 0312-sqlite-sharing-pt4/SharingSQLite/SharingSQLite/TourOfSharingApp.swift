import Dependencies
import GRDB
import SwiftUI

@main
struct SharingSQLiteApp: App {
  static let model = FactFeatureModel()

  init() {
    prepareDependencies {
      $0.defaultDatabase = .appDatabase
    }
  }

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        FactFeatureView(model: Self.model)
      }
    }
  }
}
