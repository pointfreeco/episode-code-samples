/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI view that updates a trip.
*/

import MapKit
import SwiftData
import SwiftUI
import WidgetKit

struct UpdateTripView: View {
  var trip: Trip

  @Environment(\.calendar) private var calendar
  @Environment(\.dismiss) private var dismiss
  @Environment(\.timeZone) private var timeZone
  @State private var name: String = ""
  @State private var destination: String = ""
  @State private var mapItem: MKMapItem?
  @State private var startDate = Date()
  @State private var endDate = Date()
  @State private var reason: PersonalTrip.Reason = .unknown
  @State private var perdiem: Double = 0.0

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

  @State private var showLocationSearch = false

  private var location: Location? {
    if let mapItem {
      return Location(
        latitude: mapItem.location.coordinate.latitude,
        longitude: mapItem.location.coordinate.longitude
      )
    }
    return trip.location
  }

  var body: some View {
    TripForm {
      Section(header: Text("Trip Title")) {
        TripGroupBox {
          TextField(
            trip.name.isEmpty ? "Enter title here…" : trip.name,
            text: $name
          )
        }
        if trip is PersonalTrip {
          TripGroupBox {
            Picker("Reason", selection: $reason) {
              ForEach(PersonalTrip.Reason.allCases) { reason in
                Text(reason.rawValue.lowercased())
              }
            }
          }
        }
      }

      if let businessTrip = trip as? BusinessTrip {
        Section(header: Text("Per diem")) {
          TripGroupBox {
            TextField(
              "\(businessTrip.perdiem)",
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
        if let location {
          Map(
            initialPosition: .region(
              MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(
                  latitudeDelta: 0.05,
                  longitudeDelta: 0.05
                )
              )
            )
          ) {
            Marker(
              destination.isEmpty ? "Location" : destination,
              coordinate: location.coordinate
            )
          }
          .frame(height: 200)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .allowsHitTesting(false)
          .listRowInsets(EdgeInsets())

          if let identifier = trip.mapItemIdentifier {
            Button {
              let request = MKMapItemRequest(mapItemIdentifier: identifier)
              Task {
                if let mapItem = try? await request.mapItem {
                  #if os(macOS)
                    await mapItem.openInMaps()
                  #else
                    await mapItem.openInMaps(from: nil)
                  #endif
                }
              }
            } label: {
              Label("Open in Maps", systemImage: "map")
            }
          }
        }
      }

      Section(header: Text("Trip Dates")) {
        TripGroupBox {
          TripDatesPicker(trip: trip)
        }
      }
    }
    .onAppear {
      /**
       Populate the start and end dates of the trip.
       */
      startDate = trip.startDate
      endDate = trip.endDate
      destination = trip.destination
      if let personalTrip = trip as? PersonalTrip {
        reason = personalTrip.reason
      } else if let businessTrip = trip as? BusinessTrip {
        perdiem = businessTrip.perdiem
      }
    }
    .navigationTitle("Update Trip")
    #if os(iOS)
      .sheet(isPresented: $showLocationSearch) {
        NavigationStack {
          LocationSearchSheet(destination: $destination, mapItem: $mapItem)
        }
        .presentationDetents([.medium, .large])
      }
    #endif
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button("Done") {
          updateTrip()
          WidgetCenter.shared.reloadTimelines(ofKind: "TripsWidget")
          dismiss()
        }
      }
    }
  }

  private func updateTrip() {
    if !name.isEmpty {
      trip.name = name
    }

    if !destination.isEmpty {
      trip.destination = destination
    }

    if let mapItem {
      trip.location = Location(
        latitude: mapItem.location.coordinate.latitude,
        longitude: mapItem.location.coordinate.longitude
      )
      trip.mapItemIdentifier = mapItem.identifier
    }
    trip.startDate = startDate
    trip.endDate = endDate
    if let personalTrip = trip as? PersonalTrip {
      personalTrip.reason = reason
    } else if let businessTrip = trip as? BusinessTrip {
      businessTrip.perdiem = perdiem
    }
  }
}
