import InlineSnapshotTesting
import Testing

@testable import QueryBuilder

@MainActor
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

  //  @Test func selectWithKeyPaths() {
  //    assertInlineSnapshot(
  //      of: Reminder.select(\.id, \.title),
  //      as: .sql
  //    ) {
  //      """
  //      SELECT id, title
  //      FROM reminders
  //      """
  //    }
  //  }

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
      SELECT reminders.id, reminders.title, reminders.priority, reminders.isCompleted
      FROM reminders
      """
    }
  }

  @Test func selectCountColumn() {
    assertInlineSnapshot(
      of: Reminder.select { $0.id.count() },  // count(id)
      as: .sql
    ) {
      """
      SELECT count(reminders.id)
      FROM reminders
      """
    }
  }

  @Test func selectCountDistinctColumn() {
    assertInlineSnapshot(
      of: Reminder.select { $0.id.count(distinct: true) },  // count(DISTINCT id)
      as: .sql
    ) {
      """
      SELECT count(DISTINCT reminders.id)
      FROM reminders
      """
    }
  }

  @Test func selectAvg() {
    assertInlineSnapshot(
      of: Reminder.select { $0.priority.avg() },  // avg(priority)
      as: .sql
    ) {
      """
      SELECT avg(reminders.priority)
      FROM reminders
      """
    }
  }

  @Test func selectAvgAndCount() {
    assertInlineSnapshot(
      of: Reminder.select { ($0.priority.avg(), $0.id.count()) },  // avg(priority), count(id)
      as: .sql
    ) {
      """
      SELECT avg(reminders.priority), count(reminders.id)
      FROM reminders
      """
    }
  }

  @Test func selectGroupConcat() {
    assertInlineSnapshot(
      of: Reminder.select { $0.title.groupConcat() },  // group_concat(title)
      as: .sql
    ) {
      """
      SELECT group_concat(reminders.title)
      FROM reminders
      """
    }
  }

  @Test func selectGroupConcatWithSeparator() {
    assertInlineSnapshot(
      of: Reminder.select { $0.title.groupConcat(separator: " - ") },  // group_concat(title)
      as: .sql
    ) {
      """
      SELECT group_concat(reminders.title, ' - ')
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
      SELECT count(DISTINCT reminders.id), group_concat(reminders.title), avg(reminders.priority)
      FROM reminders
      """
    }
  }

  @Test func selectOrder() {
    assertInlineSnapshot(
      of: Reminder.all().order { $0.title },  // ORDER BY title
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      ORDER BY reminders.title
      """
    }
  }

  @Test func selectOrderByMultipleColumns() {
    assertInlineSnapshot(
      of: Reminder.all().order { ($0.priority, $0.title) },  // ORDER BY priority, title
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      ORDER BY reminders.priority, reminders.title
      """
    }
  }

  @Test func selectOrderByMultipleColumnsDesc() {
    assertInlineSnapshot(
      of: Reminder.all().order { ($0.priority.desc(), $0.title) },  // ORDER BY priority DESC, title
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      ORDER BY reminders.priority DESC, reminders.title
      """
    }
  }

  @Test func selectOrderByMultipleColumnsDescNullsFirst() {
    assertInlineSnapshot(
      of: Reminder.all().order {
        (
          $0.priority.desc(nulls: .first),
          $0.title
        )
      },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      ORDER BY reminders.priority DESC NULLS FIRST, reminders.title
      """
    }
  }

  @Test func selectWithMultipleOrders() {
    assertInlineSnapshot(
      of: Reminder.all()
        .order { $0.priority.desc(nulls: .first) }
        .order { $0.title }
        .order { $0.id },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      ORDER BY reminders.priority DESC NULLS FIRST, reminders.title, reminders.id
      """
    }
  }

  @Test func selectOrderByExpression() {
    assertInlineSnapshot(
      of: Reminder.all().order {
        ($0.title.length().desc(), $0.isCompleted.desc())
      },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      ORDER BY length(reminders.title) DESC, reminders.isCompleted DESC
      """
    }
  }

  @Test func selectOrderByExpressionCollation() {
    assertInlineSnapshot(
      of: Reminder.all().order { $0.title.collate(.nocase).desc() },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      ORDER BY reminders.title COLLATE NOCASE DESC
      """
    }
  }

  @Test func complexOrderBy() {
    let shouldSortByTitle = true
    assertInlineSnapshot(
      of: Reminder.all()
        .order {
          if shouldSortByTitle {
            $0.title.collate(.nocase).desc()
          }
        },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      ORDER BY reminders.title COLLATE NOCASE DESC
      """
    }
  }

  @Test func complexOrderByFalseCondition() {
    let shouldSortByTitle = false
    assertInlineSnapshot(
      of: Reminder.all()
        .order {
          if shouldSortByTitle {
            $0.title.collate(.nocase).desc()
          }
        },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      """
    }
  }

  @Test func orderByElseCondition() {
    let shouldSortByTitle = false
    assertInlineSnapshot(
      of: Reminder.all()
        .order {
          if shouldSortByTitle {
            ($0.title.collate(.nocase).desc(), $0.priority)
          } else {
            ($0.isCompleted, $0.id.desc())
          }
        },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      ORDER BY reminders.isCompleted, reminders.id DESC
      """
    }
  }

  @Test func orderBySwitch() {
    enum Order { case title, priority }
    let order = Order.title
    assertInlineSnapshot(
      of: Reminder.all()
        .order {
          switch order {
          case .title: ($0.title.collate(.nocase).desc(), $0.isCompleted)
          case .priority: $0.priority
          }
        },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      ORDER BY reminders.title COLLATE NOCASE DESC, reminders.isCompleted
      """
    }
  }

  @Test func whereClause() {
    assertInlineSnapshot(
      of: Reminder.all().where { $0.isCompleted },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      WHERE reminders.isCompleted
      """
    }
  }

  @Test func whereClauseNegate() {
    assertInlineSnapshot(
      of: Reminder.all().where { !$0.isCompleted },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      WHERE NOT (reminders.isCompleted)
      """
    }
  }

  @Test func whereHighPriority() {
    assertInlineSnapshot(
      of: Reminder.all().where { $0.priority == 3 },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      WHERE (reminders.priority = 3)
      """
    }
  }

  @Test func whereTitleLengthEqual3() {
    assertInlineSnapshot(
      of: Reminder.all().where { $0.title.length() == 3 },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      WHERE (length(reminders.title) = 3)
      """
    }
  }

  @Test func whereTitleLengthEqualPriority() {
    assertInlineSnapshot(
      of: Reminder.all().where { $0.title.length() == $0.priority },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      WHERE (length(reminders.title) = reminders.priority)
      """
    }
  }

  @Test func whereIncompleteOrHighPriority() {
    assertInlineSnapshot(
      of: Reminder.all().where { !$0.isCompleted || $0.priority == 3 },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      WHERE (NOT (reminders.isCompleted) OR (reminders.priority = 3))
      """
    }
  }

  @Test func whereIncompleteAndHighPriority() {
    assertInlineSnapshot(
      of: Reminder.all().where { !$0.isCompleted && $0.priority == 3 },
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      WHERE (NOT (reminders.isCompleted) AND (reminders.priority = 3))
      """
    }
  }

  @Test func nonsense() {
    //Reminder.init(id: 0, title: "0")
    //    assertInlineSnapshot(
    //      of: Reminder.all().where { $0.title },
    //      as: .sql
    //    ) {
    //      """
    //      SELECT *
    //      FROM reminders
    //      WHERE title
    //      """
    //    }
    //    assertInlineSnapshot(
    //      of: Reminder.all().where { $0.title == 3 },
    //      as: .sql
    //    ) {
    //      """
    //      SELECT *
    //      FROM reminders
    //      WHERE (title = 3)
    //      """
    //    }
    //    assertInlineSnapshot(
    //      of: Reminder.all().where { $0.title == $0.priority },
    //      as: .sql
    //    ) {
    //      """
    //      SELECT *
    //      FROM reminders
    //      WHERE (title = priority)
    //      """
    //    }
    //    Reminder.all().where { $0.priority.length() == 3 }
    //    Reminder.all().where { $0.title && $0.priority }
  }

  @Test func selectRemindersLists() {
    assertInlineSnapshot(of: RemindersList.all(), as: .sql) {
      """
      SELECT *
      FROM remindersLists
      """
    }
  }

  @Test func join() {
    assertInlineSnapshot(
      of:
        RemindersList
        .all()
        .join(Reminder.self) { $0.id == $1.remindersListID },
      as: .sql
    ) {
      """
      SELECT *
      FROM remindersLists
      JOIN reminders
      ON (remindersLists.id = reminders.remindersListID)
      """
    }
  }

  @Test func joinWhere() {
    assertInlineSnapshot(
      of:
        RemindersList
        .all()
        .join(Reminder.self) { $0.id == $1.remindersListID }
        .where { !$1.isCompleted },
      as: .sql
    ) {
      """
      SELECT *
      FROM remindersLists
      JOIN reminders
      ON (remindersLists.id = reminders.remindersListID)
      WHERE NOT (reminders.isCompleted)
      """
    }
  }

  @Test func joinOrder() {
    assertInlineSnapshot(
      of:
        RemindersList
        .all()
        .join(Reminder.self) { $0.id == $1.remindersListID }
        .order { ($0.title, $1.priority.desc()) },
      as: .sql
    ) {
      """
      SELECT *
      FROM remindersLists
      JOIN reminders
      ON (remindersLists.id = reminders.remindersListID)
      ORDER BY remindersLists.title, reminders.priority DESC
      """
    }
  }

  @Test func joinSelect() {
    assertInlineSnapshot(
      of:
        RemindersList
        .all()
        .join(Reminder.self) { $0.id == $1.remindersListID }
        .select { ($0.title, $1.title) },
      as: .sql
    ) {
      """
      SELECT remindersLists.title, reminders.title
      FROM remindersLists
      JOIN reminders
      ON (remindersLists.id = reminders.remindersListID)
      """
    }
  }

  @Test func joinSelectWhereOrder() {
    assertInlineSnapshot(
      of:
        RemindersList
        .all()
        .join(Reminder.self) { $0.id == $1.remindersListID }
        .select { ($0.title, $1.title) }
        .where { !$1.isCompleted }
        .order { ($0.title, $1.priority.desc()) },
      as: .sql
    ) {
      """
      SELECT remindersLists.title, reminders.title
      FROM remindersLists
      JOIN reminders
      ON (remindersLists.id = reminders.remindersListID)
      WHERE NOT (reminders.isCompleted)
      ORDER BY remindersLists.title, reminders.priority DESC
      """
    }
  }

  @Test func joinAggregate() {
    assertInlineSnapshot(
      of:
        RemindersList
        .all()
        .group(by: \.id)
        .join(Reminder.self) { $0.id == $1.remindersListID }
        .select { ($0.title, $1.title.groupConcat()) },
      as: .sql
    ) {
      """
      SELECT remindersLists.title, group_concat(reminders.title)
      FROM remindersLists
      JOIN reminders
      ON (remindersLists.id = reminders.remindersListID)
      GROUP BY remindersLists.id
      """
    }
  }

  @Test func joinAggregateCount() {
    assertInlineSnapshot(
      of:
        RemindersList
        .all()
        .group(by: \.id)
        .join(Reminder.self) { $0.id == $1.remindersListID }
        .select { ($0.title, $1.id.count()) },
      as: .sql
    ) {
      """
      SELECT remindersLists.title, count(reminders.id)
      FROM remindersLists
      JOIN reminders
      ON (remindersLists.id = reminders.remindersListID)
      GROUP BY remindersLists.id
      """
    }
  }
}

