import InlineSnapshotTesting
import Testing

@testable import QueryBuilder

@Suite(.snapshots(record: .failed)) struct QueryBuilderTests {
  @Test func selectWithColumns() {
    assertInlineSnapshot(
      of: Reminder.select("id", "title", "priority"),
      as: .sql
    ) {
      """
      SELECT id, title, priority
      FROM reminders
      """
    }
  }

  @Test func selectAll() {
    assertInlineSnapshot(
      of: Reminder.all(),
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      """
    }
  }

  @Test func selectCount() {
    assertInlineSnapshot(
      of: Tag.count(),
      as: .sql
    ) {
      """
      SELECT count(*)
      FROM tags
      """
    }
  }

  @Test func selectWithKeyPaths() {
    assertInlineSnapshot(
      of: Reminder.select(\.id, \.title),
      as: .sql
    ) {
      """
      SELECT id, title
      FROM reminders
      """
    }
  }

  @Test func fancySelect() {
    assertInlineSnapshot(
      of: Reminder.select {
        ($0.id, $0.title, $0.priority, $0.isCompleted)
      },
      //        (
      //          $0.id.count(distinct: true),
      //          $0.title.groupConcat(),
      //          $0.priority.avg()
      //        )
      as: .sql
    ) {
      """
      SELECT id, title, priority, isCompleted
      FROM reminders
      """
    }
  }

  @Test func selectCountColumn() {
    assertInlineSnapshot(
      of: Reminder.select { $0.id.count() }, // count(id)
      as: .sql
    ) {
      """
      SELECT count(id)
      FROM reminders
      """
    }
  }

  @Test func selectCountDistinctColumn() {
    assertInlineSnapshot(
      of: Reminder.select { $0.id.count(distinct: true) }, // count(DISTINCT id)
      as: .sql
    ) {
      """
      SELECT count(DISTINCT id)
      FROM reminders
      """
    }
  }

  @Test func selectAvg() {
    assertInlineSnapshot(
      of: Reminder.select { $0.priority.avg() }, // avg(priority)
      as: .sql
    ) {
      """
      SELECT avg(priority)
      FROM reminders
      """
    }
  }

  @Test func selectAvgAndCount() {
    assertInlineSnapshot(
      of: Reminder.select { ($0.priority.avg(), $0.id.count()) }, // avg(priority), count(id)
      as: .sql
    ) {
      """
      SELECT avg(priority), count(id)
      FROM reminders
      """
    }
  }

  @Test func selectGroupConcat() {
    assertInlineSnapshot(
      of: Reminder.select { $0.title.groupConcat() }, // group_concat(title)
      as: .sql
    ) {
      """
      SELECT group_concat(title)
      FROM reminders
      """
    }
  }

  @Test func selectGroupConcatWithSeparator() {
    assertInlineSnapshot(
      of: Reminder.select { $0.title.groupConcat(separator: " - ") }, // group_concat(title)
      as: .sql
    ) {
      """
      SELECT group_concat(title, ' - ')
      FROM reminders
      """
    }
  }

  @Test func selectAdvanced() {
    assertInlineSnapshot(
      of: Reminder.select {
        (
          $0.id.count(distinct: true),
          $0.title.groupConcat(),
          $0.priority.avg()
        )
      },
      as: .sql
    ) {
      """
      SELECT count(DISTINCT id), group_concat(title), avg(priority)
      FROM reminders
      """
    }
  }

  @Test func selectOrder() {
    assertInlineSnapshot(
      of: Reminder.all().order { $0.title }, // ORDER BY title
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      ORDER BY title
      """
    }
  }

  @Test func selectOrderByMultipleColumns() {
    assertInlineSnapshot(
      of: Reminder.all().order { ($0.priority, $0.title) }, // ORDER BY priority, title
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      ORDER BY priority, title
      """
    }
  }

//  @Test func selectOrderByMultipleColumnsDesc() {
//    assertInlineSnapshot(
//      of: Reminder.all().order { ($0.priority.desc(), $0.title) }, // ORDER BY priority DESC, title
//      as: .sql
//    )
//  }
//
//  @Test func selectOrderByMultipleColumnsDescNullsFirst() {
//    assertInlineSnapshot(
//      of: Reminder.all().order { ($0.priority.desc(nulls: .first), $0.title) }, // ORDER BY priority DESC NULLS FIRST, title
//      as: .sql
//    )
//  }
//
//  @Test func selectOrderByExpression() {
//    assertInlineSnapshot(
//      of: Reminder.all().order { ($0.title.length(), $0.isCompleted.desc()) }, // ORDER BY length(title), isCompleted DESC
//      as: .sql
//    )
//  }
}

struct Reminder: Table {
  // -----
  struct Columns {
    let id = Column(name: "id")
    let title = Column(name: "title")
    let isCompleted = Column(name: "isCompleted")
    let priority = Column(name: "priority")
  }
  static let columns = Columns()
  static let tableName = "reminders"
  // -----

  let id: Int
  var title = ""
  var isCompleted = false
  var priority: Int?

  var titleIsLong: Bool { title.count >= 100 }
}

struct Tag: Table {
  struct Columns {}
  static let columns = Columns()

  static let tableName = "tags"
}
