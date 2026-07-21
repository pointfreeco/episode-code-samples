import MapKit
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
}

struct TripListView: View {
  @FetchAll(Trip.none) var trips
  @State var segment = Segment.all
  @State var sort = SortOption.name

  var body: some View {
    List {
      ForEach(trips) { trip in
        TripListRow(trip: trip)
      }
    }
    .task(id: [segment as AnyHashable, sort]) {
      await withErrorReporting {
        _ = try await $trips.load(
          Trip
            .where {
              switch segment {
              case .all: true
              case .business: $0.purpose.is(\.business)
              case .personal: $0.purpose.is(\.personal)
              }
            }
            .order {
              switch sort {
              case .endDate: $0.endDate
              case .startDate: $0.startDate
              case .name: $0.name
              }
            },
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
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Group action@*//*@END_MENU_TOKEN@*/
              } label: {
                if /*@START_MENU_TOKEN@*//*@PLACEHOLDER=group is selected@*/false/*@END_MENU_TOKEN@*/ {
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
