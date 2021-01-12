import SwiftUI

struct VanillaSwiftUIFormView: View {
  var body: some View {
    Form {
      Section(header: Text("Profile")) {
        TextField("Display name", text: .constant(""))
        Toggle("Protect my posts", isOn: .constant(false))
      }
      Section(header: Text("Communication")) {
        Toggle("Send notifications", isOn: .constant(false))

        Picker(
          "Top posts digest",
          selection: .constant(Digest.off)
        ) {
          Text("daily")
          Text("weekly")
          Text("off")
        }
      }
    }
    .navigationTitle("Settings")
  }
}

enum Digest {
  case daily
  case weekly
  case off
}

struct VanillaSwiftUIFormView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      VanillaSwiftUIFormView()
    }
  }
}
