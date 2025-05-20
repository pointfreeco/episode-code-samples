import CustomDump
import DependenciesTestSupport
import InlineSnapshotTesting
import SnapshotTestingCustomDump
import Testing

@testable import ModernPersistence

@Suite(
  .dependency(\.defaultDatabase, try appDatabase()),
  .snapshots(record: .failed)
)
struct RemindersListsFeatureTests {
  @Test func deletion() async throws {
    let model = RemindersListsModel()
    try await model.$remindersLists.load()
    assertInlineSnapshot(of: model.remindersLists, as: .customDump) {
      """
      [
        [0]: RemindersList(
          id: 1,
          color: 1251602431,
          title: "Personal"
        ),
        [1]: RemindersList(
          id: 2,
          color: 4018031359,
          title: "Family"
        ),
        [2]: RemindersList(
          id: 3,
          color: 2128628479,
          title: "Business"
        )
      ]
      """
    }

    model.deleteButtonTapped(indexSet: [0, 2])
    try await model.$remindersLists.load()
    assertInlineSnapshot(of: model.remindersLists, as: .customDump) {
      """
      [
        [0]: RemindersList(
          id: 2,
          color: 4018031359,
          title: "Family"
        )
      ]
      """
    }
  }
}
