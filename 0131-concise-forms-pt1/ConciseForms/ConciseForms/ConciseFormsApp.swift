import SwiftUI

@main
struct ConciseFormsApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        VanillaSwiftUIFormView(viewModel: SettingsViewModel())
      }
    }
  }
}
