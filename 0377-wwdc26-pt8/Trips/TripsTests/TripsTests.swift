import DebugSnapshots
import DependenciesTestSupport
import Foundation
import MapKit
import SQLiteData
import SwiftUI
import Testing

@testable import Trips

@Suite(
  .dependencies {
    try $0.bootstrapDatabase()
  }
)
struct TripsTests {
  @Dependency(\.defaultDatabase) var database


  @Test func `clear all vertices`() async throws {
    let trip = try await database.write { db in
      try Trip.insert {
        Trip.Draft(
          name: "Blob's big trip",
          location: Location(latitude: 0, longitude: 0),
          geofence: [
            Location(latitude: 1, longitude: 1),
            Location(latitude: -1, longitude: 1),
            Location(latitude: -1, longitude: -1),
            Location(latitude: 1, longitude: -1),
          ],
          mapItemIdentifier: MKMapItem.Identifier(rawValue: "I7C250D2CDCB364A")!
        )
      }
      .returning(\.self)
      .fetchOne(db)!
    }
    let model = TripGeofenceModel(trip: trip)

    try await expect(model) {
      model.clearVerticesButtonTapped()
      try await model.$trip.load()
    } changes: {
      $0.trip.geofence = []
      $0.tripInsideGeofence = false
      $0.geofenceColor = .red
    }
  }

  @Test func `drag and drop vertex, geofence does not contain trip`() async throws {
    let trip = try await database.write { db in
      try Trip.insert {
        Trip.Draft(
          name: "Blob's big trip",
          location: Location(latitude: 0, longitude: 0),
          geofence: [
            Location(latitude: 1, longitude: 1),
            Location(latitude: -1, longitude: 1),
            Location(latitude: -1, longitude: -1),
            Location(latitude: 1, longitude: -1),
          ],
          mapItemIdentifier: MKMapItem.Identifier(rawValue: "I7C250D2CDCB364A")!
        )
      }
      .returning(\.self)
      .fetchOne(db)!
    }
    let model = TripGeofenceModel(trip: trip)

    expect(model) {
      model.draggingVertex = DraggingVertex(
        index: 0,
        location: Location(latitude: -0.5, longitude: -0.5)
      )
    } changes: {
      $0.draggingVertex = DraggingVertex(
        index: 0,
        location: Location(latitude: -0.5, longitude: -0.5)
      )
      $0.tripInsideDraggingGeofence = false
      $0.draggingGeofenceColor = .red
    }

    try await expect(model) {
      model.droppedVertex()
      try await model.$trip.load()
    } changes: {
      $0.trip.geofence[0].latitude = -0.5
      $0.trip.geofence[0].longitude = -0.5
      $0.draggingVertex = nil
      $0.tripInsideDraggingGeofence = nil
      $0.draggingGeofenceColor = nil
      $0.tripInsideGeofence = false
      $0.geofenceColor = .red
    }
  }

  @Test func `user taps on map to add vertices to geofence`() async throws {
    let trip = try await database.write { db in
      try Trip.insert {
        Trip.Draft(
          name: "Blob's big trip",
          location: Location(latitude: 0, longitude: 0),
          mapItemIdentifier: MKMapItem.Identifier(rawValue: "I7C250D2CDCB364A")!
        )
      }
      .returning(\.self)
      .fetchOne(db)!
    }
    let model = TripGeofenceModel(trip: trip)

    try await expect(model) {
      model.mapTapped(coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1))
      model.mapTapped(coordinate: CLLocationCoordinate2D(latitude: -1, longitude: 1))
      model.mapTapped(coordinate: CLLocationCoordinate2D(latitude: -1, longitude: -1))
      model.mapTapped(coordinate: CLLocationCoordinate2D(latitude: 1, longitude: -1))
      try await model.$trip.load()
    } changes: {
      $0.tripInsideGeofence = true
      $0.geofenceColor = .blue
      $0.trip.geofence = [
        Location(latitude: 1, longitude: 1),
        Location(latitude: -1, longitude: 1),
        Location(latitude: -1, longitude: -1),
        Location(latitude: 1, longitude: -1),
      ]
    }

  }

  @Test func naive() async throws {
    let trip = try await database.write { db in
      try Trip.insert {
        Trip.Draft(
          name: "Blob's big trip",
          location: Location(latitude: 0, longitude: 0),
          mapItemIdentifier: MKMapItem.Identifier(rawValue: "I7C250D2CDCB364A")!
        )
      }
      .returning(\.self)
      .fetchOne(db)!
    }
    let model = TripGeofenceModel(trip: trip)

    #expect(model.tripInsideGeofence == false)
    #expect(model.geofenceColor == .red)

    model.mapTapped(coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1))
    model.mapTapped(coordinate: CLLocationCoordinate2D(latitude: -1, longitude: 1))
    model.mapTapped(coordinate: CLLocationCoordinate2D(latitude: -1, longitude: -1))
    model.mapTapped(coordinate: CLLocationCoordinate2D(latitude: 1, longitude: -1))
    try await model.$trip.load()

    #expect(model.trip.name == "Blob's big trip")
    #expect(
      model.trip.geofence == [
        Location(latitude: 1, longitude: 1),
        Location(latitude: -1, longitude: 1),
        Location(latitude: -1, longitude: -1),
        Location(latitude: 1, longitude: -1),
      ]
    )
    #expect(model.tripInsideGeofence == true)
    #expect(model.geofenceColor == .blue)
  }
}
