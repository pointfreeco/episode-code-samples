import Dependencies
import Foundation
import OSLog
import SharingGRDB
import Synchronization

@Table
struct RemindersList: Equatable, Identifiable {
  let id: Int
  var color = 0x4a99ef_ff
  var position = 0
  var title = ""
}
extension RemindersList.Draft: Identifiable {}

@Table
struct Tag: Identifiable {
  let id: Int
  var title = ""
}

extension Tag?.TableColumns {
  var jsonTitles: some QueryExpression<[String].JSONRepresentation> {
    (self.title ?? "").jsonGroupArray(filter: self.id.isNot(nil))
  }
}

@Table
struct Reminder: Identifiable {
  let id: Int
  var createdAt: Date?
  var dueDate: Date?
  var isFlagged = false
  var notes = ""
  var priority: Priority?
  var remindersListID: RemindersList.ID
  var status: Status = .incomplete
  var title = ""
  var updatedAt: Date?

  var isCompleted: Bool {
    status != .incomplete
  }

  enum Priority: Int, QueryBindable {
    case low = 1
    case medium
    case high
  }

  enum Status: Int, QueryBindable {
    case completed = 1
    case completing = 2
    case incomplete = 0
  }
}
extension Reminder.Draft: Identifiable {}

extension Updates<Reminder> {
  mutating func toggleStatus() {
    self.status = Case(self.status)
      .when(Reminder.Status.incomplete, then: Reminder.Status.completing)
      .else(Reminder.Status.incomplete)
  }
}

//struct ReminderGRDB: Codable, FetchableRecord, MutablePersistableRecord {
//  var id: Int64?
//  var isCompleted = false
//  var title: String
//  var updatedAt: Date = Date()
//  enum Columns {
//    static let id = Column(CodingKeys.id)
//    static let isCompleted = Column(CodingKeys.isCompleted)
//    static let title = Column(CodingKeys.title)
//    static let updatedAt = Column(CodingKeys.updatedAt)
//  }
//  mutating func willSave(_ db: Database) throws {
//    updatedAt = Date()
//  }
//}
//
//func operation(_ db: Database) throws {
//  var reminder = ReminderGRDB(title: "Get milk")
//  reminder.save(db)
//  reminder.update(<#T##db: Database##Database#>)
//  reminder.delete(<#T##db: Database##Database#>)
//  _ = reminder.updatedAt
//
//  Reminder.upsert { reminder }.execute(db)
//  Reminder.find(reminder.id).delete().execute(db)
//
//  ReminderGRDB.updateAll(db, [ReminderGRDB.Columns.isCompleted.set(to: true)])
//}

extension Reminder.TableColumns {
  var isCompleted: some QueryExpression<Bool> {
    status.neq(Reminder.Status.incomplete)
  }

  var isPastDue: some QueryExpression<Bool> {
    !isCompleted
      && (dueDate ?? Date.distantFuture) < Date()
  }

  var isScheduled: some QueryExpression<Bool> {
    dueDate.isNot(nil)
  }

