import SwiftUI

@main
struct StackExplorationApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        model: AppModel(
          path: [
            .counter(CounterModel())
          ]
        )
      )
    }
  }
}
