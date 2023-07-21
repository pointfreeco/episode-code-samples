import ComposableArchitecture
import SwiftUI

@main
struct StandupsApp: App {
  var body: some Scene {
    WindowGroup {
      var standup = Standup.mock
      let _ = standup.duration = .seconds(6)

      AppView(
        store: Store(
          initialState: AppFeature.State(
            path: StackState([
//              .detail(StandupDetailFeature.State(standup: .mock)),
//              .recordMeeting(RecordMeetingFeature.State(standup: standup)),
//              .recordMeeting(RecordMeetingFeature.State(standup: standup)),
            ]),
            standupsList: StandupsListFeature.State(standups: [standup])
          )
        ) {
          AppFeature()
            ._printChanges()
        }
      )
    }
  }
}
