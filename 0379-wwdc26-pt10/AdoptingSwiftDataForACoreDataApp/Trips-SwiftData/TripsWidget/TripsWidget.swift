/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The types that provide timeline entries for the widget.
*/

import SwiftData
import SwiftUI
import WidgetKit

struct TripsWidget: Widget {
  let kind: String = "TripsWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      TripsWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Future Trips")
    .description("See your upcoming trips.")
  }
}

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    return SimpleEntry.placeholderEntry
  }

  func getSnapshot(
    in context: Context,
    completion: @escaping (SimpleEntry) -> Void
  ) {
    completion(SimpleEntry.placeholderEntry)
  }

  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<Entry>) -> Void
  ) {
    var fetchDesc = FetchDescriptor(sortBy: [
      SortDescriptor(\Trip.startDate, order: .forward)
    ])
    let currentDate = Date.now
    fetchDesc.predicate = #Predicate { $0.endDate >= currentDate }
    fetchDesc.fetchLimit = 1
    let modelContext = ModelContext(DataModel.shared.modelContainer)

    if let upcomingTrips = try? modelContext.fetch(fetchDesc) {
      if let trip = upcomingTrips.first {
        var accommodationStatus: AccommodationStatus = .noAccommodation
        if let livingAccommodation = trip.livingAccommodation {
          accommodationStatus =
            livingAccommodation.isConfirmed ? .confirmed : .notConfirmed
        }
        let newEntry = SimpleEntry(
          date: currentDate,
          startDate: trip.startDate,
          endDate: trip.endDate,
          name: trip.name,
          destination: trip.destination,
          accommodationStatus: accommodationStatus
        )
        let timeline = Timeline(
          entries: [newEntry],
          policy: .after(newEntry.endDate)
        )
        completion(timeline)
        return
      }
    }
    /**
     Return "No Trips" entry with `.never` policy when there is no upcoming trip.
     The main app initiates a widget update when adding a new trip.
     */
    let newEntry = SimpleEntry(
      date: currentDate,
      startDate: currentDate,
      endDate: currentDate,
      name: "No Trips",
      destination: "",
      accommodationStatus: .noAccommodation
    )
    let timeline = Timeline(entries: [newEntry], policy: .never)
    completion(timeline)
  }
}

enum AccommodationStatus {
  case noAccommodation, notConfirmed, confirmed
}

struct SimpleEntry: TimelineEntry {
  let date: Date

  let startDate: Date
  let endDate: Date
  let name: String
  let destination: String
  let accommodationStatus: AccommodationStatus

  static var placeholderEntry: SimpleEntry {
    let now = Date()
    let sevenDaysAfter = Calendar.current.date(
      byAdding: .day,
      value: 7,
      to: now
    )
    return SimpleEntry(
      date: now,
      startDate: now,
      endDate: sevenDaysAfter ?? Date(),
      name: "Honeymoon",
      destination: "Hawaii",
      accommodationStatus: .confirmed
    )
  }
}

struct TripsWidgetEntryView: View {
  let entry: SimpleEntry

  var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading) {
        HStack {
          Image(systemName: "car.circle")
            .imageScale(.large)
          Text(entry.name)
            .font(.system(.title2).weight(.semibold))
            .minimumScaleFactor(0.5)
          Spacer()
        }
        .foregroundColor(.green)

        Divider()
        if !entry.destination.isEmpty {
          Group {
            Text(entry.destination)
              .font(.system(.title3).weight(.semibold))
            Text(entry.startDate, style: .date)
            Text(entry.endDate, style: .date)
            Spacer()

            if entry.accommodationStatus != .noAccommodation {
              Button(
                intent: AccommodationIntent(
                  tripName: entry.name,
                  startDate: entry.startDate,
                  endDate: entry.endDate
                )
              ) {
                HStack {
                  Text("Accommodation")
                  Image(
                    systemName: entry.accommodationStatus == .confirmed
                      ? "checkmark.circle" : "circle"
                  )
                }
              }
              .buttonStyle(.borderless)
              .foregroundColor(
                entry.accommodationStatus == .confirmed ? .green : .red
              )
            } else {
              Text("No accommondation.")
            }
          }
          .foregroundColor(.gray)
          .minimumScaleFactor(0.5)
        }
      }
    }
    .containerBackground(for: .widget) {
      Color.white
    }
  }
}

#Preview(as: .systemSmall) {
  TripsWidget()
} timeline: {
  SimpleEntry.placeholderEntry
}
