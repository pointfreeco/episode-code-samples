import Foundation
import OSLog
import SharingGRDB

@Table
struct RemindersList: Equatable, Identifiable {
  let id: Int
  var color = 0x4a99ef_ff
  var title = ""
}
extension RemindersList.Draft: Identifiable {}

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
  var isFlagged = false
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

func appDatabase() throws -> any DatabaseWriter {
  @Dependency(\.context) var context

  let database: any DatabaseWriter

  var configuration = Configuration()
  configuration.foreignKeysEnabled = true
  configuration.prepareDatabase { db in
    #if DEBUG
      db.trace(options: .profile) {
        if context == .preview {
          print($0.expandedDescription)
        } else {
          logger.debug("\($0.expandedDescription)")
        }
      }
    #endif
  }

  switch context {
  case .live:
    let path = URL.documentsDirectory.appending(component: "db.sqlite").path()
    logger.info("open \(path)")
    database = try DatabasePool(path: path, configuration: configuration)
  case .preview, .test:
    database = try DatabaseQueue(configuration: configuration)
  }

  var migrator = DatabaseMigrator()
  #if DEBUG
    migrator.eraseDatabaseOnSchemaChange = true
  #endif
  migrator.registerMigration("Create tables") { db in
    try #sql(
      """
      CREATE TABLE "remindersLists" (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "color" INTEGER NOT NULL DEFAULT \(raw: 0x4a99ef_ff),
        "title" TEXT NOT NULL DEFAULT ''
      ) STRICT
      """
    )
    .execute(db)
    try #sql(
      """
      CREATE TABLE "tags" (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "title" TEXT NOT NULL DEFAULT ''
      ) STRICT
      """
    )
    .execute(db)
    try #sql(
      """
      CREATE TABLE "reminders" (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "dueDate" TEXT,
        "isCompleted" INTEGER NOT NULL DEFAULT 0,
        "isFlagged" INTEGER NOT NULL DEFAULT 0,
        "notes" TEXT NOT NULL DEFAULT '',
        "priority" INTEGER,
        "remindersListID" INTEGER NOT NULL REFERENCES "remindersLists"("id") ON DELETE CASCADE,
        "title" TEXT NOT NULL DEFAULT ''
      ) STRICT
      """
    )
    .execute(db)
    try #sql(
      """
      CREATE TABLE "reminderTags" (
        "reminderID" INTEGER NOT NULL REFERENCES "reminders"("id") ON DELETE CASCADE,
        "tagID" INTEGER NOT NULL REFERENCES "tags"("id") ON DELETE CASCADE
      ) STRICT
      """
    )
    .execute(db)
  }
  #if DEBUG
    migrator.registerMigration("Seed database") { db in
      try db.seed {
        RemindersList(id: 1, color: 0x4a99ef_ff, title: "Personal")
        RemindersList(id: 2, color: 0xef7e4a_ff, title: "Family")
        RemindersList(id: 3, color: 0x7ee04a_ff, title: "Business")

        Reminder(
          id: 1,
          notes: "Milk\nEggs\nApples\nOatmeal\nSpinach",
          remindersListID: 1,
          title: "Groceries"
        )
        Reminder(
          id: 2,
          dueDate: Date().addingTimeInterval(-60 * 60 * 24 * 2),
          isFlagged: true,
          remindersListID: 1,
          title: "Haircut"
        )
        Reminder(
          id: 3,
          dueDate: Date(),
          notes: "Ask about diet",
          priority: .high,
          remindersListID: 1,
          title: "Doctor appointment"
        )
        Reminder(
          id: 4,
          dueDate: Date().addingTimeInterval(-60 * 60 * 24 * 190),
          isCompleted: true,
          remindersListID: 1,
          title: "Take a walk"
        )
        Reminder(
          id: 5,
          dueDate: Date(),
          remindersListID: 1,
          title: "Buy concert tickets"
        )
        Reminder(
          id: 6,
          dueDate: Date().addingTimeInterval(60 * 60 * 24 * 2),
          isFlagged: true,
          priority: .high,
          remindersListID: 2,
          title: "Pick up kids from school"
        )
        Reminder(
          id: 7,
          dueDate: Date().addingTimeInterval(-60 * 60 * 24 * 2),
          isCompleted: true,
          priority: .low,
          remindersListID: 2,
          title: "Get laundry"
        )
        Reminder(
          id: 8,
          dueDate: Date().addingTimeInterval(60 * 60 * 24 * 4),
          isCompleted: false,
          priority: .high,
          remindersListID: 2,
          title: "Take out trash"
        )
        Reminder(
          id: 9,
          dueDate: Date().addingTimeInterval(60 * 60 * 24 * 2),
          notes: """
            Status of tax return
            Expenses for next year
            Changing payroll company
            """,
          remindersListID: 3,
          title: "Call accountant"
        )
        Reminder(
          id: 10,
          dueDate: Date().addingTimeInterval(-60 * 60 * 24 * 2),
          isCompleted: true,
          priority: .medium,
          remindersListID: 3,
          title: "Send weekly emails"
        )
      }
    }
  #endif

  try migrator.migrate(database)

  return database
}

private let logger = Logger(subsystem: "Reminders", category: "Database")
