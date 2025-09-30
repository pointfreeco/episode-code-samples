import Foundation
import InlineSnapshotTesting
import SQLiteData
import Testing

@testable import ModernPersistence

@MainActor
@Suite(
  .dependency(\.date.now, Date(timeIntervalSince1970: 1234567890)),
  .dependency(\.defaultDatabase, try appDatabase()),
  .snapshots(record: .failed)
)
struct BaseTestSuite {
}
