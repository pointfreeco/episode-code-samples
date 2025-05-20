import SharingGRDB
import SwiftUI

@MainActor
@Observable
class RemindersDetailModel {
  @ObservationIgnored
  @FetchAll var reminders: [Reminder]

  @ObservationIgnored
  @Shared var showCompleted: Bool

  @ObservationIgnored
  @Shared var ordering: Ordering

  let detailType: DetailType

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
    _reminders = FetchAll(
      remindersQuery
    )
  }

  var remindersQuery: some SelectStatementOf<Reminder> {
    Reminder
      .where {
        if !showCompleted {
          !$0.isCompleted
        }
      }
      .where {
        switch detailType {
        case .remindersList(let remindersList):
          $0.remindersListID.eq(remindersList.id)
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
  }

  func toggleShowCompletedButtonTapped() async {
    $showCompleted.withLock { $0.toggle() }
    await updateQuery()
  }

  func orderingButtonTapped(_ ordering: Ordering) async {
    $ordering.withLock { $0 = ordering }
    await updateQuery()
  }

  func updateQuery() async {
    await withErrorReporting {
      try await $reminders.load(remindersQuery, animation: .default)
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

enum DetailType {
  case remindersList(RemindersList)

  var navigationTitle: String {
    switch self {
    case .remindersList(let remindersList):
      remindersList.title
    }
  }
  var color: Color {
    switch self {
    case .remindersList(let remindersList):
      remindersList.color.swiftUIColor
    }
  }
  var appStorageKeySuffix: String {
    switch self {
    case .remindersList(let remindersList):
      "remindersList_\(remindersList.id)"
    }
  }
}

struct RemindersDetailView: View {
  @Bindable var model: RemindersDetailModel

  var body: some View {
    List {
      ForEach(model.reminders) { reminder in
        ReminderRow(
          color: model.detailType.color,
          isPastDue: /*@START_MENU_TOKEN@*/false/*@PLACEHOLDER=false@*//*@END_MENU_TOKEN@*/,
          reminder: reminder,
          tags: /*@START_MENU_TOKEN@*/["weekend", "fun"]/*@PLACEHOLDER=["weekend", "fun"]@*//*@END_MENU_TOKEN@*/
        ) {
          // Details button tapped in row
        }
      }
    }
    .navigationTitle(Text(model.detailType.navigationTitle))
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
          .tint(model.detailType.color)
        } label: {
          Image(systemName: "ellipsis.circle")
            .tint(model.detailType.color)
        }
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
