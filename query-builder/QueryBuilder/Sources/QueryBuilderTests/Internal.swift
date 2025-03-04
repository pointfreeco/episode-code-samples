import InlineSnapshotTesting
@testable import QueryBuilder

extension Snapshotting where Value == Select, Format == String {
  static var sql: Self {
    Snapshotting<String, String>.lines.pullback(\.queryString)
  }
}
