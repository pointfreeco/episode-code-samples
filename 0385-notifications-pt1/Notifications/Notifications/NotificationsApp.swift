import SwiftUI

@main
struct NotificationsApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear {
          NotificationCenter.default.addObserver(
            forName: .increment,
            object: nil,
            queue: OperationQueue()
          ) { notification in
            Thread.sleep(forTimeInterval: 1)
            print("Hello!")
          }
        }
    }
  }
}
