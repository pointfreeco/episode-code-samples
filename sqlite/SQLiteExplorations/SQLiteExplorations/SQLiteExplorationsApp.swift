import SQLite3
import SwiftUI

@main
struct SQLiteExplorationsApp: App {
  init() {
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
    sqlite3_bind_int64(statement, 1, Int64(Date().addingTimeInterval(-10).timeIntervalSince1970))
    while sqlite3_step(statement) == SQLITE_ROW {
      struct Player {
        let id: Int64
        let name: String
        let createdAt: Date
      }
      let id: Int64 = sqlite3_column_int64(statement, 0)
      let name = String(cString: sqlite3_column_text(statement, 1))
      let createdAt = Date(timeIntervalSince1970: Double(sqlite3_column_int64(statement, 2)))
      let player = Player(id: id, name: name, createdAt: createdAt)
      print(player)
    }
    sqlite3_finalize(statement)
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
