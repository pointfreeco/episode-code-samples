import SharingGRDB
import SwiftUI

@MainActor
@Observable
class SearchRemindersModel {
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
    let formattedNotes: String
    let formattedTitle: String
    let isPastDue: Bool
    let reminder: Reminder
    let tags: String
  }

  struct SearchRequest: FetchKeyRequest {
    struct Value {
      var completedCount = 0
      var rows: [Row] = []
    }
    let searchText: String
    func fetch(_ db: Database) throws -> Value {
      let query = Reminder
        .join(ReminderText.all) { $0.id.eq($1.reminderID) }
        .where { reminder, reminderText in
          reminderText.match(searchText.quoted())
        }

      return try Value(
        completedCount: query
          .where { reminder, _ in reminder.isCompleted }
          .select { reminder, _ in reminder.id.count(distinct: true) }
          .fetchOne(db) ?? 0,
        rows: query
          .join(RemindersList.all) { $0.remindersListID.eq($2.id) }
          .order { reminder, reminderText, _ in
            (
              reminder.isCompleted,
              reminderText.rank
            )
          }
          .select { reminder, reminderText, remindersList in
            Row.Columns(
              color: remindersList.color,
              formattedNotes: reminderText.notes.snippet("**", "**", "...", 64),
              formattedTitle: reminderText.title.highlight("**", "**"),
              isPastDue: reminder.isPastDue,
              reminder: reminder,
              tags: reminderText.tags.highlight("**", "**")
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
        formattedNotes: row.formattedNotes,
        formattedTitle: row.formattedTitle,
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

extension String {
  fileprivate func quoted() -> String {
    split(separator: " ").map {
      """
      "\($0)"
      """
    }
    .joined(separator: " ")
  }
}
