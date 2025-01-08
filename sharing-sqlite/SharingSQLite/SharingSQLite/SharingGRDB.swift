import GRDB
import Sharing

struct FetchAllKey<Record: FetchableRecord & Sendable>: SharedKey {
  let database: DatabaseQueue
  let sql: String

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

  func save(_ value: [Record], context: SaveContext, continuation: SaveContinuation) {
    try database.write { db in

    }
  }
}
