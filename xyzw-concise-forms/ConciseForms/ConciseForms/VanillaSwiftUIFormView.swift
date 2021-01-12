import SwiftUI

class SettingsViewModel: ObservableObject {
  @Published var digest = Digest.off
  @Published var displayName = ""
  @Published var protectMyPosts = false
  @Published var sendNotifications = false
  
  func reset() {
    self.digest = .off
    self.displayName = ""
    self.protectMyPosts = false
    self.sendNotifications = false
  }
}

struct VanillaSwiftUIFormView: View {
  @ObservedObject var viewModel: SettingsViewModel
  
  var body: some View {
    Form {
      Section(header: Text("Profile")) {
        TextField("Display name", text: self.$viewModel.displayName)
        Toggle("Protect my posts", isOn: self.$viewModel.protectMyPosts)
      }
      Section(header: Text("Communication")) {
        Toggle("Send notifications", isOn: self.$viewModel.sendNotifications)

        if self.viewModel.sendNotifications {
          Picker(
            "Top posts digest",
            selection: self.$viewModel.digest
          ) {
            ForEach(Digest.allCases, id: \.self) { digest in
              Text(digest.rawValue)
            }
          }
        }
      }
      
      Button("Reset") {
        self.viewModel.reset()
      }
    }
    .navigationTitle("Settings")
  }
}

enum Digest: String, CaseIterable {
  case daily
  case weekly
  case off
}

struct VanillaSwiftUIFormView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      VanillaSwiftUIFormView(
        viewModel: SettingsViewModel()
      )
    }
  }
}
