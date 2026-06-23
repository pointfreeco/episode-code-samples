import SwiftUI

struct AlertsV2View: View {
  @State private var deleteAlertIsPresented = false

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
          Task {
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
          deleteAlertIsPresented = true
        }
      }
    }
    .alert("Delete", isPresented: $deleteAlertIsPresented) {
      Button("Confirm", role: .destructive) {
      }
      Button("Cancel" /*, role: .default*/) {}
      TextField("pointfreeco", text: .constant(""))
        .textInputAutocapitalization(.never)
    } message: {
      Text("Are you sure?")
    }
    .alert(
      alertAction.map {
        switch $0 {
        case .delete: "Delete"
        case .archive: "Archive"
        }
      }
        ?? "",
      item: $alertAction
    ) { action in
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
    //      ?? "",
    //      isPresented: $alertActionIsPresented,
    //      presenting: alertAction
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
  AlertsV2View()
}
