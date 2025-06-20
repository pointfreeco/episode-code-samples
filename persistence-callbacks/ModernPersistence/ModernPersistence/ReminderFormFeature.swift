import IssueReporting
import SharingGRDB
import SwiftUI

struct ReminderFormView: View {
  @State var reminder: Reminder.Draft
  @FetchOne var selectedRemindersList = RemindersList.Draft()
  @FetchAll(RemindersList.order(by: \.title))
  var remindersLists: [RemindersList]

  @State var isTagsPickerPresented = false
  @State var selectedTags: [Tag] = []
  @Dependency(\.defaultDatabase) var database
  @Environment(\.dismiss) var dismiss

  var body: some View {
    Form {
      TextField("Title", text: $reminder.title)
      TextEditor(text: $reminder.notes)
        .lineLimit(4)

      Section {
        Button {
          isTagsPickerPresented = true
        } label: {
          HStack {
            Image(systemName: "number.square.fill")
              .font(.title)
              .foregroundStyle(.gray)
            Text("Tags")
              .foregroundStyle(Color(.label))
            Spacer()
            tagsDetail
                .lineLimit(1)
                .truncationMode(.tail)
                .font(.callout)
                .foregroundStyle(.gray)
            Image(systemName: "chevron.right")
          }
        }
      }
      .popover(isPresented: $isTagsPickerPresented) {
        NavigationStack {
          TagsView(selectedTags: $selectedTags)
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
    .task {
      await withErrorReporting {
        selectedTags = try await database.read { [reminderID = reminder.id] db in
          try Tag
            .order(by: \.title)
            .join(ReminderTag.all) { $0.id.eq($1.tagID) }
            .where { $1.reminderID.is(reminderID) }
            .select { tag, _ in tag }
            .fetchAll(db)
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
              let reminderID = try Reminder
                .upsert { reminder }
                .returning(\.id)
                .fetchOne(db)
              guard let reminderID
              else { return }

              let currentReminderTagIDs = try ReminderTag
                .where { $0.reminderID.is(reminder.id) }
                .select(\.tagID)
                .fetchAll(db)
              let selectedTagIDs = Set(selectedTags.map(\.id))
              let tagIDsToDelete = Set(currentReminderTagIDs).subtracting(selectedTagIDs)
              let tagIDsToInsert = selectedTagIDs.subtracting(currentReminderTagIDs)

              try ReminderTag
                .where { $0.reminderID.is(reminder.id) && $0.tagID.in(tagIDsToDelete) }
                .delete()
                .execute(db)

              try ReminderTag
                .insert {
                  tagIDsToInsert.map {
                    ReminderTag(
                      reminderID: reminderID,
                      tagID: $0
                    )
                  }
                }
                .execute(db)
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

  private var tagsDetail: Text {
    guard let tag = selectedTags.first else { return Text("") }
    return selectedTags.dropFirst().reduce(Text("#\(tag.title)")) { result, tag in
      result + Text(" #\(tag.title) ")
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
