import SwiftUI

@main
struct StandupsApp: App {
  var body: some Scene {
    WindowGroup {
      StandupsList(
        model: StandupsListModel(
//          destination: .detail(
//            StandupDetailModel(
//              destination: .alert(.delete),
//              standup: .mock
//            )
//          ),
          standups: [
            .mock
          ]
        )
      )
    }
  }
}
