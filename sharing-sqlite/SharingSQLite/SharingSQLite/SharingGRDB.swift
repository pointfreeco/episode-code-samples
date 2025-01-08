import Dependencies
import GRDB
import IssueReporting
import Sharing

private enum DefaultDatabaseKey: DependencyKey {
  static var liveValue: any DatabaseWriter {
    reportIssue(
      """
      A blank, in-memory database is being used for the app. \
      Override this dependency in the entry point of your app.
      """
    )
    return try! DatabaseQueue()
  }
}
extension DependencyValues {
  var defaultDatabase: any DatabaseWriter {
    get { self[DefaultDatabaseKey.self] }
    set { self[DefaultDatabaseKey.self] = newValue }
  }
}

extension SharedReaderKey {
  static func fetchAll<Record>(
    _ sql: String
  ) -> Self where Self == FetchAllKey<Record>.Default {
    Self[FetchAllKey(sql: sql), default: []]
  }
}

struct FetchAllKey<Record: FetchableRecord & Sendable>: SharedReaderKey {
  let database: any DatabaseReader
  let sql: String

  init(sql: String) {
    @Dependency(\.defaultDatabase) var database
    self.database = database
    self.sql = sql
  }

  struct ID: Hashable {
    let databaseObjectIdentifier: ObjectIdentifier
    let sql: String
  }

  var id: ID {
    ID(databaseObjectIdentifier: ObjectIdentifier(database), sql: sql)
  }

  func load(
    context: LoadContext<[Record]>,
    continuation: LoadContinuation<[Record]>
  ) {
    continuation.resume(
      with: Result {
        try database.read { db in
          try Record.fetchAll(db, sql: sql)
        }
      }
    )
  }

  func subscribe(
    context: LoadContext<[Record]>,
    subscriber: SharedSubscriber<[Record]>
  ) -> SharedSubscription {
    let cancellable = ValueObservation.tracking { db in
      try Record.fetchAll(db, sql: sql)
    }
    .start(in: database, scheduling: .async(onQueue: .main)) { error in
      subscriber.yield(throwing: error)
    } onChange: { records in
      subscriber.yield(records)
    }
    return SharedSubscription {
      cancellable.cancel()
    }
  }
}
