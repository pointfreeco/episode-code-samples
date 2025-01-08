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
  static func fetch<Value>(
    _ request: some FetchKeyRequest<Value>
  ) -> Self where Self == FetchKey<Value> {
    FetchKey(request: request)
  }

  static func fetch<Value: RangeReplaceableCollection>(
    _ request: some FetchKeyRequest<Value>
  ) -> Self where Self == FetchKey<Value>.Default {
    Self[FetchKey(request: request), default: Value()]
  }

  static func fetchAll<Record>(
    _ sql: String
  ) -> Self where Self == FetchAllKey<Record>.Default {
    Self[FetchAllKey(sql: sql), default: []]
  }

  static func fetchAll<Record, Request: GRDB.FetchRequest<Record>>(
    _ request: Request
  ) -> Self where Self == FetchAllQueryBuilderKey<Record, Request>.Default {
    Self[FetchAllQueryBuilderKey(request: request), default: []]
  }

  static func fetchOne<Value>(
    _ sql: String
  ) -> Self where Self == FetchOneKey<Value> {
    FetchOneKey(sql: sql)
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

struct FetchOneKey<Value: DatabaseValueConvertible & Sendable>: SharedReaderKey {
  let database: any DatabaseReader
  let sql: String

  init(sql: String) {
    @Dependency(\.defaultDatabase) var database
    self.database = database
    self.sql = sql
  }

  var id: ID {
    ID(
      databaseObjectIdentifier: ObjectIdentifier(database),
      sql: sql
    )
  }

  struct ID: Hashable {
    let databaseObjectIdentifier: ObjectIdentifier
    let sql: String
  }

  struct NotFound: Error {}

  func load(context: LoadContext<Value>, continuation: LoadContinuation<Value>) {
    do {
      let value = try database.read { db in
        try Value.fetchOne(db, sql: sql)
      }
      if let value {
        continuation.resume(returning: value)
      } else {
        continuation.resume(throwing: NotFound())
      }
    } catch {
      continuation.resume(throwing: error)
    }
  }

  func subscribe(
    context: LoadContext<Value>,
    subscriber: SharedSubscriber<Value>
  ) -> SharedSubscription {
    let cancellable = ValueObservation.tracking { db in
      if let value = try Value.fetchOne(db, sql: sql) {
        return value
      } else {
        throw NotFound()
      }
    }
      .start(in: database, scheduling: .async(onQueue: .main)) { error in
        subscriber.yield(throwing: error)
      } onChange: { elements in
        subscriber.yield(elements)
      }

    return SharedSubscription {
      cancellable.cancel()
    }
  }
}

struct FetchAllQueryBuilderKey<Record: FetchableRecord & Sendable, Request: GRDB.FetchRequest<Record> & Hashable>: SharedReaderKey {
  let database: any DatabaseReader
  let request: Request

  init(request: Request) {
    @Dependency(\.defaultDatabase) var database
    self.database = database
    self.request = request
  }

  struct ID: Hashable {
    let databaseObjectIdentifier: ObjectIdentifier
    let request: Request
  }

  var id: ID {
    ID(databaseObjectIdentifier: ObjectIdentifier(database), request: request)
  }

  func load(
    context: LoadContext<[Record]>,
    continuation: LoadContinuation<[Record]>
  ) {
    continuation.resume(
      with: Result {
        try database.read { db in
          try request.fetchAll(db)
        }
      }
    )
  }

  func subscribe(
    context: LoadContext<[Record]>,
    subscriber: SharedSubscriber<[Record]>
  ) -> SharedSubscription {
    let cancellable = ValueObservation.tracking { db in
      try request.fetchAll(db)
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

protocol FetchKeyRequest<Value>: Hashable, Sendable {
  associatedtype Value
  func fetch(_ db: Database) throws -> Value
}

struct FetchKey<Value: Sendable>: SharedReaderKey {
  let database: any DatabaseReader
  let request: any FetchKeyRequest<Value>

  init(request: some FetchKeyRequest<Value>) {
    @Dependency(\.defaultDatabase) var database
    self.database = database
    self.request = request
  }

  var id: ID {
    ID(
      databaseObjectIdentifier: ObjectIdentifier(database),
      request: request
    )
  }

  struct ID: Hashable {
    let databaseObjectIdentifier: ObjectIdentifier
    let request: AnyHashable
    init(databaseObjectIdentifier: ObjectIdentifier, request: some FetchKeyRequest<Value>) {
      self.databaseObjectIdentifier = databaseObjectIdentifier
      self.request = request
    }
  }

  func load(context: LoadContext<Value>, continuation: LoadContinuation<Value>) {
    do {
      continuation.resume(
        returning:
          try database.read { db in
            try request.fetch(db)
          }
      )
    } catch {
      continuation.resume(throwing: error)
    }
  }

  func subscribe(
    context: LoadContext<Value>,
    subscriber: SharedSubscriber<Value>
  ) -> SharedSubscription {
    let cancellable = ValueObservation.tracking { db in
      try request.fetch(db)
    }
      .start(in: database, scheduling: .async(onQueue: .main)) { error in
        subscriber.yield(throwing: error)
      } onChange: { value in
        subscriber.yield(value)
      }

    return SharedSubscription {
      cancellable.cancel()
    }
  }
}
