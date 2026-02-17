import Dependencies
import DependenciesTestSupport
import SQLiteData
import Testing

@testable import Scorekeeper

@Suite(
  .dependencies {
    $0.uuid = .incrementing
    try $0.bootstrapDatabase()
    try await $0.defaultSyncEngine.start()
  }
)
struct BaseSuite {
}
