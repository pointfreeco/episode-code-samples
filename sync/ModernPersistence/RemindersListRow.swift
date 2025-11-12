import CloudKit
import SwiftUI

struct RemindersListRowView: View {
  let incompleteRemindersCount: Int
  let remindersList: RemindersList
  var shareSummary: String?

  var body: some View {
    HStack {
      Image(systemName: "list.bullet.circle.fill")
        .font(.title)
        .foregroundStyle(Color(hex: remindersList.color))
      VStack(alignment: .leading) {
        Text(remindersList.title)
        if let shareSummary {
          Text(shareSummary)
        }
      }
      Spacer()
      Text("\(incompleteRemindersCount)")
    }
    .buttonStyle(.plain)
  }
}

extension Color {
  init(hex: Int) {
    self.init(
      red: Double((hex >> 24) & 0xFF) / 255.0,
      green: Double((hex >> 16) & 0xFF) / 255.0,
      blue: Double((hex >> 8) & 0xFF) / 255.0,
      opacity: Double(hex & 0xFF) / 0xFF
    )
  }
}

#Preview {
  NavigationStack {
    List {
      RemindersListRowView(
        incompleteRemindersCount: 10,
        remindersList: RemindersList(
          id: UUID(1),
          title: "Personal"
        ),
        shareSummary: "Shared with Blob, Blob Jr"
      )
    }
  }
}
