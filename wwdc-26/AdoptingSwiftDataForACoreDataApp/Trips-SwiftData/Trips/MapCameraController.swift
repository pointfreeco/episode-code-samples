/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
Helper that determines a `MapCameraPosition` using `ResultsObserver`.
*/

import MapKit
import SwiftData
import SwiftUI

@Observable
@MainActor
final class MapCameraController {
  private let resultsObserver: ResultsObserver<Trip, Never>
  var cameraPosition: MapCameraPosition = .automatic
  var trips: [Trip] = []
  @ObservationIgnored private var token: ObservationTracking.Token?

  init(modelContext: ModelContext) {
    do {
      var fetchDescriptor = FetchDescriptor<Trip>()
      fetchDescriptor.propertiesToFetch = [\.location]
      resultsObserver = try ResultsObserver<Trip, Never>(
        fetchDescriptor: fetchDescriptor,
        modelContext: modelContext
      )
    } catch {
      fatalError("Failed to create trip results observer: \(error)")
    }
    token = withContinuousObservation(options: [.didSet]) {
      [resultsObserver] event in
      withAnimation {
        self.cameraPosition = self.calculateCameraPosition()
      }
      self.trips = Array(resultsObserver.results)
    }
  }

  private func calculateCameraPosition() -> MapCameraPosition {
    let coordinates = resultsObserver.results.compactMap {
      $0.location?.coordinate
    }
    guard let first = coordinates.first else { return .automatic }
    var latRange = first.latitude...first.latitude
    var lngRange = first.longitude...first.longitude
    for coord in coordinates.dropFirst() {
      latRange =
        min(
          latRange.lowerBound,
          coord.latitude
        )...max(latRange.upperBound, coord.latitude)
      lngRange =
        min(
          lngRange.lowerBound,
          coord.longitude
        )...max(lngRange.upperBound, coord.longitude)
    }
    let center = CLLocationCoordinate2D(
      latitude: (latRange.lowerBound + latRange.upperBound) / 2,
      longitude: (lngRange.lowerBound + lngRange.upperBound) / 2
    )
    let span = MKCoordinateSpan(
      latitudeDelta: max(
        (latRange.upperBound - latRange.lowerBound) * 1.3,
        0.01
      ),
      longitudeDelta: max(
        (lngRange.upperBound - lngRange.lowerBound) * 1.3,
        0.01
      )
    )
    return .region(MKCoordinateRegion(center: center, span: span))
  }
}
