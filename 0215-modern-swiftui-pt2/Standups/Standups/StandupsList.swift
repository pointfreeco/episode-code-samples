import SwiftUINavigation
import SwiftUI

final class StandupsListModel: ObservableObject {
  @Published var destination: Destination?
  @Published var standups: [Standup]

  enum Destination {
    case add(EditStandupModel)
  }

  init(
    destination: Destination? = nil,
    standups: [Standup] = []
  ) {
    self.destination = destination
    self.standups = standups
  }

  func addStandupButtonTapped() {
    self.destination = .add(EditStandupModel(standup: Standup(id: Standup.ID(UUID()))))
  }

  func dismissAddStandupButtonTapped() {
    self.destination = nil
  }

  func confirmAddStandupButtonTapped() {
    defer { self.destination = nil }

    guard case let .add(editStandupModel) = self.destination
    else { return }
    var standup = editStandupModel.standup

    standup.attendees.removeAll { attendee in
      attendee.name.allSatisfy(\.isWhitespace)
    }
    if standup.attendees.isEmpty {
      standup.attendees.append(Attendee(id: Attendee.ID(UUID()), name: ""))
    }
    self.standups.append(standup)
  }
}

struct StandupsList: View {
  @ObservedObject var model: StandupsListModel

  var body: some View {
    NavigationStack {
      List {
        ForEach(self.model.standups) { standup in
          CardView(standup: standup)
            .listRowBackground(standup.theme.mainColor)
        }
      }
      .toolbar {
        Button {
          self.model.addStandupButtonTapped()
        } label: {
          Image(systemName: "plus")
        }
      }
      .navigationTitle("Daily Standups")
      .sheet(
        unwrapping: self.$model.destination,
        case: /StandupsListModel.Destination.add
      ) { $model in
        NavigationStack {
          EditStandupView(model: model)
            .navigationTitle("New standup")
            .toolbar {
              ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                  self.model.dismissAddStandupButtonTapped()
                }
              }
              ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                  self.model.confirmAddStandupButtonTapped()
                }
              }
            }
        }
      }
    }
  }
}

struct CardView: View {
  let standup: Standup

  var body: some View {
    VStack(alignment: .leading) {
      Text(self.standup.title)
        .font(.headline)
      Spacer()
      HStack {
        Label("\(self.standup.attendees.count)", systemImage: "person.3")
        Spacer()
        Label(self.standup.duration.formatted(.units()), systemImage: "clock")
          .labelStyle(.trailingIcon)
      }
      .font(.caption)
    }
    .padding()
    .foregroundColor(self.standup.theme.accentColor)
  }
}

struct TrailingIconLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.title
      configuration.icon
    }
  }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
  static var trailingIcon: Self { Self() }
}


struct StandupsList_Previews: PreviewProvider {
  static var previews: some View {
    StandupsList(
      model: StandupsListModel(
        standups: [
          .mock,
        ]
      )
    )
  }
}
