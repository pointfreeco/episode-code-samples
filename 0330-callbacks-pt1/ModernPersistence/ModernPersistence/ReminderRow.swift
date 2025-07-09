import SharingGRDB
import SwiftUI

struct ReminderRow: View {
  let color: Color
  let isPastDue: Bool
  let reminder: Reminder
  let tags: [String]
  let onDetailsTapped: () -> Void

  @Dependency(\.defaultDatabase) var database

  var body: some View {
    HStack {
      HStack(alignment: .firstTextBaseline) {
        Button {
          withErrorReporting {
            try database.write { db in
              try Reminder
                .find(reminder.id)
                .update {
                  $0.isCompleted.toggle()
                  //$0.updatedAt = Date()
                }
                .execute(db)
            }
          }
        } label: {
          Image(systemName: reminder.isCompleted ? "circle.inset.filled" : "circle")
            .foregroundStyle(.gray)
            .font(.title2)
            .padding([.trailing], 5)
        }
        VStack(alignment: .leading) {
          HStack(alignment: .firstTextBaseline) {
            if let priority = reminder.priority {
              Text(String(repeating: "!", count: priority.rawValue))
                .foregroundStyle(reminder.isCompleted ? .gray : color)
            }
            Text(reminder.title)
              .foregroundStyle(reminder.isCompleted ? .gray : .primary)
          }
          .font(.title3)

          if !reminder.notes.isEmpty {
            Text(reminder.notes.replacingOccurrences(of: "\n", with: " "))
              .font(.subheadline)
              .foregroundStyle(.gray)
              .lineLimit(2)
          }
          subtitleText
        }
      }
      Spacer()
      if !reminder.isCompleted {
        HStack {
          if reminder.isFlagged {
            Image(systemName: "flag.fill")
              .foregroundStyle(.orange)
          }
          Button {
            onDetailsTapped()
          } label: {
            Image(systemName: "info.circle")
          }
          .tint(color)
        }
      }
    }
    .buttonStyle(.borderless)
    .swipeActions {
      Button("Delete", role: .destructive) {
        withErrorReporting {
          try database.write { db in
            try Reminder
              .find(reminder.id)
              .delete()
              .execute(db)
          }
        }
      }
      Button(reminder.isFlagged ? "Unflag" : "Flag") {
        withErrorReporting {
          try database.write { db in
            try Reminder
              .find(reminder.id)
              .update {
                $0.isFlagged.toggle()
                //$0.updatedAt = Date()
              }
              .execute(db)
          }
        }
      }
      .tint(.orange)
      Button("Details") {
        onDetailsTapped()
      }
    }
  }

  private var dueText: Text {
    if let date = reminder.dueDate {
      Text(date.formatted(date: .numeric, time: .shortened))
        .foregroundStyle(isPastDue ? .red : .gray)
    } else {
      Text("")
    }
  }

  private var subtitleText: Text {
    let tagsText = tags.reduce(Text("")) { result, tag in
      result + Text(" #\(tag)")
    }
    return
      (dueText
      + tagsText.foregroundStyle(.gray)
      .bold())
      .font(.callout)
  }
}

struct ReminderRowPreview: PreviewProvider {
  static var previews: some View {
    let _ = prepareDependencies {
      $0.defaultDatabase = try! appDatabase()
    }
    Inner()
  }
  struct Inner: View {
    @FetchAll(Reminder.order(by: \.isCompleted), animation: .default)
    var reminders: [Reminder]
    var body: some View {
      NavigationStack {
        List {
          ForEach(reminders) { reminder in
            ReminderRow(
              color: .blue,
              isPastDue: false,
              reminder: reminder,
              tags: ["weekend", "fun"]
            ) {
              // No-op
            }
          }
        }
      }
    }
  }
}
