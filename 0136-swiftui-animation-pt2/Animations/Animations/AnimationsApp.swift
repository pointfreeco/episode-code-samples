import SwiftUI

@main
struct AnimationsApp: App {
  var body: some Scene {
    WindowGroup {
//      ContentView()
      TCAContentView(store: .init(initialState: .init(), reducer: appReducer, environment: .init()))
    }
  }
}
