import SwiftUI
import UserNotifications

struct AlertState: Equatable, Identifiable {
  var title: String
  var id: String { self.title }
}

class SettingsViewModel: ObservableObject {
  @Published var alert: AlertState?
  @Published var digest = Digest.off
  @Published var displayName = "" {
    didSet {
      guard self.displayName.count > 16
      else { return }

      self.displayName = String(self.displayName.prefix(16))
    }
  }
  @Published var protectMyPosts = false
  @Published var sendNotifications = false

  func attemptToggleSendNotifications(isOn: Bool) {
    guard isOn else {
      self.sendNotifications = false
      return
    }

    UNUserNotificationCenter.current()
      .getNotificationSettings { settings in
        guard settings.authorizationStatus != .denied
        else {
          DispatchQueue.main.async {
            self.alert = .init(title: "You need to enable permissions from iOS settings")
          }
          return
        }

        DispatchQueue.main.async {
          self.sendNotifications = true
        }

        UNUserNotificationCenter.current()
          .requestAuthorization(options: .alert) { granted, error in

            if !granted || error != nil {
              DispatchQueue.main.async {
                self.sendNotifications = false
              }
            } else {
              UIApplication.shared.registerForRemoteNotifications()
            }
          }
      }
  }
  
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
        Toggle(
          "Send notifications",
          isOn: Binding(
            get: { self.viewModel.sendNotifications },
            set: { isOn in
              self.viewModel.attemptToggleSendNotifications(isOn: isOn)
            }
          )
            //self.$viewModel.sendNotifications
        )

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
    .alert(item: self.$viewModel.alert) { alert in
      Alert(title: Text(alert.title))
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
