import DependenciesTestSupport
import Testing

@testable import ModernPersistence

@Suite(.dependency(\.defaultDatabase, try appDatabase()))
struct RemindersListsFeatureTests {
  @Test func deletion() async throws {
    let model = RemindersListsModel()
    try await model.$remindersLists.load()
    #expect(model.remindersLists.map(\.id) == [3, 2, 1])

    model.deleteButtonTapped(indexSet: [0, 2])
    try await model.$remindersLists.load()

    #expect(model.remindersLists.map(\.id) == [2])
  }
}
