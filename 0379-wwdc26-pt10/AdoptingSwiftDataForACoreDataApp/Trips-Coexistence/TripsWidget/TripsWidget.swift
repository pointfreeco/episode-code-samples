/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The types that provide timeline entries for the widget.
*/

import WidgetKit
import SwiftUI
import SwiftData

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
    private let modelContainer: ModelContainer
    
    init() {
        let appGroupContainerID = "group.com.example.apple-samplecode.SampleTrips"
        guard let appGroupContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupContainerID) else {
            fatalError("Shared file container could not be created.")
        }
        let url = appGroupContainer.appendingPathComponent("Trips.sqlite")

        do {
            modelContainer = try ModelContainer(for: Trip.self, configurations: ModelConfiguration(url: url))
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
    }

    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry.placeholderEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry.placeholderEntry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        /**
         modelContainer.mainContext requires main actor.
         This method returns immediately, but calls the completion handler at the end of the task.
         */
        Task { @MainActor in
            var fetchDescriptor = FetchDescriptor(sortBy: [SortDescriptor(\Trip.startDate, order: .forward)])
            let now = Date.now
            fetchDescriptor.predicate = #Predicate { $0.endDate >= now }
            if let upcomingTrips = try? modelContainer.mainContext.fetch(fetchDescriptor) {
                if let trip = upcomingTrips.first {
                    let newEntry = SimpleEntry(date: .now,
                                               startDate: trip.startDate,
                                               endDate: trip.endDate,
                                               name: trip.name,
                                               destination: trip.destination)
                    let timeline = Timeline(entries: [newEntry], policy: .after(newEntry.endDate))
                    completion(timeline)
                    return
                }
            }
            /**
             Return "No Trips" entry with .never policy when there is no upcoming trip.
             The main app triggers a widget update when adding a new trip.
             */
            let newEntry = SimpleEntry(date: .now,
                                       startDate: .now,
                                       endDate: .now,
                                       name: "No Trips",
                                       destination: "")
            let timeline = Timeline(entries: [newEntry], policy: .never)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    
    let startDate: Date
    let endDate: Date
    let name: String
    let destination: String
    
    static var placeholderEntry: SimpleEntry {
        let now = Date()
        let sevenDaysAfter = Calendar.current.date(byAdding: .day, value: 7, to: now)
        return SimpleEntry(date: now, startDate: now, endDate: sevenDaysAfter ?? Date(), name: "Honeymoon", destination: "Hawaii")
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
                    Text(entry.destination)
                        .font(.system(.title3).weight(.semibold))
                        .minimumScaleFactor(0.5)
                    Text(entry.startDate, style: .date)
                        .foregroundColor(.gray)
                    Text(entry.endDate, style: .date)
                        .foregroundColor(.gray)
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
