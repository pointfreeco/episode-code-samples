import InlineSnapshotTesting
import SQLiteData
import Testing

@testable import ModernPersistence

extension BaseTestSuite {
  @MainActor
  struct RemindersDetailTests {
    @Dependency(\.defaultDatabase) var database
    @Test func querying() async throws {
      let remindersList = try await database.read { db in
        try RemindersList.find(2).fetchOne(db)!
      }
      let model = RemindersDetailModel(detailType: .remindersList(remindersList))

      try await model.$reminders.load()
      assertInlineSnapshot(of: model.reminders, as: .customDump) {
        """
        [
          [0]: Reminder(
            id: 6,
            dueDate: Date(2009-02-15T23:31:30.000Z),
            isCompleted: false,
            isFlagged: true,
            notes: "",
            priority: .high,
            remindersListID: 2,
            title: "Pick up kids from school"
          ),
          [1]: Reminder(
            id: 8,
            dueDate: Date(2009-02-17T23:31:30.000Z),
            isCompleted: false,
            isFlagged: false,
            notes: "",
            priority: .high,
            remindersListID: 2,
            title: "Take out trash"
          )
        ]
        """
      }

      await model.toggleShowCompletedButtonTapped()
      try await model.$reminders.load()
      assertInlineSnapshot(of: model.reminders, as: .customDump) {
        """
        [
          [0]: Reminder(
            id: 6,
            dueDate: Date(2009-02-15T23:31:30.000Z),
            isCompleted: false,
            isFlagged: true,
            notes: "",
            priority: .high,
            remindersListID: 2,
            title: "Pick up kids from school"
          ),
          [1]: Reminder(
            id: 8,
            dueDate: Date(2009-02-17T23:31:30.000Z),
            isCompleted: false,
            isFlagged: false,
            notes: "",
            priority: .high,
            remindersListID: 2,
            title: "Take out trash"
          ),
          [2]: Reminder(
            id: 7,
            dueDate: Date(2009-02-11T23:31:30.000Z),
            isCompleted: true,
            isFlagged: false,
            notes: "",
            priority: .low,
            remindersListID: 2,
            title: "Get laundry"
          )
        ]
        """
      }

      await model.orderingButtonTapped(.priority)
      try await model.$reminders.load()
      assertInlineSnapshot(of: model.reminders, as: .customDump) {
        """
        [
          [0]: Reminder(
            id: 6,
            dueDate: Date(2009-02-15T23:31:30.000Z),
            isCompleted: false,
            isFlagged: true,
            notes: "",
            priority: .high,
            remindersListID: 2,
            title: "Pick up kids from school"
          ),
          [1]: Reminder(
            id: 8,
            dueDate: Date(2009-02-17T23:31:30.000Z),
            isCompleted: false,
            isFlagged: false,
            notes: "",
            priority: .high,
            remindersListID: 2,
            title: "Take out trash"
          ),
          [2]: Reminder(
            id: 7,
            dueDate: Date(2009-02-11T23:31:30.000Z),
            isCompleted: true,
            isFlagged: false,
            notes: "",
            priority: .low,
            remindersListID: 2,
            title: "Get laundry"
          )
        ]
        """
      }
    }
  }
}
