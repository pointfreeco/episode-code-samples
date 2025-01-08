import SwiftUI

@main
struct SharingSQLiteApp: App {
  let model = FactFeatureModel()

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        FactFeatureView(model: model)
      }
    }
  }
}
