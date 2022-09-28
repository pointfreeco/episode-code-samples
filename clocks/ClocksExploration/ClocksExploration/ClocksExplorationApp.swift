import SwiftUI

@main
struct ClocksExplorationApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(model: FeatureModel(clock: ContinuousClock()))
    }
  }
}
