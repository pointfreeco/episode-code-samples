import Dependencies
import Foundation
import MapKit
import OSLog
import SQLiteData
import SwiftUINavigation
import SwiftUI

struct Location: Codable {
  var latitude = 0.0
  var longitude = 0.0

  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}

@Table struct Trip: Identifiable {
  let id: UUID
  var name = ""
  var destination = ""
  @Column(as: Location.JSONRepresentation.self)
  var location: Location
  var startDate: Date = .now
  var endDate: Date = .now
  var purpose: Purpose = .personal()
  @Column(as: MKMapItem.Identifier.JSONRepresentation.self)
  var mapItemIdentifier: MKMapItem.Identifier
  var displayName: String {
    name.isEmpty ? "Untitled Trip" : name
  }
  var displayDestination: String {
    destination.isEmpty ? "Untitled Destination" : destination
  }
  @CaseBindable
  @Selection
  enum Purpose {
    case personal(Personal = Personal())
    case business(Business = Business())
    @Selection
    struct Personal {
      var reason: Reason = .unknown
      enum Reason: String, CaseIterable, Identifiable, QueryBindable {
        case family
        case reunion
        case wellness
        case unknown

        var id: Self { self }
      }
    }
    @Selection
    struct Business {
      var perdiem = 0.0
    }
    var color: Color {
      switch self {
      case .personal: .blue
      case .business: .green
      }
    }
  }
}

@Table struct BucketListItem: Identifiable {
  let id: UUID
  var title = ""
  var details = ""
  var hasReservation = false
  var isInPlan = false
  var tripID: Trip.ID
}

@Table struct LivingAccommodation: Identifiable {
  let id: UUID
  var address = ""
  var placeName = ""
  var isConfirmed = false
  var tripID: Trip.ID
}

extension DependencyValues {
  mutating func bootstrapDatabase() throws {
    @Dependency(\.context) var context
    var configuration = Configuration()
    configuration.prepareDatabase { db in
      #if DEBUG
        db.trace(options: .profile) {
          guard
            !SyncEngine.isSynchronizing,
            !$0.expandedDescription.hasPrefix("--")
          else { return }
          switch context {
          case .live:
            logger.debug("\($0.expandedDescription)")
          case .preview:
            print("\($0.expandedDescription)")
          case .test:
            break
          }
        }
      #endif
    }
    let database = try SQLiteData.defaultDatabase(configuration: configuration)
    var migrator = DatabaseMigrator()
    #if DEBUG
      migrator.eraseDatabaseOnSchemaChange = true
    #endif
    migrator.registerMigration(
      "Create 'trips', 'bucketListItems', and 'livingAccommodations' tables"
    ) { db in
      try #sql(
        """
        CREATE TABLE "trips" (
          "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
          "name" TEXT NOT NULL DEFAULT '',
          "destination" TEXT NOT NULL DEFAULT '',
          "startDate" TEXT NOT NULL,
          "endDate" TEXT NOT NULL,
          "reason" TEXT,
          "perdiem" REAL,
          "location" TEXT NOT NULL,
          "mapItemIdentifier" TEXT
        ) STRICT
        """
      )
      .execute(db)
      try #sql(
        """
        CREATE TABLE "bucketListItems" (
          "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
          "title" TEXT NOT NULL DEFAULT '',
          "details" TEXT NOT NULL DEFAULT '',
          "hasReservation" INTEGER NOT NULL DEFAULT 0,
          "isInPlan" INTEGER NOT NULL DEFAULT 0,
          "tripID" TEXT NOT NULL REFERENCES "trips"("id") ON DELETE CASCADE
        ) STRICT
        """
      )
      .execute(db)
      try #sql(
        """
        CREATE INDEX "index_bucketListItems_on_tripID" ON "bucketListItems"("tripID")
        """
      )
      .execute(db)
      try #sql(
        """
        CREATE TABLE "livingAccommodations" (
          "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
          "address" TEXT NOT NULL DEFAULT '',
          "placeName" TEXT NOT NULL DEFAULT '',
          "isConfirmed" INTEGER NOT NULL DEFAULT 0,
          "tripID" TEXT NOT NULL REFERENCES "trips"("id") ON DELETE CASCADE
        ) STRICT
        """
      )
      .execute(db)
      try #sql(
        """
        CREATE INDEX "index_livingAccommodations_on_tripID" ON "livingAccommodations"("tripID")
        """
      )
      .execute(db)
    }
    try migrator.migrate(database)
    defaultDatabase = database
  }
}

private nonisolated let logger = Logger(
  subsystem: "Trips",
  category: "Database"
)
