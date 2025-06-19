import SharingGRDB
import SwiftUI

@MainActor
@Observable
class RemindersDetailModel {
  @ObservationIgnored
  @FetchAll var rows: [Row]

  @ObservationIgnored
  @Shared var showCompleted: Bool

  @ObservationIgnored
  @Shared var ordering: Ordering

  var reminderForm: Reminder.Draft?

  let detailType: DetailType

  @ObservationIgnored
  @Dependency(\.defaultDatabase) var database

  init(detailType: DetailType) {
    self.detailType = detailType
    _showCompleted = Shared(
      wrappedValue: false,
      .appStorage("showCompleted_\(detailType.appStorageKeySuffix)")
    )
    _ordering = Shared(
      wrappedValue: .dueDate,
      .appStorage("ordering_\(detailType.appStorageKeySuffix)")
    )
    _rows = FetchAll(query)
  }

  var query: some StructuredQueries.Statement<Row> {
    Reminder
      .group(by: \.id)
      .where {
        if detailType != .completed && !showCompleted {
          !$0.isCompleted
        }
      }
      .where {
        switch detailType {
        case .remindersList(let remindersList):
          $0.remindersListID.eq(remindersList.id)
        case .all:
          true
        case .completed:
          $0.isCompleted
        case .flagged:
          $0.isFlagged
        case .scheduled:
          $0.isScheduled
        case .today:
          $0.isToday
        }
      }
      .order { $0.isCompleted }
      .order {
        switch ordering {
        case .dueDate:
          $0.dueDate.asc(nulls: .last)
        case .priority:
          ($0.priority.desc(), $0.isFlagged.desc())
        case .title:
          $0.title
        }
      }
      .leftJoin(ReminderTag.all) { $0.id.eq($1.reminderID) }
      .leftJoin(Tag.all) { $1.tagID.eq($2.id) }
      .select {
        Row.Columns(
          isPastDue: $0.isPastDue,
          reminder: $0,
          tags: $2.jsonTitles
        )
      }
  }

  func toggleShowCompletedButtonTapped() async {
    $showCompleted.withLock { $0.toggle() }
    await updateQuery()
  }

  func orderingButtonTapped(_ ordering: Ordering) async {
    $ordering.withLock { $0 = ordering }
    await updateQuery()
  }

  func reminderDetailsButtonTapped(reminder: Reminder) {
    reminderForm = Reminder.Draft(reminder)
  }

  func newReminderButtonTapped() {
    switch detailType {
    case .remindersList(let remindersList):
      reminderForm = Reminder.Draft(remindersListID: remindersList.id)
    case .all:
      break
    case .completed:
      break
    case .flagged:
      break
    case .scheduled:
      break
    case .today:
      break
    }
  }

  func updateQuery() async {
    await withErrorReporting {
      try await $rows.load(query, animation: .default)
    }
  }

  @Selection
  struct Row {
    let isPastDue: Bool
    let reminder: Reminder
    @Column(as: [String].JSONRepresentation.self)
    let tags: [String]
  }
}

extension RemindersDetailModel: Hashable {
  nonisolated static func == (lhs: RemindersDetailModel, rhs: RemindersDetailModel) -> Bool {
    lhs === rhs
  }
  nonisolated func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
  }

  func flagAllRemindersButtonTapped() {
    withErrorReporting {
      try database.write { db in
        try Reminder
          .where { $0.id.in(rows.map(\.reminder.id)) }
          .update { $0.isFlagged = true }
          .execute(db)
      }
    }
  }
}

enum Ordering: String, CaseIterable {
  case dueDate = "Due Date"
  case priority = "Priority"
  case title = "Title"

  var icon: Image {
    switch self {
    case .dueDate: Image(systemName: "calendar")
    case .priority: Image(systemName: "chart.bar.fill")
    case .title: Image(systemName: "textformat.characters")
    }
  }
}

enum DetailType: Equatable {
  case all
  case completed
  case flagged
  case remindersList(RemindersList)
  case scheduled
  case today

  var navigationTitle: String {
    switch self {
    case .remindersList(let remindersList):
      remindersList.title
    case .all:
      "All"
    case .completed:
      "Completed"
    case .flagged:
      "Flagged"
    case .scheduled:
      "Scheduled"
    case .today:
      "Today"
    }
  }
  var color: Color {
    switch self {
    case .remindersList(let remindersList):
      remindersList.color.swiftUIColor
    case .all:
        .black
    case .completed:
        .gray
    case .flagged:
        .orange
    case .scheduled:
        .red
    case .today:
        .blue
    }
  }
  var appStorageKeySuffix: String {
    switch self {
    case .remindersList(let remindersList):
      "remindersList_\(remindersList.id)"
    case .all:
      "all"
    case .completed:
      "completed"
    case .flagged:
      "flagged"
    case .scheduled:
      "scheduled"
    case .today:
      "today"
    }
  }
}

struct RemindersDetailView: View {
  @Bindable var model: RemindersDetailModel

  var body: some View {
    List {
      ForEach(model.rows, id: \.reminder.id) { row in
        ReminderRow(
          color: model.detailType.color,
          isPastDue: row.isPastDue,
          reminder: row.reminder,
          tags: row.tags
        ) {
          model.reminderDetailsButtonTapped(reminder: row.reminder)
        }
      }
    }
    .navigationTitle(Text(model.detailType.navigationTitle))
    .listStyle(.plain)
    .toolbar {
      ToolbarItem(placement: .bottomBar) {
        HStack {
          Button {
            model.newReminderButtonTapped()
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
        .tint(model.detailType.color)
      }
      ToolbarItem(placement: .primaryAction) {
        Menu {
          Group {
            Menu {
              ForEach(Ordering.allCases, id: \.self) { ordering in
                Button {
                  Task {
                    await model.orderingButtonTapped(ordering)
                  }
                } label: {
                  Label {
                    Text(ordering.rawValue)
                  } icon: {
                    ordering.icon
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
            if model.detailType != .completed {
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
          }
          .tint(model.detailType.color)
          Button("Flag all reminders") {
            model.flagAllRemindersButtonTapped()
          }
        } label: {
          Image(systemName: "ellipsis.circle")
            .tint(model.detailType.color)
        }
      }
    }
    .sheet(item: $model.reminderForm) { reminderDraft in
      NavigationStack {
        ReminderFormView(reminder: reminderDraft)
          .navigationTitle(reminderDraft.id == nil ? "New reminder" : "Edit reminder")
      }
    }
  }
}

struct RemindersDetailPreview: PreviewProvider {
  static var previews: some View {
    let remindersList = try! prepareDependencies {
      $0.defaultDatabase = try appDatabase()
      return try $0.defaultDatabase.read { db in
        try RemindersList.find(1).fetchOne(db)!
      }
    }

    NavigationStack {
      RemindersDetailView(
        model: RemindersDetailModel(
          detailType: .remindersList(
            remindersList
          )
        )
      )
    }
  }
}
