/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The view that displays all trips on a MapKit map.
*/

import MapKit
import SwiftData
import SwiftUI

struct TripMap: View {
  @Environment(\.modelContext) private var modelContext
  @Binding var selection: Trip?
  @State private var mapController: MapCameraController?
  @State private var mapSelection: MapSelection<Trip>?

  init(selection: Binding<Trip?>) {
    self._selection = selection
  }

  private var cameraPosition: Binding<MapCameraPosition> {
    Binding(
      get: { mapController?.cameraPosition ?? .automatic },
      set: { mapController?.cameraPosition = $0 }
    )
  }

  var body: some View {
    Map(position: cameraPosition, selection: $mapSelection) {
      ForEach(mapController?.trips ?? []) { (trip: Trip) in
        if let location = trip.location {
          Marker(trip.name, coordinate: location.coordinate)
            .tint(trip.color)
            .tag(MapSelection(trip))
        }
      }
    }
    .task {
      while true {
        try! await Task.sleep(for: .seconds(1))
        mapController?.trips[0].endDate = Date()
        try! modelContext.save()
      }
    }
    .onAppear {
      self.mapController = MapCameraController(modelContext: modelContext)
    }
    .onChange(of: mapSelection) { _, newValue in
      if case .some(let mapSel) = newValue {
        selection = mapController?.trips.first { MapSelection($0) == mapSel }
      }
    }
  }
}
