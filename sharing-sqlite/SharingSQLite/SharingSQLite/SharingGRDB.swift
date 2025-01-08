import GRDB
import Sharing

extension SharedReaderKey {
  static func fetchAll<Record>(
    _ sql: String,
    database: DatabaseQueue
  ) -> Self where Self == FetchAllKey<Record>.Default {
    Self[FetchAllKey(database: database, sql: sql), default: []]
  }
}

struct FetchAllKey<Record: FetchableRecord & Sendable>: SharedReaderKey {
  let database: DatabaseQueue
  let sql: String

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
