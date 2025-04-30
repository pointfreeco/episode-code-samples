import Foundation
import SharingGRDB

@Table
struct RemindersList: Identifiable {
  let id: Int
  var color = 0x4a99ef_ff
  var title = ""
}

@Table
struct Tag: Identifiable {
  let id: Int
  var title = ""
}

@Table
struct Reminder: Identifiable {
  let id: Int
  @Column(as: Date.ISO8601Representation?.self)
  var dueDate: Date?
  var isCompleted = false
  var isFlagging = false
  var notes = ""
  var priority: Priority?
  var remindersListID: RemindersList.ID
  var title = ""

  enum Priority: Int, QueryBindable {
    case low = 1
    case medium
    case high
  }
}

@Table
struct ReminderTag {
  let reminderID: Reminder.ID
  let tagID: Tag.ID
}
