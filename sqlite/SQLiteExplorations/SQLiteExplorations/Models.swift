import Foundation
import GRDB

struct Player: MutablePersistableRecord, FetchableRecord, Codable, Identifiable {
  static let databaseTableName = "players"

  var id: Int64?
  var name = ""
  var createdAt: Date
  var isInjured = false
  var teamID: Int64?

  mutating func didInsert(_ inserted: InsertionSuccess) {
    id = inserted.rowID
  }
}

struct Team: MutablePersistableRecord, FetchableRecord, Codable, Identifiable {
  static let databaseTableName = "teams"

  var id: Int64?
  var name = ""

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
    config.foreignKeysEnabled = true
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
    migrator.registerMigration("Create 'teams' table") { db in
      try db.create(table: Team.databaseTableName) { table in
        table.autoIncrementedPrimaryKey("id")
        table.column("name", .text).notNull()
      }
      try db.alter(table: Player.databaseTableName) { table in
        table.add(column: "teamID", .integer)
          .references("teams")
      }
    }
    #if DEBUG && targetEnvironment(simulator)
      migrator.registerMigration("Seed simulator data") { db in
        let lions = try Team(name: "Lions").inserted(db)
        let tigers = try Team(name: "Tigers").inserted(db)
        let bears = try Team(name: "Bears").inserted(db)
        _ = try Player(name: "Blob", createdAt: Date(), isInjured: false, teamID: lions.id)
          .inserted(db)
        _ = try Player(name: "Blob Jr", createdAt: Date(), isInjured: false, teamID: tigers.id)
          .inserted(db)
        _ = try Player(name: "Blob Sr", createdAt: Date(), isInjured: true, teamID: bears.id)
          .inserted(db)
      }
    #endif
    try migrator.migrate(databaseQueue)

    return databaseQueue
  }
}
