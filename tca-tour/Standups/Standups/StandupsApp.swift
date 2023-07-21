import ComposableArchitecture
import SwiftUI

@main
struct StandupsApp: App {
  var body: some Scene {
    WindowGroup {
      var editedStandup = Standup.mock
      let _ = editedStandup.title += " Morning Sync"

      AppView(
        store: Store(
          initialState: AppFeature.State(
            path: StackState([
              .detail(
                StandupDetailFeature.State(
                  editStandup: StandupFormFeature.State(
                    focus: .attendee(editedStandup.attendees[3].id),
                    standup: editedStandup
                  ),
                  standup: .mock
                )
              )
            ]),
            standupsList: StandupsListFeature.State(standups: [.mock])
          )
        ) {
          AppFeature()
            ._printChanges()
        }
      )
    }
  }
}
