/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI view that shows the trip list.
*/

import SwiftData
import SwiftUI
import WidgetKit

private struct TripListRow: View {
  let trip: Trip
  let isUnread: Bool
  @Environment(\.modelContext) private var modelContext

  var body: some View {
    TripListItem(trip: trip, isUnread: isUnread)
      .tag(trip)
      .swipeActions(edge: .trailing) {
        Button(role: .destructive) {
          modelContext.delete(trip)
          WidgetCenter.shared.reloadTimelines(ofKind: "TripsWidget")
          try? modelContext.save()
        } label: {
          Label("Delete", systemImage: "trash")
        }
      }
  }
}

// MARK: - Trip List

struct TripListView: View {
  @Environment(\.modelContext) private var modelContext
  @Query var trips: [Trip]

  @Binding var selection: Trip?
  @Binding var tripCount: Int
  @Binding var unreadTripIdentifiers: [PersistentIdentifier]

  init(
    selection: Binding<Trip?>,
    segment: Binding<ContentView.Segment>,
    tripCount: Binding<Int>,
    unreadTripIdentifiers: Binding<[PersistentIdentifier]>,
    searchText: String,
    sectionBy: KeyPath<Trip, String>? = nil,
    sortDescriptor: SortDescriptor<Trip> = SortDescriptor(\.startDate)
  ) {
    _selection = selection
    _tripCount = tripCount
    _unreadTripIdentifiers = unreadTripIdentifiers
    let filter = Self.buildPredicate(
      segment: segment.wrappedValue,
      searchText: searchText
    )

    _trips = Query(filter: filter, sort: [sortDescriptor], animation: .default, sectionBy: sectionBy)
  }

  var body: some View {
    List(selection: $selection) {
      if _trips.sections.isEmpty {
        ForEach(trips) { trip in
          TripListRow(
            trip: trip,
            isUnread: unreadTripIdentifiers.contains(trip.persistentModelID)
          )
        }
      } else {
        ForEach(_trips.sections) { section in
          Section(section.id) {
            ForEach(section) { trip in
              TripListRow(
                trip: trip,
                isUnread: unreadTripIdentifiers.contains(trip.persistentModelID)
              )
            }
          }
        }
      }
    }
    .animation(.default, value: trips)
    .overlay {
      if trips.isEmpty {
        ContentUnavailableView {
          Label("No Trips", systemImage: "car.circle")
        } description: {
          Text("New trips you create will appear here.")
        }
      }
    }
    .onChange(of: trips, initial: true) { tripCount = trips.count }
  }

  private static func buildPredicate(
    segment: ContentView.Segment,
    searchText: String
  ) -> Predicate<Trip> {
    let segmentPredicate = segment.predicate ?? #Predicate<Trip> { _ in true }
    let searchPredicate: Predicate<Trip>
    if searchText.isEmpty {
      searchPredicate = #Predicate<Trip> { _ in true }
    } else {
      searchPredicate = #Predicate<Trip> {
        $0.name.localizedStandardContains(searchText)
          || $0.destination.localizedStandardContains(searchText)
      }
    }
    return #Predicate<Trip> {
      segmentPredicate.evaluate($0) && searchPredicate.evaluate($0)
    }
  }
}
