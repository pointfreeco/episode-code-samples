import SQLite3
import SwiftUI

@main
struct SQLiteExplorationsApp: App {
  init() {
    let databasePath = URL.documentsDirectory.appending(path: "db.sqlite").path()
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
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
