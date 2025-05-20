import SharingGRDB
import SwiftUI

@MainActor
@Observable
class RemindersDetailModel {
  @ObservationIgnored
  @FetchAll var reminders: [Reminder]

  @ObservationIgnored
  @Shared(.appStorage("showCompleted"))
  var showCompleted = false

  init() {
    _reminders = FetchAll(
      remindersQuery
    )
  }

  var remindersQuery: some SelectStatementOf<Reminder> {
    Reminder.where {
      if !showCompleted {
        !$0.isCompleted
      }
    }
  }

  func toggleShowCompletedButtonTapped() async {
    $showCompleted.withLock { $0.toggle() }
    await updateQuery()
  }

  func updateQuery() async {
    await withErrorReporting {
      try await $reminders.load(remindersQuery, animation: .default)
    }
  }
}

struct RemindersDetailView: View {
  @Bindable var model: RemindersDetailModel

  var body: some View {
    List {
      ForEach(model.reminders) { reminder in
        ReminderRow(
          color: /*@START_MENU_TOKEN@*/Color.blue/*@PLACEHOLDER=Color.blue@*//*@END_MENU_TOKEN@*/,
          isPastDue: /*@START_MENU_TOKEN@*/false/*@PLACEHOLDER=false@*//*@END_MENU_TOKEN@*/,
          reminder: reminder,
          tags: /*@START_MENU_TOKEN@*/["weekend", "fun"]/*@PLACEHOLDER=["weekend", "fun"]@*//*@END_MENU_TOKEN@*/
        ) {
          // Details button tapped in row
        }
      }
    }
    .navigationTitle(Text(/*@START_MENU_TOKEN@*/"Reminders"/*@PLACEHOLDER=Reminders@*//*@END_MENU_TOKEN@*/))
    .listStyle(.plain)
    .toolbar {
      ToolbarItem(placement: .bottomBar) {
        HStack {
          Button {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=New reminder action@*//*@END_MENU_TOKEN@*/
          } label: {
            HStack {
              Image(systemName: "plus.circle.fill")
              Text("New Reminder")
            }
            .bold()
            .font(.title3)
          }
          Spacer()
        }
        .tint(/*@START_MENU_TOKEN@*/Color.blue/*@PLACEHOLDER=Color.blue@*//*@END_MENU_TOKEN@*/)
      }
      ToolbarItem(placement: .primaryAction) {
        Menu {
          Group {
            Menu {
              ForEach(/*@START_MENU_TOKEN@*/["Due Date", "Priority", "Title"]/*@PLACEHOLDER=["Due Date", "Priority", "Title"]@*//*@END_MENU_TOKEN@*/, id: \.self) { ordering in
                Button {
                  /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Order action@*//*@END_MENU_TOKEN@*/
                } label: {
                  Label {
                    Text(ordering)
                  } icon: {
                    /*@START_MENU_TOKEN@*/Image(systemName: "calendar")/*@PLACEHOLDER=Ordering icon@*//*@END_MENU_TOKEN@*/
                  }
                }
              }
            } label: {
              Text("Sort By")
              Label {
                Text(/*@START_MENU_TOKEN@*/"Due Date"/*@PLACEHOLDER=Current order@*//*@END_MENU_TOKEN@*/)
              } icon: {
                Image(systemName: "arrow.up.arrow.down")
              }
            }
            Button {
              Task {
                await model.toggleShowCompletedButtonTapped()
              }
            } label: {
              Label {
                Text(model.showCompleted ? "Hide Completed" : "Show Completed")
              } icon: {
                Image(systemName: model.showCompleted ? "eye.slash.fill" : "eye")
              }
            }
          }
          .tint(/*@START_MENU_TOKEN@*/Color.blue/*@PLACEHOLDER=Color.blue@*//*@END_MENU_TOKEN@*/)
        } label: {
          Image(systemName: "ellipsis.circle")
            .tint(/*@START_MENU_TOKEN@*/Color.blue/*@PLACEHOLDER=Color.blue@*//*@END_MENU_TOKEN@*/)
        }
      }
    }
  }
}

struct RemindersDetailPreview: PreviewProvider {
  static var previews: some View {
    let _ = prepareDependencies { $0.defaultDatabase = try! appDatabase() }

    NavigationStack {
      RemindersDetailView(model: RemindersDetailModel())
    }
  }
}
