import SwiftUI
import SiteRouter

@main
struct ClientApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        viewModel: ViewModel(
          apiClient: .live(router: router.baseURL("http://127.0.0.1:8080"))
        )
      )
    }
  }
}
