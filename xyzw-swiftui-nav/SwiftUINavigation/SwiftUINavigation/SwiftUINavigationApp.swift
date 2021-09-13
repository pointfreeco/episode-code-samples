import SwiftUI

@main
struct SwiftUINavigationApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(viewModel: .init())
    }
  }
}
