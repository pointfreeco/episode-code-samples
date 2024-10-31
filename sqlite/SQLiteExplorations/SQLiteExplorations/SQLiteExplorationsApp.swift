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

  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
