import GRDB
import SQLite3
import SwiftUI
import Synchronization

@main
struct SQLiteExplorationsApp: App {
  init() {
    do {
      let databasePath = URL.documentsDirectory.appending(path: "db.sqlite")
        .path()
      print("open", databasePath)
      var config = Configuration()
      config.prepareDatabase {
        $0.trace { print($0) }
      }
      let databaseQueue = try DatabaseQueue(
        path: databasePath,
        configuration: config
      )
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
      try migrator.migrate(databaseQueue)

      try databaseQueue.write { db in
        var insertedPlayer = try Player(name: "Blob", createdAt: Date(), isInjured: true)
            .inserted(db)
        insertedPlayer.name += " Jr."
        try insertedPlayer.update(db)
      }
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

func sqlite3() {
  let databasePath = URL.documentsDirectory.appending(path: "db.sqlite")
    .path()
  print("open", databasePath)
  var db: OpaquePointer?
  guard
    sqlite3_open_v2(
      databasePath,
      &db,
      SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE,
      nil
    ) == SQLITE_OK
  else {
    fatalError("Could not open database at \(databasePath)")
  }
  print(
    "Create table",
    sqlite3_exec(
      db,
      """
      CREATE TABLE IF NOT EXISTS "players" (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
        "name" TEXT NOT NULL,
        "createdAt" DATETIME NOT NULL
      )
      """,
      nil,
      nil,
      nil
    ) == SQLITE_OK
  )
  let name = "Blob"
  let createdAt = Date()
  var statement: OpaquePointer?
  sqlite3_prepare_v2(
    db,
    """
    INSERT INTO "players"
    ("name", "createdAt") 
    VALUES
    (?, ?)
    """,
    -1,
    &statement,
    nil
  )
  let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
  print(
    "Binding name",
    sqlite3_bind_text(
      statement,
      1,
      name,
      -1,
      SQLITE_TRANSIENT
    ) == SQLITE_OK
  )
  print(
    "Binding createdAt",
    sqlite3_bind_int64(
      statement,
      2,
      Int64(createdAt.timeIntervalSince1970)
    ) == SQLITE_OK
  )
  print(
    "Insert Blob",
    sqlite3_step(statement) == SQLITE_DONE
  )
  print(
    "Finalize insert",
    sqlite3_finalize(statement) == SQLITE_OK
  )
  statement = nil
  sqlite3_prepare_v2(
    db,
    """
    SELECT * FROM "players" WHERE "createdAt" > ?
    """,
    -1,
    &statement,
    nil
  )
  sqlite3_bind_int64(
    statement, 1, Int64(Date().addingTimeInterval(-10).timeIntervalSince1970))
  while sqlite3_step(statement) == SQLITE_ROW {
    struct Player {
      let id: Int64
      let name: String
      let createdAt: Date
    }
    let id: Int64 = sqlite3_column_int64(statement, 0)
    let name = String(cString: sqlite3_column_text(statement, 1))
    let createdAt = Date(
      timeIntervalSince1970: Double(sqlite3_column_int64(statement, 2)))
    let player = Player(id: id, name: name, createdAt: createdAt)
    print(player)
  }
  sqlite3_finalize(statement)
}
