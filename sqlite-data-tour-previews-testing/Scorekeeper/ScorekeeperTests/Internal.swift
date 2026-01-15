import Dependencies
import DependenciesTestSupport
import Testing

@testable import Scorekeeper

@Suite(
  .dependencies {
    $0.uuid = .incrementing
    try $0.bootstrapDatabase()
  }
)
struct BaseSuite {
}
