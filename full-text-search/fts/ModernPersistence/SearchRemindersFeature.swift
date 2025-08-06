import SharingGRDB
import SwiftUI

@MainActor
@Observable
class SearchRemindersModel {
  @ObservationIgnored
  @FetchAll(Reminder.none) var reminders: [Reminder]
  var searchText = "" {
    didSet {
      if oldValue != searchText {
        updateQuery()
      }
    }
  }
  var searchTask: Task<Void, Never>?

  func updateQuery() {
    searchTask?.cancel()
    searchTask = Task {
      await withErrorReporting {
        try await $reminders.load(
          Reminder.where {
            for term in searchText.split(separator: " ") {
              $0.title.contains(term)
              || $0.notes.contains(term)
            }
          }
        )
      }
    }
  }
}

struct SearchRemindersView: View {
  let model: SearchRemindersModel

  var body: some View {
    ForEach(model.reminders) { reminder in
      ReminderRow(
        color: .blue,
        isPastDue: false,
        reminder: reminder,
        tags: [],
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
