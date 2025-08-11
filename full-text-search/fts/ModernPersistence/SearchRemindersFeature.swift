import SharingGRDB
import SwiftUI

@MainActor
@Observable
class SearchRemindersModel {
  @ObservationIgnored
  @FetchAll var rows: [Row]

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
        try await $rows.load(
          Reminder
            .group(by: \.id)
            .where {
              for term in searchText.split(separator: " ") {
                $0.title.contains(term)
                  || $0.notes.contains(term)
              }
            }
            .leftJoin(ReminderTag.all) { $0.id.eq($1.reminderID) }
            .leftJoin(Tag.all) { $1.tagID.eq($2.id) }
            .join(RemindersList.all) { $0.remindersListID.eq($3.id) }
            .select { reminder, _, tag, remindersList in
              Row.Columns(
                color: remindersList.color,
                isPastDue: reminder.isPastDue,
                reminder: reminder,
                tags: tag.jsonTitles
              )
            }
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
}

struct SearchRemindersView: View {
  let model: SearchRemindersModel

  var body: some View {
    ForEach(model.rows, id: \.reminder.id) { row in
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
