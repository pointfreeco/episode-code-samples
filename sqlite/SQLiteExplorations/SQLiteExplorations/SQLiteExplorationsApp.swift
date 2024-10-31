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
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
