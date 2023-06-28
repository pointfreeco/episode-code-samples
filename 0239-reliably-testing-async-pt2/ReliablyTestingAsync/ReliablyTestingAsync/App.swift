import SwiftUI

@main
struct ReliablyTestingAsyncApp: App {
  var body: some Scene {
    WindowGroup {
      if NSClassFromString("XCTestCase") == nil {
        ContentView(model: NumberFactModel())
      }
    }
  }
}
