import SwiftUI

@main
struct ReliablyTestingAsyncApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(model: NumberFactModel())
    }
  }
}