struct Reminder: Table {
  // -----
  struct Columns {
    let id = Column<Int>(name: "id", table: Reminder.tableName)
    let title = Column<String>(name: "title", table: Reminder.tableName)
    let isCompleted = Column<Bool>(
      name: "isCompleted", table: Reminder.tableName)
    let priority = Column<Int?>(name: "priority", table: Reminder.tableName)
    let remindersListID = Column<RemindersList.ID>(
      name: "remindersListID", table: Reminder.tableName)
  }
  static let columns = Columns()
  static let tableName = "reminders"
  // -----

  let id: Int  // Tagged<Self, Int>
  var title = ""
  var isCompleted = false
  var priority: Int?
  var remindersListID: RemindersList.ID

  var titleIsLong: Bool { title.count >= 100 }
}

//@Table
struct RemindersList: Identifiable, Table {
  // -----
  struct Columns {
    let id = Column<Int>(name: "id", table: RemindersList.tableName)
    let title = Column<String>(name: "title", table: RemindersList.tableName)
  }
  static let columns = Columns()
  static let tableName = "remindersLists"
  // -----
  let id: Int  // Tagged<Self, Int>
  var title = ""
}

struct Tag: Table {
  struct Columns {}
  static let columns = Columns()

  static let tableName = "tags"
}