  var isToday: some QueryExpression<Bool> {
    #sql("date(\(dueDate)) = date()")
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

    db.add(function: DatabaseFunction("handleDeletedRemindersList") { arguments in
      Task {
        @Dependency(\.defaultDatabase) var database

        try await Task.sleep(for: .seconds(1))
        try await database.write { db in
          let isRemindersListEmpty = try RemindersList.count().fetchOne(db) == 0
          if isRemindersListEmpty {
            try RemindersList
              .insert { RemindersList.Draft(title: "Reminders") }
              .execute(db)
          }
        }
      }
      return nil
    })

    let task = Mutex<Task<Void, any Error>?>(nil)
    db.add(function: DatabaseFunction("handleReminderStatusUpdate") { _ in
      task.withLock {
        $0?.cancel()
        $0 = Task {
          @Dependency(\.defaultDatabase) var database

          try await Task.sleep(for: .seconds(2))
          try await database.write { db in
            try Reminder
              .where { $0.status.eq(Reminder.Status.completing) }
              .update { $0.status = .completed }
              .execute(db)
          }
        }
      }
      return nil
    })

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
  migrator.registerMigration("Add 'createdAt' and 'updatedAt' to 'reminders'") { db in
    try #sql("""
      ALTER TABLE "reminders" ADD COLUMN "createdAt" TEXT
      """)
    .execute(db)
    try #sql("""
      ALTER TABLE "reminders" ADD COLUMN "updatedAt" TEXT
      """)
    .execute(db)
  }
  migrator.registerMigration("Add 'position' to 'remindersLists'") { db in
    try #sql("""
      ALTER TABLE "remindersLists" ADD COLUMN "position" INTEGER NOT NULL DEFAULT 0
      """)
    .execute(db)
  }
  migrator.registerMigration("Add 'status' to 'reminders'") { db in
    try #sql("""
      ALTER TABLE "reminders" ADD COLUMN "status" INTEGER NOT NULL DEFAULT 0
      """)
    .execute(db)
    try #sql("""
      UPDATE "reminders" SET "status" = "isCompleted"
      """)
    .execute(db)
    try #sql("""
      ALTER TABLE "reminders" DROP COLUMN "isCompleted"
      """)
    .execute(db)
  }
  #if DEBUG
    migrator.registerMigration("Seed database") { db in
      @Dependency(\.date.now) var now
      try db.seed {
        RemindersList(id: 1, color: 0x4a99ef_ff, position: 0, title: "Personal")
        RemindersList(id: 2, color: 0xef7e4a_ff, position: 1, title: "Family")
        RemindersList(id: 3, color: 0x7ee04a_ff, position: 2, title: "Business")

        Reminder(
          id: 1,
          notes: "Milk\nEggs\nApples\nOatmeal\nSpinach",
          remindersListID: 1,
          title: "Groceries"
        )
        Reminder(
          id: 2,
          dueDate: now.addingTimeInterval(-60 * 60 * 24 * 2),
          isFlagged: true,
          remindersListID: 1,
          title: "Haircut"
        )
        Reminder(
          id: 3,
          dueDate: now.addingTimeInterval(60 * 60 * 12),
          notes: "Ask about diet",
          priority: .high,
          remindersListID: 1,
          title: "Doctor appointment"
        )
        Reminder(
          id: 4,
          dueDate: now.addingTimeInterval(-60 * 60 * 24 * 190),
          remindersListID: 1,
          status: .completed,
          title: "Take a walk"
        )
        Reminder(
          id: 5,
          dueDate: now,
          remindersListID: 1,
          title: "Buy concert tickets"
        )
        Reminder(
          id: 6,
          dueDate: now.addingTimeInterval(60 * 60 * 24 * 2),
          isFlagged: true,
          priority: .high,
          remindersListID: 2,
          title: "Pick up kids from school"
        )
        Reminder(
          id: 7,
          dueDate: now.addingTimeInterval(-60 * 60 * 24 * 2),
          priority: .low,
          remindersListID: 2,
          status: .completed,
          title: "Get laundry"
        )
        Reminder(
          id: 8,
          dueDate: now.addingTimeInterval(60 * 60 * 24 * 4),
          priority: .high,
          remindersListID: 2,
          title: "Take out trash"
        )
        Reminder(
          id: 9,
          dueDate: now.addingTimeInterval(60 * 60 * 24 * 2),
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
          dueDate: now.addingTimeInterval(-60 * 60 * 24 * 2),
          priority: .medium,
          remindersListID: 3,
          status: .completed,
          title: "Send weekly emails"
        )

        Tag(id: 1, title: "weekend")
        Tag(id: 2, title: "fun")
        Tag(id: 3, title: "easy-win")
        Tag(id: 4, title: "exercise")
        Tag(id: 5, title: "social")
        Tag(id: 6, title: "point-free")

        ReminderTag(reminderID: 1, tagID: 1)
        ReminderTag(reminderID: 2, tagID: 1)
        ReminderTag(reminderID: 4, tagID: 1)

        ReminderTag(reminderID: 4, tagID: 2)
        ReminderTag(reminderID: 5, tagID: 2)

        ReminderTag(reminderID: 2, tagID: 3)
        ReminderTag(reminderID: 6, tagID: 3)
        ReminderTag(reminderID: 7, tagID: 3)
        ReminderTag(reminderID: 8, tagID: 3)
      }
    }
  #endif

  try migrator.migrate(database)

  try database.write { db in
    try Reminder.createTemporaryTrigger(afterInsertTouch: \.createdAt)
    .execute(db)
    try Reminder.createTemporaryTrigger(afterUpdateTouch: \.updatedAt)
    .execute(db)

    try RemindersList.createTemporaryTrigger(
      after: .delete { old in
        //RemindersList.insert { RemindersList.Draft(title: "Reminders") }
        #sql("SELECT handleDeletedRemindersList()")
      }
    )
    .execute(db)

    try RemindersList.createTemporaryTrigger(afterInsertTouch: { $0.position = RemindersList.count() - 1 })
      .execute(db)

    try ReminderTag.createTemporaryTrigger(before: .insert { new in
      #sql("SELECT RAISE(ABORT, 'Reminders can have a maximum of 5 tags.')")
    } when: { new in
      ReminderTag
        .where { $0.reminderID.eq(new.reminderID) }
        .count() >= 5
    })
    .execute(db)

    try Reminder.createTemporaryTrigger(after: .update {
      $0.status
    } forEachRow: { old, new in
      #sql("SELECT handleReminderStatusUpdate()")
    } when: { old, new in
      new.status.eq(Reminder.Status.completing)
    })
    .execute(db)
  }

  return database
}

private let logger = Logger(subsystem: "Reminders", category: "Database")
