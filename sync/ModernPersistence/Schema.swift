import CloudKit
import Dependencies
import Foundation
import OSLog
import SQLiteData
import Synchronization

@Table
struct RemindersList: Equatable, Identifiable {
  let id: UUID
  var color = 0x4a99ef_ff
  var position = 0
  var title = ""
}
extension RemindersList.Draft: Identifiable {}

@Table
struct RemindersListAsset: Identifiable {
  @Column(primaryKey: true)
  let remindersListID: RemindersList.ID
  var coverImage: Data

  var id: RemindersList.ID {
    remindersListID
  }
}

@Table
struct Tag: Identifiable {
  let id: UUID
  var title = ""
}

extension Tag?.TableColumns {
  var jsonTitles: some QueryExpression<[String].JSONRepresentation> {
    (self.title ?? "").jsonGroupArray(filter: self.id.isNot(nil))
  }
}

@Table
struct Reminder: Identifiable {
  let id: UUID
  var createdAt: Date?
  var dueDate: Date?
  var isFlagged = false
  var notes = ""
  var priority: Priority?
  var remindersListID: RemindersList.ID
  var status: Status = .incomplete
  var title = ""
  var updatedAt: Date?
  var url: URL?

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
  let id: UUID
  let reminderID: Reminder.ID
  let tagID: Tag.ID
}

@Table
struct ReminderText: FTS5 {
  let rowid: Int
  let title: String
  let notes: String
  let tags: String
}
extension ReminderText.TableColumns {
  var defaultRank: some QueryExpression<Double> {
    bm25([\.title: 10, \.notes: 5])
  }
}

@Table
struct RemindersListRow {
  let hasWritePermission: Bool
  let incompleteRemindersCount: Int
  let isOwner: Bool
  let remindersList: RemindersList
  let shareSummary: String?
  var isShared: Bool { shareSummary != nil }
}

extension RemindersListRow.TableColumns {
  var isShared: some QueryExpression<Bool> {
    self.shareSummary.isNot(nil)
  }
}

