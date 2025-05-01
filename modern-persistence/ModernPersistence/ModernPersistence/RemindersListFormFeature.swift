import SharingGRDB
import SwiftUI

struct RemindersListForm: View {
  @Dependency(\.defaultDatabase) var database
  @Environment(\.dismiss) var dismiss
  @State var remindersList: RemindersList

  var body: some View {
    Form {
      Section {
        VStack {
          TextField("List Name", text: $remindersList.title)
            .font(.system(.title2, design: .rounded, weight: .bold))
            .foregroundStyle(Color(hex: remindersList.color))
            .multilineTextAlignment(.center)
            .padding()
            .textFieldStyle(.plain)
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(.buttonBorder)
      }
      ColorPicker("Color", selection: $remindersList.color.swiftUIColor)
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem {
        Button("Save") {
          withErrorReporting {
            try database.write { db in
              try RemindersList.insert(remindersList)
                .execute(db)
            }
          }
          dismiss()
        }
      }
      ToolbarItem(placement: .cancellationAction) {
        Button("Cancel") {
          dismiss()
        }
      }
    }
  }
}

extension Int {
  var swiftUIColor: Color {
    get {
      Color(hex: self)
    }
    set {
      guard let components = UIColor(newValue).cgColor.components
      else { return }
      let r = Int(components[0] * 0xFF) << 24
      let g = Int(components[1] * 0xFF) << 16
      let b = Int(components[2] * 0xFF) << 8
      let a = Int((components.indices.contains(3) ? components[3] : 1) * 0xFF)
      self = r | g | b | a
    }
  }
}

#Preview {
  let _ = prepareDependencies {
    $0.defaultDatabase = try! appDatabase()
  }
  Form {
  }
  .sheet(isPresented: .constant(true)) {
    NavigationStack {
      RemindersListForm(
        remindersList: RemindersList(
          id: 212498712849,
          color: 0xef7e4a_ff,
          title: "Family"
        )
      )
    }
    .presentationDetents([.medium])
  }
}
