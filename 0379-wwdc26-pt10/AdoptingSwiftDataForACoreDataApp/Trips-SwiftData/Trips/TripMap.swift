/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The view that displays all trips on a MapKit map.
*/

import MapKit
import SwiftData
import SwiftUI
import LazyState

struct TripMap: View {
  @Binding var selection: Trip?
  @LazyState private var mapController: MapCameraController
  @State private var mapSelection: MapSelection<Trip>?

  init(selection: Binding<Trip?>, modelContext: ModelContext) {
    self._selection = selection
    _mapController = LazyState { MapCameraController(modelContext: modelContext) }
  }

  var body: some View {
    Map(position: $mapController.cameraPosition, selection: $mapSelection) {
      ForEach(mapController.trips) { (trip: Trip) in
        if let location = trip.location {
          Marker(trip.name, coordinate: location.coordinate)
            .tint(trip.color)
            .tag(MapSelection(trip))
        }
      }
    }
    .onChange(of: mapSelection) { _, newValue in
      if case .some(let mapSel) = newValue {
        selection = mapController.trips.first { MapSelection($0) == mapSel }
      }
    }
  }
}
