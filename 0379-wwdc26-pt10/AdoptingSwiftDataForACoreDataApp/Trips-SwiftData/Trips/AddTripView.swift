/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI view that adds a new trip.
*/

import MapKit
import SwiftData
import SwiftUI
import WidgetKit

struct AddTripView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.calendar) private var calendar
  @Environment(\.dismiss) private var dismiss
  @Environment(\.timeZone) private var timeZone
  @State private var name: String = ""
  @State private var destination: String = ""
  @State private var mapItem: MKMapItem?
  @State private var startDate = Date()
  @State private var endDate = Date()

  @Binding var newTripSegment: ContentView.Segment
  @State private var reason: PersonalTrip.Reason = .unknown
  @State private var perdiem: Double = 0.0
  @State private var showLocationSearch = false

  var dateRange: ClosedRange<Date> {
    let start = Date.now
    let components = DateComponents(
      calendar: calendar,
      timeZone: timeZone,
      year: 1
    )
    let end = calendar.date(byAdding: components, to: start)!
    return start...end
  }

  var body: some View {
    TripForm {
      Section(header: Text("Trip Title")) {
        TripGroupBox {
          TextField("Enter title here…", text: $name)
        }
        if newTripSegment == .personal {
          TripGroupBox {
            Picker("Reason", selection: $reason) {
              ForEach(PersonalTrip.Reason.allCases) { reason in
                Text(reason.rawValue.lowercased())
              }
            }
          }
        }
      }

      if newTripSegment == .business {
        Section(header: Text("Per diem")) {
          TripGroupBox {
            TextField(
              "",
              value: $perdiem,
              format: .currency(
                code: Locale.current.currency?.identifier ?? "USD"
              )
            )
          }
        }
      }

      Section(header: Text("Trip Destination")) {
        TripGroupBox {
          #if os(macOS)
            LocationSearchView(destination: $destination, mapItem: $mapItem)
          #else
            Button {
              showLocationSearch = true
            } label: {
              HStack {
                Text(
                  destination.isEmpty
                    ? "Search for a destination…" : destination
                )
                .foregroundStyle(destination.isEmpty ? .secondary : .primary)
                Spacer()
                Image(systemName: "magnifyingglass")
                  .foregroundStyle(.secondary)
              }
            }
          #endif
        }
      }

      Section(header: Text("Trip Dates")) {
        TripGroupBox {
          HStack {
            VStack(alignment: .leading) {
              Text("Start Date:")
                .font(.caption)
                .foregroundStyle(.secondary)

              DatePicker(
                selection: $startDate,
                in: dateRange,
                displayedComponents: .date
              ) {
                Label("Start Date", systemImage: "calendar")
              }
              .labelsHidden()
            }
            Spacer()
            VStack(alignment: .trailing) {
              Text("End Date:")
                .font(.caption)
                .foregroundStyle(.secondary)

              DatePicker(
                selection: $endDate,
                in: dateRange,
                displayedComponents: .date
              ) {
                Label("End Date", systemImage: "calendar")
              }
              .labelsHidden()
            }
          }
        }
      }
    }
    .frame(
      idealWidth: LayoutConstants.sheetIdealWidth,
      idealHeight: LayoutConstants.sheetIdealHeight
    )
    .navigationTitle("Add Trip")
    #if os(iOS)
      .sheet(isPresented: $showLocationSearch) {
        NavigationStack {
          LocationSearchSheet(destination: $destination, mapItem: $mapItem)
        }
        .presentationDetents([.medium, .large])
      }
    #endif
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("Dismiss") {
          dismiss()
        }
      }
      ToolbarItem(placement: .primaryAction) {
        Button("Done") {
          addTrip()
          WidgetCenter.shared.reloadTimelines(ofKind: "TripsWidget")
          dismiss()
        }
        .disabled(name.isEmpty || destination.isEmpty)
      }
    }
  }

  private func addTrip() {
    withAnimation {
      let location = mapItem.map {
        Location(
          latitude: $0.location.coordinate.latitude,
          longitude: $0.location.coordinate.longitude
        )
      }
      let newTrip: Trip
      if newTripSegment == .personal {
        newTrip = PersonalTrip(
          name: name,
          destination: destination,
          startDate: startDate,
          endDate: endDate,
          reason: reason,
          location: location
        )
      } else if newTripSegment == .business {
        newTrip = BusinessTrip(
          name: name,
          destination: destination,
          startDate: startDate,
          endDate: endDate,
          perdiem: perdiem,
          location: location
        )
      } else {
        newTrip = Trip(
          name: name,
          destination: destination,
          startDate: startDate,
          endDate: endDate,
          location: location
        )
      }
      newTrip.mapItemIdentifier = mapItem?.identifier
      modelContext.insert(newTrip)
      try? modelContext.save()
    }
  }
}

#Preview(traits: .sampleData) {
  AddTripView(newTripSegment: .constant(.all))
}

#Preview(traits: .sampleData) {
  AddTripView(newTripSegment: .constant(.personal))
}

#Preview(traits: .sampleData) {
  AddTripView(newTripSegment: .constant(.business))
}
