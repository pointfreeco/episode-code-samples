import SwiftUI

struct AlertsV1View: View {
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
    .alert(isPresented: $deleteAlertIsPresented) {
      Alert(
        title: Text("Delete"),
        primaryButton: .destructive(Text("Confirm")),
        secondaryButton: .cancel()
      )
    }
    .alert(item: $alertAction) { action in
      switch action {
      case .delete:
        Alert(
          title: Text("Delete"),
          primaryButton: .destructive(Text("Confirm")),
          secondaryButton: .cancel()
        )
      case .archive:
        Alert(
          title: Text("Archive"),
          primaryButton: .default(Text("Confirm")),
          secondaryButton: .cancel()
        )
      }
    }
  }
}

#Preview {
  AlertsV1View()
}
