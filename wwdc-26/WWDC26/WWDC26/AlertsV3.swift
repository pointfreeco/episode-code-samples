import SwiftUI
import SwiftUINavigation

struct AlertsV3View: View {
  //  @State private var deleteAlertIsPresented = false
  //  @State private var deleteConfirmation = ""
  @State private var deleteConfirmation: String?

  @State private var alertAction: Action?
  enum Action: Identifiable {
    var id: Self { self }
    case delete
    case archive
  }

  var body: some View {
    Form {
      Section {
        Button("Delete") {
          alertAction = .delete
          _ = Task {
            try await Task.sleep(for: .seconds(1))
            alertAction = .archive
          }
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
    //    .alert("Delete", isPresented: $deleteAlertIsPresented) {
    //      Button("Confirm", role: .destructive) {
    //        print(deleteConfirmation == "pointfreeco" ? "✅" : "🛑")
    //        deleteConfirmation = ""
    //      }
    //      Button("Cancel", role: .cancel) {
    //        deleteConfirmation = ""
    //      }
    //      TextField("pointfreeco", text: $deleteConfirmation)
    //        .textInputAutocapitalization(.never)
    //    } message: {
    //      Text("Are you sure?")
    //    }
    .alert(item: $alertAction) {
      switch $0 {
      case .delete: Text("Delete")
      case .archive: Text("Archive")
      }
    } actions: { action in
      switch action {
      case .delete:
        Button("Confirm", role: .destructive) {}
        TextField("pointfreeco", text: .constant(""))
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
    //    .alert(
    //      alertAction.map {
    //        switch $0 {
    //        case .delete: "Delete"
    //        case .archive: "Archive"
    //        }
    //      }
    //        ?? "",
    //      item: $alertAction
    //    ) { action in
    //      switch action {
    //      case .delete:
    //        Button("Confirm", role: .destructive) {}
    //        TextField("pointfreeco", text: .constant(""))
    //          .textInputAutocapitalization(.never)
    //      case .archive:
    //        Button("Confirm") {}
    //        Button(role: .cancel) {}
    //      }
    //    } message: { action in
    //      switch action {
    //      case .delete:
    //        Text("Confirm name to delete")
    //      case .archive:
    //        Text("Do you want to archive?")
    //      }
    //    }
  }
}

#Preview {
  AlertsV3View()
}
