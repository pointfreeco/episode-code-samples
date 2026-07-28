import CoreLocation
import MapKit
import OrderedCollections
import SQLiteData
import SwiftUI

enum Segment: String, CaseIterable {
  case all = "All"
  case personal = "Personal"
  case business = "Business"
}
enum SortOption: String, CaseIterable {
  case startDate = "Start Date"
  case endDate = "End Date"
  case name = "Name"
  case proximityToNorthPole = "Proximity to North Pole"
  case distanceFromUser = "Distance From You"
}
enum GroupOption: String, CaseIterable {
  case none = "None"
  case destination = "Destination"
  case nameFirstLetter = "Name"
  case distanceFromUser = "Distance From You"
}

struct TripListView: View {
  @FetchAll(Trip.none) var trips
  @State var segment = Segment.all
  @State var sort = SortOption.name
  @State var group = GroupOption.none
  @State var currentLocation: Location?

  @Dependency(\.defaultDatabase) var defaultDatabase

  var body: some View {
    List {
      ForEach($trips.sections) { section in
        Section {
          ForEach(section) { trip in
            TripListRow(trip: trip)
          }
        } header: {
          if let name = section.name {
            Text(name)
          }
        }
      }
    }
    .task(id: [segment as AnyHashable, sort, group, currentLocation]) {
      await withErrorReporting {
        _ = try await $trips.load(
          Trip
            .where {
              !$0.geofence.jsonEach()
                .where {
                  $0.value.jsonExtract(\.latitude).lt(0)
                }
                .exists()
            }
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
              case .proximityToNorthPole:
                $0.location.jsonExtract(\.latitude).desc()
              case .distanceFromUser:
                if let currentLocation {
                  $0.location.miles(from: currentLocation)
                } else {
                  $0.name
                }
              }
            }
            .limit { _ in
              if sort == .distanceFromUser, currentLocation == nil {
                0
              }
            },
          sectionBy: {
            switch group {
            case .destination: $0.destination.desc()
            case .nameFirstLetter: $0.name.substr(1, 1).desc()
            case .none: ""
            case .distanceFromUser:
              if let currentLocation {
                let miles = $0.location.miles(from: currentLocation)
                Case()
                  .when(miles.lt(10), then: "<10 miles")
                  .when(miles.lt(100), then: "<100 miles")
                  .when(miles.lt(1_000), then: "<1000 miles")
                  .else("≥1000 miles")
              } else {
                ""
              }
            }
          },
          animation: .default
        )
      }
    }
    .task(id: [sort as AnyHashable, group]) {
      guard
        sort == .distanceFromUser || group == .distanceFromUser
      else { return }
      await withErrorReporting {
        for try await update in CLLocationUpdate.liveUpdates() {
          guard let location = update.location else { continue }
          currentLocation = Location(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
          )
        }
      }
    }
    .toolbar {
      #if DEBUG
        ToolbarItem(placement: .topBarLeading) {
          Button {
            withErrorReporting {
              try defaultDatabase.seedDatabase()
            }
          } label: {
            Image(systemName: "leaf.circle.fill")
          }
        }
      #endif
      ToolbarItemGroup(placement: .topBarTrailing) {
        Button {
          /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Add trip action@*/
          /*@END_MENU_TOKEN@*/
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

extension QueryExpression<Location.JSONRepresentation> {
  func miles(from location: Location) -> some QueryExpression<Double> {
    #sql(
      """
      3958.8 * acos(
      sin(radians(\(location.latitude))) * sin(radians(\(jsonExtract(\.latitude))))
      + cos(radians(\(location.latitude))) * cos(radians(\(jsonExtract(\.latitude))))
      * cos(radians(\(jsonExtract(\.longitude)) - \(location.longitude)))
      )
      """
    )
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
    try! $0.defaultDatabase.seedDatabase()
  }

  NavigationStack {
    TripListView()
  }
}
