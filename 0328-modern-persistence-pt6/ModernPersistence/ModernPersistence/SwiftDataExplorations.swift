import Foundation
import SwiftData
import SwiftUI

@Model
final class RemindersListModel: Equatable, Identifiable {
  var color = 0x4a99ef_ff
  @Relationship
  var reminders: [ReminderModel]
  var title = ""
  init(
    color: Int = 0x4a99ef_ff,
    reminders: [ReminderModel] = [],
    title: String = ""
  ) {
    self.color = color
    self.reminders = reminders
    self.title = title
  }
}

@Model
final class ReminderModel: Identifiable {
  var dueDate: Date?
  var isCompleted = 0
  var isFlagged = 0
  var notes = ""
  var priority: Int?
  @Relationship(inverse: \RemindersListModel.reminders)
  var remindersList: RemindersListModel
  var title = ""

  init(
    dueDate: Date? = nil,
    isCompleted: Int = 0,
    isFlagged: Int = 0,
    notes: String = "",
    priority: Int? = nil,
    remindersList: RemindersListModel,
    title: String = ""
  ) {
    self.dueDate = dueDate
    self.isCompleted = isCompleted
    self.isFlagged = isFlagged
    self.notes = notes
    self.priority = priority
    self.remindersList = remindersList
    self.title = title
  }
}
enum DetailTypeModel {
  case remindersList(RemindersListModel)
}

@MainActor
func remindersQuery(
  showCompleted: Bool,
  detailType: DetailTypeModel,
  ordering: Ordering
) -> Query<ReminderModel, [ReminderModel]> {
  let detailTypePredicate: Predicate<ReminderModel>
  switch detailType {
  case .remindersList(let remindersList):
    let id = remindersList.id
    detailTypePredicate = #Predicate {
      $0.remindersList.id == id
    }
  }
  let orderingSorts: [SortDescriptor<ReminderModel>] = switch ordering {
  case .dueDate:
    [SortDescriptor(\.dueDate)]
  case .priority:
    [
      SortDescriptor(\.priority, order: .reverse),
      SortDescriptor(\.isFlagged, order: .reverse)
    ]
  case .title:
    [SortDescriptor(\.title)]
  }
  return Query(
    filter: #Predicate {
      if !showCompleted {
        $0.isCompleted == 0 && detailTypePredicate.evaluate($0)
      } else {
        detailTypePredicate.evaluate($0)
      }
    },
    sort: [
      SortDescriptor(\.isCompleted)
    ] + orderingSorts,
    animation: .default
  )
}

extension Bool {
  var toInt: Int { self ? 1 : 0 }
}
