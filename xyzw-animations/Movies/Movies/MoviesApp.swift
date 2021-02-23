import SwiftUI

@main
struct MoviesApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        viewModel: MoviesViewModel()
      )
    }
  }
}
