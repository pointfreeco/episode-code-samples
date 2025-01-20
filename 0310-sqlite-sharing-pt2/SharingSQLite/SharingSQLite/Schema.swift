import Foundation
import GRDB
import IssueReporting
import Sharing

struct Fact: Codable, Equatable, Identifiable, FetchableRecord,
  MutablePersistableRecord
{
  static let databaseTableName = "facts"

  var id: Int64?
  var number: Int
  var savedAt: Date
  var value: String

  mutating func didInsert(_ inserted: InsertionSuccess) {
    id = inserted.rowID
  }
}

extension DatabaseWriter where Self == DatabaseQueue {
  static var appDatabase: DatabaseQueue {
    let databaseQueue: DatabaseQueue
    var configuration = Configuration()
    configuration.prepareDatabase { db in
      db.trace(options: .profile) {
#if DEBUG
        print($0.expandedDescription)
#else
        print($0)
#endif
      }
    }
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == nil && !isTesting {
      let path = URL.documentsDirectory.appending(component: "db.sqlite").path()
      print("open", path)
      databaseQueue = try! DatabaseQueue(path: path, configuration: configuration)
    } else {
      databaseQueue = try! DatabaseQueue(configuration: configuration)
    }
    var migrator = DatabaseMigrator()
    migrator.registerMigration("Add 'facts' table") { db in
      try db.create(table: "facts") { table in
        table.autoIncrementedPrimaryKey("id")
        table.column("number", .integer).notNull()
        table.column("savedAt", .datetime).notNull()
        table.column("value", .text).notNull()
      }
      @Shared(.favoriteFacts) var legacyFacts
      for fact in legacyFacts {
        try db.execute(literal: """
          INSERT INTO "facts" ("number", "savedAt", "value")
          VALUES (\(fact.number), \(fact.savedAt), \(fact.value))
          """)
      }
      $legacyFacts.withLock { $0.removeAll() }
    }
    do {
      try migrator.migrate(databaseQueue)
    } catch {
      reportIssue(error)
    }
    return databaseQueue
  }
}
