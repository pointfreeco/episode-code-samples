import Testing

@testable import QueryBuilder

@Suite struct QueryBuilderTests {
  @Test func basics() {
    #expect(
      Select(columns: ["id", "title"], from: "reminders").queryString == """
        SELECT id, title
        FROM reminders
        """
    )
  }

  @Test func emptyColumns() {
    #expect(
      Select(columns: [], from: "reminders").queryString == """
        SELECT *
        FROM reminders
        """
    )
  }

  @Test func selectWithColumns() {
    #expect(
      Reminder.select("id", "title", "priority").queryString == """
        SELECT id, title, priority
        FROM reminders
        """
    )
  }

  @Test func selectAll() {
    #expect(
      Reminder.all().queryString == """
        SELECT *
        FROM reminders
        """
    )
  }

  @Test func selectCount() {
    #expect(
      Tag.count().queryString == """
        SELECT count(*)
        FROM tags
        """
    )
  }
}

struct Reminder: Table {
  static let tableName = "reminders"

  let id: Int
  var title = ""
  var isCompleted = false
  var priority: Int?
}

struct Tag: Table {
  static let tableName = "tags"
}
