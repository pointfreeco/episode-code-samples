import SharingGRDB
import SwiftUI

@Observable
class RemindersListsModel {
  @ObservationIgnored
  @Dependency(\.defaultDatabase) var database
  @ObservationIgnored
  @FetchAll(
    RemindersList
      .group(by: \.id)
      .order(by: \.title)
      .leftJoin(Reminder.all) {
        $0.id.eq($1.remindersListID) && !$1.isCompleted
      }
      .select {
        RemindersListRow.Columns(
          incompleteRemindersCount: $1.count(),
          remindersList: $0
        )
      },
    animation: .default
  )
  var remindersListRows

  var remindersListForm: RemindersList.Draft?

  @Selection
  struct RemindersListRow {
    let incompleteRemindersCount: Int
    let remindersList: RemindersList
  }

  func deleteButtonTapped(remindersList: RemindersList) {
    withErrorReporting {
      try database.write { db in
        try RemindersList
          .delete(remindersList)
          .execute(db)
      }
    }
  }

  func addListButtonTapped() {
    remindersListForm = RemindersList.Draft()
  }

  func editButtonTapped(remindersList: RemindersList) {
    remindersListForm = RemindersList.Draft(remindersList)
  }
}

struct RemindersListsView: View {
  @Bindable var model: RemindersListsModel

  var body: some View {
    List {
      Section {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Top-level stats@*//*@END_MENU_TOKEN@*/
      }

      Section {
        ForEach(model.remindersListRows, id: \.remindersList.id) { row in
          RemindersListRow(
            incompleteRemindersCount: row.incompleteRemindersCount,
            remindersList: row.remindersList
          )
          .swipeActions {
            Button(role: .destructive) {
              model.deleteButtonTapped(remindersList: row.remindersList)
            } label: {
              Image(systemName: "trash")
            }
            Button {
              model.editButtonTapped(remindersList: row.remindersList)
            } label: {
              Image(systemName: "info.circle")
            }
          }
        }
      } header: {
        Text("My lists")
          .font(.largeTitle)
          .bold()
          .foregroundStyle(.black)
          .textCase(nil)
      }

      Section {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Tags@*//*@END_MENU_TOKEN@*/
      } header: {
        Text("Tags")
          .font(.largeTitle)
          .bold()
          .foregroundStyle(.black)
          .textCase(nil)
      }
    }
    .searchable(text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Search text@*/.constant("")/*@END_MENU_TOKEN@*/)
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
          Button {
            model.addListButtonTapped()
          } label: {
            Text("Add List")
              .font(.title3)
          }
        }
      }
    }
    .sheet(item: $model.remindersListForm) { remindersList in
      NavigationStack {
        RemindersListForm(remindersList: remindersList)
          .navigationTitle("New List")
      }
      .presentationDetents([.medium])
    }
  }
}

#Preview {
  let _ = prepareDependencies {
    $0.defaultDatabase = try! appDatabase()
  }
  NavigationStack {
    RemindersListsView(model: RemindersListsModel())
  }
}
