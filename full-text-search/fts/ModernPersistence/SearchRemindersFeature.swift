import SharingGRDB
import SwiftUI

@MainActor
@Observable
class SearchRemindersModel {
  @ObservationIgnored
  @FetchAll var reminders: [Reminder]
  var searchText = ""
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
