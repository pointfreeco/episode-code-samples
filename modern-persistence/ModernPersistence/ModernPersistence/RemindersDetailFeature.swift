import SharingGRDB
import SwiftUI

@MainActor
@Observable
class RemindersDetailModel {

}

struct RemindersDetailView: View {
  @Bindable var model: RemindersDetailModel

  var body: some View {
    List {
      ForEach(/*@START_MENU_TOKEN@*/[Reminder(id: 1, remindersListID: 1, title: "Groceries"), Reminder(id: 2, remindersListID: 2, title: "Haircut"), Reminder(id: 3, remindersListID: 3, title: "Take a walk")]/*@PLACEHOLDER=Reminders@*//*@END_MENU_TOKEN@*/) { reminder in
        ReminderRow(
          color: /*@START_MENU_TOKEN@*/Color.blue/*@PLACEHOLDER=Color.blue@*//*@END_MENU_TOKEN@*/,
          isPastDue: /*@START_MENU_TOKEN@*/false/*@PLACEHOLDER=false@*//*@END_MENU_TOKEN@*/,
          reminder: reminder,
          tags: /*@START_MENU_TOKEN@*/["weekend", "fun"]/*@PLACEHOLDER=["weekend", "fun"]@*//*@END_MENU_TOKEN@*/
        ) {
          // Details button tapped in row
        }
      }
    }
    .navigationTitle(Text(/*@START_MENU_TOKEN@*/"Reminders"/*@PLACEHOLDER=Reminders@*//*@END_MENU_TOKEN@*/))
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
        .tint(/*@START_MENU_TOKEN@*/Color.blue/*@PLACEHOLDER=Color.blue@*//*@END_MENU_TOKEN@*/)
      }
      ToolbarItem(placement: .primaryAction) {
        Menu {
          Group {
            Menu {
              ForEach(/*@START_MENU_TOKEN@*/["Due Date", "Priority", "Title"]/*@PLACEHOLDER=["Due Date", "Priority", "Title"]@*//*@END_MENU_TOKEN@*/, id: \.self) { ordering in
                Button {
                  /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Order action@*//*@END_MENU_TOKEN@*/
                } label: {
                  Label {
                    Text(ordering)
                  } icon: {
                    /*@START_MENU_TOKEN@*/Image(systemName: "calendar")/*@PLACEHOLDER=Ordering icon@*//*@END_MENU_TOKEN@*/
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
              /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Show/hide completed action@*//*@END_MENU_TOKEN@*/
            } label: {
              Label {
                Text(/*@START_MENU_TOKEN@*/false/*@PLACEHOLDER=showCompleted@*//*@END_MENU_TOKEN@*/ ? "Hide Completed" : "Show Completed")
              } icon: {
                Image(systemName: /*@START_MENU_TOKEN@*/false/*@PLACEHOLDER=showCompleted@*//*@END_MENU_TOKEN@*/ ? "eye.slash.fill" : "eye")
              }
            }
          }
          .tint(/*@START_MENU_TOKEN@*/Color.blue/*@PLACEHOLDER=Color.blue@*//*@END_MENU_TOKEN@*/)
        } label: {
          Image(systemName: "ellipsis.circle")
            .tint(/*@START_MENU_TOKEN@*/Color.blue/*@PLACEHOLDER=Color.blue@*//*@END_MENU_TOKEN@*/)
        }
      }
    }
  }
}

struct RemindersDetailPreview: PreviewProvider {
  static var previews: some View {
    let _ = prepareDependencies { $0.defaultDatabase = try! appDatabase() }

    NavigationStack {
      RemindersDetailView(model: RemindersDetailModel())
    }
  }
}
