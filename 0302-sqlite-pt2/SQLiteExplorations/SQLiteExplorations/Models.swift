import Foundation
import GRDB

struct Player: TableRecord, EncodableRecord, Encodable, MutablePersistableRecord {
  static let databaseTableName = "players"

  var id: Int64?
  var name = ""
  var createdAt: Date
  var isInjured = false

  mutating func didInsert(_ inserted: InsertionSuccess) {
    id = inserted.rowID
  }
}
