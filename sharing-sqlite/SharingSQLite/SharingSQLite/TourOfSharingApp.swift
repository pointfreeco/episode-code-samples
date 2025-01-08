import SwiftUI

@main
struct SharingSQLiteApp: App {
  let model = FactFeatureModel(database: .appDatabase)

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        FactFeatureView(model: model)
      }
    }
  }
}
