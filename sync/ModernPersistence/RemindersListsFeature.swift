import SQLiteData
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
      .order(by: \.position)
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
        scheduledCount: $0.count(filter: !$0.isCompleted && $0.isScheduled),
        todayCount: $0.count(filter: !$0.isCompleted && $0.isToday)
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
  let searchRemindersModel = SearchRemindersModel()

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

  func detailTapped(detailType: DetailType) {
    remindersDetail = RemindersDetailModel(detailType: detailType)
  }

  func editButtonTapped(remindersList: RemindersList) {
    remindersListForm = RemindersList.Draft(remindersList)
  }

  func moveRemindersList(fromOffsets source: IndexSet, toOffset destination: Int) {
    var remindersListIDs = remindersListRows.map(\.remindersList.id)
    remindersListIDs.move(fromOffsets: source, toOffset: destination)
    withErrorReporting {
      try database.write { db in
        for (offset, remindersListID) in remindersListIDs.enumerated() {
          try RemindersList
            .find(remindersListID)
            .update { $0.position = offset }
            .execute(db)
        }
      }
    }
  }
}

struct RemindersListsView: View {
  @Bindable var model: RemindersListsModel

  var body: some View {
    @Bindable var searchRemindersModel = model.searchRemindersModel

    List {
      if !model.searchRemindersModel.isSearching {
        Section {
          Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 16) {
            GridRow {
              ReminderGridCell(
                color: .blue,
                count: model.stats.todayCount,
                iconName: "calendar.circle.fill",
                title: "Today"
              ) {
                model.detailTapped(detailType: .today)
              }
              ReminderGridCell(
                color: .red,
                count: model.stats.scheduledCount,
                iconName: "calendar.circle.fill",
                title: "Scheduled"
              ) {
                model.detailTapped(detailType: .scheduled)
              }
            }
            GridRow {
              ReminderGridCell(
                color: .gray,
                count: model.stats.allCount,
                iconName: "tray.circle.fill",
                title: "All"
              ) {
                model.detailTapped(detailType: .all)
              }
              ReminderGridCell(
                color: .orange,
                count: model.stats.flaggedCount,
                iconName: "flag.circle.fill",
                title: "Flagged"
              ) {
                model.detailTapped(detailType: .flagged)
              }
            }
            GridRow {
              ReminderGridCell(
                color: .gray,
                count: nil,
                iconName: "checkmark.circle.fill",
                title: "Completed"
              ) {
                model.detailTapped(detailType: .completed)
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
              model.detailTapped(detailType: .remindersList(row.remindersList))
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
          .onMove { source, destination in
            model.moveRemindersList(fromOffsets: source, toOffset: destination)
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
      } else {
        SearchRemindersView(model: model.searchRemindersModel)
          .id(model.searchRemindersModel.searchText)
      }
    }
    .searchable(
      text: $searchRemindersModel.searchText,
      tokens: $searchRemindersModel.searchTokens
    ) { token in
      switch token.kind {
      case .tag:
        Text("#\(token.value)")
      case .near:
        Text(token.value)
      }
    }
    .toolbar {
#if DEBUG
      ToolbarItem(placement: .primaryAction) {
        Button("Seed") {
          @Dependency(\.defaultDatabase) var database
          try! database.write { db in
            try seedDatabase(db)
          }
        }
      }
#endif
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
