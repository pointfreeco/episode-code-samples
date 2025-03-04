import InlineSnapshotTesting
@testable import QueryBuilder

extension Snapshotting where Value: QueryExpression, Format == String {
  static var sql: Self {
    Snapshotting<String, String>.lines.pullback(\.queryString)
  }
}
