import SharingGRDB
import SwiftUI

@Observable
class RemindersListsModel {
  @ObservationIgnored
  @Dependency(\.defaultDatabase) var database
  @ObservationIgnored
  @FetchAll(RemindersList.order(by: \.title)) var remindersLists

  func deleteButtonTapped(indexSet: IndexSet) {
    withErrorReporting {
      try database.write { db in
        let ids = indexSet.map { remindersLists[$0].id }
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
        ForEach(model.remindersLists) { remindersList in
          RemindersListRow(
            incompleteRemindersCount: 0,
            remindersList: remindersList
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
