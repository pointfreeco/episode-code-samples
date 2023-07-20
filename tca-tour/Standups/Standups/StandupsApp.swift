import ComposableArchitecture
import SwiftUI

@main
struct StandupsApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        StandupsListView(
          store: Store(
            initialState: StandupsListFeature.State(
              addStandup: StandupFormFeature.State(
                focus: .attendee(Standup.mock.attendees[2].id),
                standup: .mock
              )
            )
          ) {
            StandupsListFeature()
          }
        )
      }
    }
  }
}
