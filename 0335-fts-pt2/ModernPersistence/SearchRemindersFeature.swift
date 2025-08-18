import SharingGRDB
import SwiftUI

@MainActor
@Observable
class SearchRemindersModel {
//  @ObservationIgnored
//  @FetchAll var rows: [Row]
//
//  @ObservationIgnored
//  @FetchOne var completedCount = 0

  @ObservationIgnored
  @Fetch var searchResults = SearchRequest.Value()

  var searchText = "" {
    didSet {
      if oldValue != searchText {
        updateQuery()
      }
    }
  }
  var searchTask: Task<Void, any Error>?

  func updateQuery() {
    searchTask?.cancel()
    searchTask = Task {
      try await Task.sleep(for: .seconds(0.3))
      await withErrorReporting {
        try await $searchResults.load(
          SearchRequest(searchText: searchText),
          animation: .default
        )
      }
    }
  }

  @Selection
  struct Row {
    let color: Int
    let isPastDue: Bool
    let reminder: Reminder
    @Column(as: [String].JSONRepresentation.self)
    let tags: [String]
  }

  struct SearchRequest: FetchKeyRequest {
    struct Value {
      var completedCount = 0
      var rows: [Row] = []
    }
    let searchText: String
    func fetch(_ db: Database) throws -> Value {
      let query = Reminder
        .leftJoin(ReminderTag.all) { $0.id.eq($1.reminderID) }
        .leftJoin(Tag.all) { $1.tagID.eq($2.id) }
        .where { reminder, _, tag in
          for term in searchText.split(separator: " ") {
            reminder.title.contains(term)
            || reminder.notes.contains(term)
            || (tag.title ?? "").hasPrefix(term)
          }
        }

      return try Value(
        completedCount: query
          .where { reminder, _, _ in reminder.isCompleted }
          .select { reminder, _, _ in reminder.id.count(distinct: true) }
          .fetchOne(db) ?? 0,
        rows: query
          .group { reminder, _, _ in reminder.id }
          .join(RemindersList.all) { $0.remindersListID.eq($3.id) }
          .order { reminder, _, _, _ in
            reminder.isCompleted
          }
          .select { reminder, _, tag, remindersList in
            Row.Columns(
              color: remindersList.color,
              isPastDue: reminder.isPastDue,
              reminder: reminder,
              tags: tag.jsonTitles
            )
          }
          .fetchAll(db)
      )
    }
  }
}

struct SearchRemindersView: View {
  let model: SearchRemindersModel

  var body: some View {
    HStack {
      Text("\(model.searchResults.completedCount) Completed")
      Spacer()
      Button("Show completed") {

      }
    }
    ForEach(model.searchResults.rows, id: \.reminder.id) { row in
      ReminderRow(
        color: Color(hex: row.color),
        isPastDue: row.isPastDue,
        reminder: row.reminder,
        tags: row.tags,
        onDetailsTapped: {}
      )
    }
  }
}

struct SearchRemindersPreviews: PreviewProvider {
  static var previews: some View {
    Content()
  }

  struct Content: View {
    @Bindable var model: SearchRemindersModel
    init() {
      let _ = try! prepareDependencies {
        $0.defaultDatabase = try appDatabase()
      }
      model = SearchRemindersModel()
    }
    var body: some View {
      NavigationStack {
        List {
          if model.searchText.isEmpty {
            Text(#"Tap "Search"..."#)
          } else {
            SearchRemindersView(model: model)
          }
        }
        .searchable(text: $model.searchText)
      }
    }
  }
}
