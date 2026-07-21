import MapKit
import OrderedCollections
import SwiftUI
import SQLiteData

enum Segment: String, CaseIterable {
  case all = "All"
  case personal = "Personal"
  case business = "Business"
}
enum SortOption: String, CaseIterable {
  case startDate = "Start Date"
  case endDate = "End Date"
  case name = "Name"
}
enum GroupOption: String, CaseIterable {
  case none = "None"
  case destination = "Destination"
  case nameFirstLetter = "Name"
}

struct TripListView: View {
  //@FetchAll(Trip.none) var trips
  @Fetch var trips = Trips.Value()
  @State var segment = Segment.all
  @State var sort = SortOption.name
  @State var group = GroupOption.none

  struct Trips: FetchKeyRequest {
    var segment = Segment.all
    var sort = SortOption.name
    var group = GroupOption.none
    func fetch(_ db: Database) throws -> OrderedDictionary<String, [Trip]> {
      OrderedDictionary(
        grouping: try Trip
          .where {
            switch segment {
            case .all: true
            case .business: $0.purpose.is(\.business)
            case .personal: $0.purpose.is(\.personal)
            }
          }
          .order {
            switch group {
            case .none: true
            case .destination: $0.destination.desc()
            case .nameFirstLetter: $0.name.substr(1, 1)
            }
          }
          .order {
            switch sort {
            case .endDate: $0.endDate
            case .startDate: $0.startDate
            case .name: $0.name
            }
          }
          .fetchAll(db),
        by: { trip in
          switch group {
          case .none: ""
          case .destination: trip.destination
          case .nameFirstLetter: trip.name.first.map(String.init) ?? ""
          }
        }
      )
    }
  }

  var body: some View {
    List {
      ForEach(trips.keys, id: \.self) { destination in
        Section {
          ForEach(trips[destination] ?? []) { trip in
            TripListRow(trip: trip)
          }
        } header: {
          Text(destination)
        }
      }
    }
    .task(id: [segment as AnyHashable, sort, group]) {
      await withErrorReporting {
        _ = try await $trips.load(
          Trips(segment: segment, sort: sort, group: group),
          animation: .default
        )
      }
    }
    .toolbar {
      ToolbarItemGroup(placement: .topBarTrailing) {
        Button {
          /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Add trip action@*//*@END_MENU_TOKEN@*/
        } label: {
          Label("Add trip", systemImage: "plus")
        }
        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
          Section {
            ForEach(Segment.allCases, id: \.self) { segment in
              Button {
                self.segment = segment
              } label: {
                if self.segment == segment {
                  Label(segment.rawValue, systemImage: "checkmark")
                } else {
                  Text(segment.rawValue)
                }
              }
            }
          }
          Section("Sort By") {
            ForEach(SortOption.allCases, id: \.self) { option in
              Button {
                self.sort = option
              } label: {
                if self.sort == option {
                  Label(option.rawValue, systemImage: "checkmark")
                } else {
                  Text(option.rawValue)
                }
              }
            }
          }
          Section("Group By") {
            ForEach(GroupOption.allCases, id: \.self) { option in
              Button {
                group = option
              } label: {
                if group == option {
                  Label(option.rawValue, systemImage: "checkmark")
                } else {
                  Text(option.rawValue)
                }
              }
            }
          }
        }
      }
    }
  }
}

private struct TripListRow: View {
  let trip: Trip

  var body: some View {
    Button {
      /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*//*@END_MENU_TOKEN@*/
    } label: {
      HStack {
        RoundedRectangle(cornerRadius: 8)
          .fill(trip.purpose.color)
          .frame(width: 64, height: 64)
          .overlay {
            Text(String(trip.displayName.first!))
              .font(.system(size: 48))
              .foregroundStyle(.background)
          }

        VStack(alignment: .leading) {
          Text(trip.displayName)
            .font(.headline)
          Text(trip.displayDestination)
            .font(.subheadline)

          Divider()
          HStack {
            Text(trip.startDate, style: .date)
            Image(systemName: "arrow.right")
            Text(trip.endDate, style: .date)
          }
          .font(.caption)
        }
      }
    }
    .buttonStyle(.plain)
    .swipeActions(edge: .trailing) {
      Button(role: .destructive) {
      } label: {
        Label("Delete", systemImage: "trash")
      }
    }
  }
}

#Preview {
  let _ = prepareDependencies {
    try! $0.bootstrapDatabase()
    try! $0.seedDatabaseForPreviews()
  }

  NavigationStack {
    TripListView()
  }
}
