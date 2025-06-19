import IssueReporting
import SharingGRDB
import SwiftUI

struct ReminderFormView: View {
  @State var reminder: Reminder.Draft
  @FetchOne var selectedRemindersList = RemindersList.Draft()
  @FetchAll(RemindersList.order(by: \.title))
  var remindersLists: [RemindersList]

  @Dependency(\.defaultDatabase) var database
  @Environment(\.dismiss) var dismiss

  var body: some View {
    Form {
      TextField("Title", text: $reminder.title)
      TextEditor(text: $reminder.notes)
        .lineLimit(4)

      Section {
        Button {
          /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Tags action@*//*@END_MENU_TOKEN@*/
        } label: {
          HStack {
            Image(systemName: "number.square.fill")
              .font(.title)
              .foregroundStyle(.gray)
            Text("Tags")
              .foregroundStyle(Color(.label))
            Spacer()
              /*@START_MENU_TOKEN@*/Text("#weekend #fun")/*@PLACEHOLDER=Text("#weekend #fun")@*//*@END_MENU_TOKEN@*/
                .lineLimit(1)
                .truncationMode(.tail)
                .font(.callout)
                .foregroundStyle(.gray)
            Image(systemName: "chevron.right")
          }
        }
      }
      .popover(isPresented: /*@START_MENU_TOKEN@*/.constant(false)/*@PLACEHOLDER=.constant(false)@*//*@END_MENU_TOKEN@*/) {
        NavigationStack {
          Text("Tags")
        }
      }

      Section {
        Toggle(isOn: $reminder.dueDate.isNotNil) {
          HStack {
            Image(systemName: "calendar.circle.fill")
              .font(.title)
              .foregroundStyle(.red)
            Text("Date")
          }
        }
        if reminder.dueDate != nil {
          DatePicker(
            "",
            selection: $reminder.dueDate[coalesce: Date()],
            displayedComponents: [.date, .hourAndMinute]
          )
        }
      }

      Section {
        Toggle(isOn: $reminder.isFlagged) {
          HStack {
            Image(systemName: "flag.circle.fill")
              .font(.title)
              .foregroundStyle(.red)
            Text("Flag")
          }
        }
        Picker(selection: $reminder.priority) {
          Text("None").tag(Reminder.Priority?.none)
          Divider()
          Text("High").tag(Reminder.Priority.high)
          Text("Medium").tag(Reminder.Priority.medium)
          Text("Low").tag(Reminder.Priority.low)
        } label: {
          HStack {
            Image(systemName: "exclamationmark.circle.fill")
              .font(.title)
              .foregroundStyle(.red)
            Text("Priority")
          }
        }

        Picker(selection: $reminder.remindersListID) {
          ForEach(remindersLists) { remindersList in
            Text(remindersList.title)
              .tag(remindersList.id)
              .buttonStyle(.plain)
          }
        } label: {
          HStack {
            Image(systemName: "list.bullet.circle.fill")
              .font(.title)
              .foregroundStyle(selectedRemindersList.color.swiftUIColor)
            Text("List")
          }
        }
      } footer: {
        VStack {
          if let createdAt = reminder.createdAt {
            Text("Created: \(createdAt.formatted(date: .long, time: .shortened))")
          }
          if let updatedAt = reminder.updatedAt {
            Text("Updated: \(updatedAt.formatted(date: .long, time: .shortened))")
          }
        }
      }
    }
    .task(id: reminder.remindersListID) {
      await withErrorReporting {
        try await $selectedRemindersList.load(
          RemindersList.Draft
            .where { $0.id.eq(reminder.remindersListID) }
        )
      }
    }
    .toolbar {
      ToolbarItem {
        Button {
          withErrorReporting {
            try database.write { db in
              var reminder = reminder
              reminder.updatedAt = Date()
              try Reminder.upsert { reminder }.execute(db)
            }
          }
          dismiss()
        } label: {
          Text("Save")
        }
      }
      ToolbarItem(placement: .cancellationAction) {
        Button {
          dismiss()
        } label: {
          Text("Cancel")
        }
      }
    }
  }
}

extension Date? {
  var isNotNil: Bool {
    get { self != nil }
    set { self = newValue ? Date() : nil }
  }
}

extension Optional {
  fileprivate subscript(coalesce coalesce: Wrapped) -> Wrapped {
    get { self ?? coalesce }
    set { self = newValue }
  }
}

struct ReminderFormPreview: PreviewProvider {
  static var previews: some View {
    let _ = try! prepareDependencies {
      $0.defaultDatabase = try appDatabase()
    }
    NavigationStack {
      ReminderFormView(
        reminder: Reminder.Draft(
          createdAt: Date(),
          dueDate: Date(),
          isFlagged: true,
          notes: "* Milk\n* Eggs\n* Cheese",
          priority: .medium,
          remindersListID: 1,
          title: "Get groceries",
          updatedAt: Date()
        )
      )
        .navigationTitle("Reminder")
    }
  }
}
