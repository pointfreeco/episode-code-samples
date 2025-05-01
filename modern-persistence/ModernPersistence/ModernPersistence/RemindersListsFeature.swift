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
      }
  )
  var remindersListRows

  @Selection
  struct RemindersListRow {
    let incompleteRemindersCount: Int
    let remindersList: RemindersList
  }

  func deleteButtonTapped(indexSet: IndexSet) {
    withErrorReporting {
      try database.write { db in
        let ids = indexSet.map { remindersListRows[$0].remindersList.id }
        try RemindersList
          .where { $0.id.in(ids) }
          .delete()
          .execute(db)
      }
    }
  }
}

struct RemindersListsView: View {
  let model: RemindersListsModel

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
        }
        .onDelete { indexSet in
          model.deleteButtonTapped(indexSet: indexSet)
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
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Add list action@*//*@END_MENU_TOKEN@*/
          } label: {
            Text("Add List")
              .font(.title3)
          }
        }
      }
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
