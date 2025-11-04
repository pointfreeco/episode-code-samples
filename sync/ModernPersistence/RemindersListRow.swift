import CloudKit
import SwiftUI

struct RemindersListRowView: View {
  let incompleteRemindersCount: Int
  let remindersList: RemindersList
  let share: CKShare?

  var body: some View {
    HStack {
      Image(systemName: "list.bullet.circle.fill")
        .font(.title)
        .foregroundStyle(Color(hex: remindersList.color))
      VStack(alignment: .leading) {
        Text(remindersList.title)
        if let share {
          Text(participants(share: share))
        }
      }
      Spacer()
      Text("\(incompleteRemindersCount)")
    }
  }

  // Shared with you
  // Shared by you
  // Shared with Brandon, Blob Jr
  // Shared by Brandon
  func participants(share: CKShare) -> String {
    let isOwner = share.currentUserParticipant?.role == .owner
    let hasParticipants = share.participants.contains { $0.role != .owner }
    switch (isOwner, hasParticipants) {
    case (true, true):
      let participantNames = share.participants.compactMap {
        $0.role == .owner ? nil : $0.userIdentity.nameComponents?.formatted()
      }
      .formatted()
      return "Shared with \(participantNames)"
    case (true, false):
      return "Shared by you"
    case (false, true):
      let owner = share.participants.first(where: { $0.role == .owner })
      guard let owner, let ownerName = owner.userIdentity.nameComponents?.formatted()
      else {
        return "Shared with you"
      }
      return "Shared by \(ownerName)"
    case (false, false):
      return "Shared with you"
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
      RemindersListRowView(
        incompleteRemindersCount: 10,
        remindersList: RemindersList(
          id: UUID(1),
          title: "Personal"
        ),
        share: nil
      )
    }
  }
}
