import SharingGRDB
import SwiftUI

@MainActor
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

  @ObservationIgnored
  @FetchOne(
    Reminder.select {
      Stats.Columns(
        allCount: $0.count(filter: !$0.isCompleted),
        flaggedCount: $0.count(filter: !$0.isCompleted && $0.isFlagged),
        scheduledCount: $0.count(filter: !$0.isCompleted && $0.dueDate.isNot(nil)),
        todayCount: $0.count(filter: !$0.isCompleted && #sql("date(\($0.dueDate)) = date()"))
      )
    }
  )
  var stats = Stats()

  @Selection
  struct Stats {
    var allCount = 0
    var flaggedCount = 0
    var scheduledCount = 0
    var todayCount = 0
  }

  var remindersListForm: RemindersList.Draft?

  var remindersDetail: RemindersDetailModel?

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

  func remindersListTapped(remindersList: RemindersList) {
    remindersDetail = RemindersDetailModel(
      detailType: .remindersList(remindersList)
    )
  }
}

struct RemindersListsView: View {
  @Bindable var model: RemindersListsModel

  var body: some View {
    List {
      Section {
        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 16) {
          GridRow {
            ReminderGridCell(
              color: .blue,
              count: model.stats.todayCount,
              iconName: "calendar.circle.fill",
              title: "Today"
            ) {
              /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*//*@END_MENU_TOKEN@*/
            }
            ReminderGridCell(
              color: .red,
              count: model.stats.scheduledCount,
              iconName: "calendar.circle.fill",
              title: "Scheduled"
            ) {
              /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*//*@END_MENU_TOKEN@*/
            }
          }
          GridRow {
            ReminderGridCell(
              color: .gray,
              count: model.stats.allCount,
              iconName: "tray.circle.fill",
              title: "All"
            ) {
              /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*//*@END_MENU_TOKEN@*/
            }
            ReminderGridCell(
              color: .orange,
              count: model.stats.flaggedCount,
              iconName: "flag.circle.fill",
              title: "Flagged"
            ) {
              /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*//*@END_MENU_TOKEN@*/
            }
          }
          GridRow {
            ReminderGridCell(
              color: .gray,
              count: nil,
              iconName: "checkmark.circle.fill",
              title: "Completed"
            ) {
              /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*//*@END_MENU_TOKEN@*/
            }
          }
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.clear)
        .padding([.leading, .trailing], -20)
      }

      Section {
        ForEach(model.remindersListRows, id: \.remindersList.id) { row in
          Button {
            model.remindersListTapped(remindersList: row.remindersList)
          } label: {
            RemindersListRow(
              incompleteRemindersCount: row.incompleteRemindersCount,
              remindersList: row.remindersList
            )
            .foregroundColor(.primary)
          }
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
    .searchable(
      text: /*@START_MENU_TOKEN@*/ /*@PLACEHOLDER=Search text@*/.constant("")/*@END_MENU_TOKEN@*/
    )
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
    .navigationDestination(item: $model.remindersDetail) { remindersDetail in
      RemindersDetailView(model: remindersDetail)
    }
  }
}

private struct ReminderGridCell: View {
  let color: Color
  let count: Int?
  let iconName: String
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(alignment: .firstTextBaseline) {
        VStack(alignment: .leading, spacing: 8) {
          Image(systemName: iconName)
            .font(.largeTitle)
            .bold()
            .foregroundStyle(color)
            .background(
              Color.white.clipShape(Circle()).padding(4)
            )
          Text(title)
            .font(.headline)
            .foregroundStyle(.gray)
            .bold()
            .padding(.leading, 4)
        }
        Spacer()
        if let count {
          Text("\(count)")
            .font(.largeTitle)
            .fontDesign(.rounded)
            .bold()
            .foregroundStyle(Color(.label))
        }
      }
      .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
      .background(Color(.secondarySystemGroupedBackground))
      .cornerRadius(10)
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
