import Foundation
import GRDB

struct Player: MutablePersistableRecord, FetchableRecord, Codable {
  static let databaseTableName = "players"

  var id: Int64?
  var name = ""
  var createdAt: Date
  var isInjured = false

  mutating func didInsert(_ inserted: InsertionSuccess) {
    id = inserted.rowID
  }
}

extension DatabaseQueue {
  static func appDatabase() throws -> DatabaseQueue {
    let databasePath = URL.documentsDirectory.appending(path: "db.sqlite")
      .path()
    print("open", databasePath)
    var config = Configuration()
    config.prepareDatabase {
      $0.trace { print($0) }
    }
    let databaseQueue: DatabaseQueue
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == nil
    {
      databaseQueue = try DatabaseQueue(
        path: databasePath,
        configuration: config
      )
    } else {
      databaseQueue = try DatabaseQueue(configuration: config)
    }
    var migrator = DatabaseMigrator()
    #if DEBUG
      migrator.eraseDatabaseOnSchemaChange = true
    #endif
    migrator.registerMigration("Create 'players' table") { db in
      try db.create(table: Player.databaseTableName) { table in
        table.autoIncrementedPrimaryKey("id")
        table.column("name", .text).notNull()
        table.column("createdAt", .datetime).notNull()
      }
    }
    migrator.registerMigration("Add 'isInjured' to 'players'") { db in
      try db.alter(table: Player.databaseTableName) { table in
        table.add(column: "isInjured", .boolean).defaults(to: false)
      }
    }
    #if DEBUG && targetEnvironment(simulator)
      migrator.registerMigration("Seed simulator data") { db in
        _ = try Player(name: "Blob", createdAt: Date(), isInjured: false)
          .inserted(db)
        _ = try Player(name: "Blob Jr", createdAt: Date(), isInjured: false)
          .inserted(db)
        _ = try Player(name: "Blob Sr", createdAt: Date(), isInjured: true)
          .inserted(db)
      }
    #endif
    try migrator.migrate(databaseQueue)
    return databaseQueue
  }
}
