import ComposableArchitecture
import SwiftUI

@main
struct DerivedBehaviorApp: App {
  var body: some Scene {
    WindowGroup {
      TcaContentView(
        store: Store(
          initialState: .init(),
          reducer: appReducer,
          environment: .init()
        )
      )
    }
  }
}