func appDatabase() throws -> any DatabaseWriter {
  @Dependency(\.context) var context

  let database: any DatabaseWriter

  var configuration = Configuration()
  configuration.foreignKeysEnabled = true
  configuration.prepareDatabase { db in
    db.add(function: $handleDeletedRemindersList)
    db.add(function: $handleReminderStatusUpdate)
    db.add(function: $participants)
    db.add(function: $isOwner)
    db.add(function: $hasWritePermission)
    try db.attachMetadatabase()

    try RemindersListRow.createTemporaryView(
      as: RemindersList
        .group(by: \.id)
        .order(by: \.position)
        .leftJoin(Reminder.all) {
          $0.id.eq($1.remindersListID) && !$1.isCompleted
        }
        .leftJoin(SyncMetadata.all) {
          $0.syncMetadataID.eq($2.id)
        }
        .select {
          RemindersListRow.Columns(
            hasWritePermission: $2.share.map { $hasWritePermission($0) }.ifnull(true),
            incompleteRemindersCount: $1.count(),
            isOwner: $2.share.map { $isOwner(of: $0) }.ifnull(true),
            remindersList: $0,
            shareSummary: $2.share.map { $participants(share: $0) }
          )
        }
    )
    .execute(db)

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
        "title" TEXT NOT NULL DEFAULT '' CHECK(instr("title", ' ') = 0)
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
    try #sql(
      """
      ALTER TABLE "reminders" ADD COLUMN "createdAt" TEXT
      """
    )
    .execute(db)
    try #sql(
      """
      ALTER TABLE "reminders" ADD COLUMN "updatedAt" TEXT
      """
    )
    .execute(db)
  }
  migrator.registerMigration("Add 'position' to 'remindersLists'") { db in
    try #sql(
      """
      ALTER TABLE "remindersLists" ADD COLUMN "position" INTEGER NOT NULL DEFAULT 0
      """
    )
    .execute(db)
  }
  migrator.registerMigration("Add 'status' to 'reminders'") { db in
    try #sql(
      """
      ALTER TABLE "reminders" ADD COLUMN "status" INTEGER NOT NULL DEFAULT 0
      """
    )
    .execute(db)
    try #sql(
      """
      UPDATE "reminders" SET "status" = "isCompleted"
      """
    )
    .execute(db)
  }
  migrator.registerMigration("Create reminders FTS table") { db in
    try #sql(
      """
      CREATE VIRTUAL TABLE "reminderTexts" USING fts5(
        "title",
        "notes",
        "tags",
        tokenize='trigram'
      )
      """
    )
    .execute(db)
  }
  migrator.registerMigration("Convert primary keys to UUID") { db in
    try SyncEngine.migratePrimaryKeys(
      db,
      tables: RemindersList.self, Reminder.self, Tag.self, ReminderTag.self
    )
  }
  migrator.registerMigration("Add URL to reminders") { db in
    try #sql("""
      ALTER TABLE "reminders" ADD COLUMN "url" TEXT
      """)
    .execute(db)
  }
  migrator.registerMigration("Create RemindersListAsset table") { db in
    try #sql("""
      CREATE TABLE "remindersListAssets" (
        "remindersListID" TEXT NOT NULL PRIMARY KEY REFERENCES "remindersLists"("id") ON DELETE CASCADE,
        "coverImage" BLOB NOT NULL
      ) STRICT
      """)
    .execute(db)
  }
  try migrator.migrate(database)

  try database.write { db in
    try Reminder.createTemporaryTrigger(after: .insert(touch: \.createdAt))
      .execute(db)
    try Reminder.createTemporaryTrigger(after: .update(touch: \.updatedAt))
      .execute(db)

    try RemindersList.createTemporaryTrigger(
      after: .delete { old in
        #sql("SELECT \($handleDeletedRemindersList())")
      }
    )
    .execute(db)

    try RemindersList.createTemporaryTrigger(after: .insert {
      $0.position = RemindersList.count() - 1
    })
    .execute(db)

    try ReminderTag.createTemporaryTrigger(
      before: .insert { new in
        #sql("SELECT RAISE(ABORT, 'Reminders can have a maximum of 5 tags.')")
      } when: { new in
        ReminderTag
          .where { $0.reminderID.eq(new.reminderID) }
          .count() >= 5
      }
    )
    .execute(db)

    try Reminder.createTemporaryTrigger(
      after: .update {
        $0.status
      } forEachRow: { old, new in
        #sql("SELECT \($handleReminderStatusUpdate())")
      } when: { old, new in
        new.status.eq(Reminder.Status.completing)
      }
    )
    .execute(db)

    try Reminder.createTemporaryTrigger(
      after: .insert { new in
        ReminderText.insert {
          ReminderText.Columns(
            rowid: new.rowid,
            title: new.title,
            notes: new.notes,
            tags: ""
          )
        }
      }
    )
    .execute(db)

    try Reminder.createTemporaryTrigger(
      after: .update {
        ($0.title, $0.notes)
      } forEachRow: { _, new in
        ReminderText
          .where { $0.rowid.eq(new.rowid) }
          .update {
            $0.title = new.title
            $0.notes = new.notes
          }
      }
    )
    .execute(db)

    try Reminder.createTemporaryTrigger(
      after: .delete { old in
        ReminderText
          .where { $0.rowid.eq(old.rowid) }
          .delete()
      }
    )
    .execute(db)

    func updateTags(for reminderRowID: some QueryExpression<Int>) -> UpdateOf<ReminderText> {
      ReminderText
        .where { $0.rowid.eq(reminderRowID) }
        .update {
          $0.tags =
            Tag
            .join(ReminderTag.all) { $0.id.eq($1.tagID) }
            .join(Reminder.all) { $1.reminderID.eq($2.id) }
            .where { $2.rowid.eq(reminderRowID) }
            .select { tag, _, _ in ("#" + tag.title).groupConcat(" ") }
            ?? ""
        }
    }

    try ReminderTag.createTemporaryTrigger(
      after: .insert { new in
        updateTags(for: new.rowid)
      }
    )
    .execute(db)

    try ReminderTag.createTemporaryTrigger(
      after: .delete { old in
        updateTags(for: old.rowid)
      }
    )
    .execute(db)

    try #sql(
      """
      INSERT INTO \(ReminderText.self)
      (\(ReminderText.self), rank) 
      VALUES
      ('rank', 'bm25(0, 10, 5)')
      """
    )
    .execute(db)

    #if DEBUG
      if context != .live {
        try seedDatabase(db)
      }
    #endif
  }

  return database
}

@DatabaseFunction
private func handleDeletedRemindersList() {
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
}

private let task = Mutex<Task<Void, any Error>?>(nil)
@DatabaseFunction
private func handleReminderStatusUpdate() {
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
}

@DatabaseFunction(
  as: ((CKShare.SystemFieldsRepresentation) -> String).self,
  isDeterministic: true
)
func participants(share: CKShare) -> String {
  print("Computing participant names")
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
    guard let owner, let _ = owner.userIdentity.nameComponents?.formatted()
    else {
      return "Shared with you"
    }
    return "Shared by Brandon Williams"
  case (false, false):
    return "Shared with you"
  }
}
@DatabaseFunction(
  as: ((CKShare.SystemFieldsRepresentation) -> Bool).self,
  isDeterministic: true
)
func isOwner(of share: CKShare) -> Bool {
  share.currentUserParticipant?.role == .owner
}

@DatabaseFunction(
  as: ((CKShare.SystemFieldsRepresentation) -> Bool).self,
  isDeterministic: true
)
func hasWritePermission(_ share: CKShare) -> Bool {
  share.publicPermission == .readWrite
    || share.currentUserParticipant?.permission == .readWrite
}

private let logger = Logger(subsystem: "Reminders", category: "Database")

#if DEBUG
  func seedDatabase(_ db: Database) throws {
    @Dependency(\.date.now) var now
    try db.seed {
      RemindersList(id: UUID(1), color: 0x4a99ef_ff, position: 0, title: "Personal")
      RemindersList(id: UUID(2), color: 0xef7e4a_ff, position: 1, title: "Family")
      RemindersList(id: UUID(3), color: 0x7ee04a_ff, position: 2, title: "Business")

      Reminder(
        id: UUID(1),
        notes:
          "Check weekly specials\nChips\nDips\nYogurt\nGranola\nTomatoes\nMilk\nEggs\nApples\nOatmeal\nSpinach",
        remindersListID: UUID(1),
        title: "Groceries"
      )
      Reminder(
        id: UUID(2),
        dueDate: now.addingTimeInterval(-60 * 60 * 24 * 2),
        isFlagged: true,
        notes: "Ask if I can reschedule next week",
        remindersListID: UUID(1),
        title: "Haircut next week"
      )
      Reminder(
        id: UUID(3),
        dueDate: now.addingTimeInterval(60 * 60 * 12),
        notes: "Ask about diet",
        priority: .high,
        remindersListID: UUID(1),
        title: "Doctor appointment"
      )
      Reminder(
        id: UUID(4),
        dueDate: now.addingTimeInterval(-60 * 60 * 24 * 190),
        remindersListID: UUID(1),
        status: .completed,
        title: "Take a walk this week"
      )
      Reminder(
        id: UUID(5),
        dueDate: now,
        remindersListID: UUID(1),
        title: "Buy concert tickets",
        url: URL(string: "https://www.buytix.com")!
      )
      Reminder(
        id: UUID(6),
        dueDate: now.addingTimeInterval(60 * 60 * 24 * 2),
        isFlagged: true,
        priority: .high,
        remindersListID: UUID(2),
        title: "Pick up kids from school"
      )
      Reminder(
        id: UUID(7),
        dueDate: now.addingTimeInterval(-60 * 60 * 24 * 2),
        priority: .low,
        remindersListID: UUID(2),
        status: .completed,
        title: "Get laundry"
      )
      Reminder(
        id: UUID(8),
        dueDate: now.addingTimeInterval(60 * 60 * 24 * 4),
        priority: .high,
        remindersListID: UUID(2),
        title: "Take out trash"
      )
      Reminder(
        id: UUID(9),
        dueDate: now.addingTimeInterval(60 * 60 * 24 * 2),
        notes: """
          Status of tax return
          Expenses for next year
          Changing payroll company
          """,
        remindersListID: UUID(3),
        title: "Call accountant"
      )
      Reminder(
        id: UUID(10),
        dueDate: now.addingTimeInterval(-60 * 60 * 24 * 2),
        priority: .medium,
        remindersListID: UUID(3),
        status: .completed,
        title: "Send weekly emails"
      )

      Tag(id: UUID(1), title: "weekend")
      Tag(id: UUID(2), title: "fun")
      Tag(id: UUID(3), title: "easy-win")
      Tag(id: UUID(4), title: "exercise")
      Tag(id: UUID(5), title: "social")
      Tag(id: UUID(6), title: "point-free")

      ReminderTag(id: UUID(), reminderID: UUID(1), tagID: UUID(1))
      ReminderTag(id: UUID(), reminderID: UUID(2), tagID: UUID(1))
      ReminderTag(id: UUID(), reminderID: UUID(4), tagID: UUID(1))

      ReminderTag(id: UUID(), reminderID: UUID(4), tagID: UUID(2))
      ReminderTag(id: UUID(), reminderID: UUID(5), tagID: UUID(2))

      ReminderTag(id: UUID(), reminderID: UUID(2), tagID: UUID(3))
      ReminderTag(id: UUID(), reminderID: UUID(6), tagID: UUID(3))
      ReminderTag(id: UUID(), reminderID: UUID(7), tagID: UUID(3))
      ReminderTag(id: UUID(), reminderID: UUID(8), tagID: UUID(3))
    }
  }
#endif
