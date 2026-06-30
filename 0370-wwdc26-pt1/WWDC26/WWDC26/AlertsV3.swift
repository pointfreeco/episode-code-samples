import SwiftUI
import SwiftUINavigation

struct AlertsV3View: View {
  @State private var deleteConfirmation: String?

  @State private var alertAction: Action?
  @CaseBindable
  enum Action: Identifiable {
    var id: some Hashable { Self.allCasePaths[self] }
    case delete(confirmation: String)
    case archive
  }

  var body: some View {
    Form {
      Section {
        Button("Delete") {
          alertAction = .delete(confirmation: "")
        }
        Button("Archive") {
          alertAction = .archive
        }
      }
      Section {
        Button("Delete") {
          deleteConfirmation = ""
        }
      }
    }
    .alert(item: $deleteConfirmation) { _ in
      Text("Delete")
    } actions: { $deleteConfirmation in
      Button("Confirm", role: .destructive) {
        print(deleteConfirmation == "pointfreeco" ? "✅" : "🛑")
      }
      TextField("pointfreeco", text: $deleteConfirmation)
        .textInputAutocapitalization(.never)
    } message: { _ in
      Text("Enter name to confirm")
    }
    .alert(item: $alertAction) {
      switch $0 {
      case .delete: Text("Delete")
      case .archive: Text("Archive")
      }
    } actions: { $action in
      switch $action.cases {
      case .delete(let $confirmation):
        Button("Confirm", role: .destructive) {
          print($confirmation.wrappedValue == "pointfreeco" ? "✅" : "🛑")
        }
        TextField("pointfreeco", text: $confirmation)
          .textInputAutocapitalization(.never)
      case .archive:
        Button("Confirm") {}
        Button(role: .cancel) {}
      }
    } message: { action in
      switch action {
      case .delete:
        Text("Confirm name to delete")
      case .archive:
        Text("Do you want to archive?")
      }
    }
  }
}

#Preview {
  AlertsV3View()
}
