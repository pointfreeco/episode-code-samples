import SwiftUI

@main
struct ConciseFormsApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        VanillaSwiftUIFormView(viewModel: SettingsViewModel())
      }
    }
  }
}
