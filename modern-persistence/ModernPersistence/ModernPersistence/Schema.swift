import Foundation
import OSLog
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
      }
    }
  #endif

  try migrator.migrate(database)

  return database
}

private let logger = Logger(subsystem: "Reminders", category: "Database")
