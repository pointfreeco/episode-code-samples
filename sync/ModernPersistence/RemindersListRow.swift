import SwiftUI

struct RemindersListRow: View {
  let incompleteRemindersCount: Int
  let remindersList: RemindersList

  var body: some View {
    HStack {
      Image(systemName: "list.bullet.circle.fill")
        .font(.title)
        .foregroundStyle(Color(hex: remindersList.color))
      Text(remindersList.title)
      Spacer()
      Text("\(incompleteRemindersCount)")
    }
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
      RemindersListRow(
        incompleteRemindersCount: 10,
        remindersList: RemindersList(
          id: UUID(1),
          title: "Personal"
        )
      )
    }
  }
}
