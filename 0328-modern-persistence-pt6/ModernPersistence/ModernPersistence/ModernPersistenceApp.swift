import SwiftData
import SwiftUI

@main
struct ModernPersistenceApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([RemindersListModel.self, ReminderModel.self])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    return try! ModelContainer(for: schema, configurations: [modelConfiguration])
  }()

  var body: some Scene {
    WindowGroup {
      InnerView()
    }
    .modelContainer(sharedModelContainer)
  }
}

struct InnerView: View {
  @Query var reminders: [ReminderModel]
  init() {
    _reminders = remindersQuery(
      showCompleted: true,
      detailType: .remindersList(RemindersListModel()),
      ordering: .priority
    )
  }
  var body: some View {
    Form {
      ForEach(reminders) { _ in }
    }
  }
}
