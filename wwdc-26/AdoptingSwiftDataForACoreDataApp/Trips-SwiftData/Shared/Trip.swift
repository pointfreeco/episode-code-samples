/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The model class of trips.
*/

import Foundation
import MapKit
import SwiftData
import SwiftUI

struct Location: Codable, Hashable {
  var latitude: Double
  var longitude: Double

  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}

@Model class Trip {
  #Index<Trip>(
    [\.name],
    [\.startDate],
    [\.endDate],
    [\.name, \.startDate, \.endDate]
  )
  #Unique<Trip>([\.name, \.startDate, \.endDate])

  @Attribute(.preserveValueOnDeletion)
  var name: String
  var destination: String

  var location: Location?

  @Attribute(.preserveValueOnDeletion)
  var startDate: Date

  @Attribute(.preserveValueOnDeletion)
  var endDate: Date

  @Relationship(deleteRule: .cascade, inverse: \BucketListItem.trip)
  var bucketList: [BucketListItem] = [BucketListItem]()

  @Relationship(deleteRule: .cascade, inverse: \LivingAccommodation.trip)
  var livingAccommodation: LivingAccommodation?

  @Attribute(.codable) var mapItemIdentifier: MKMapItem.Identifier?

  init(
    name: String,
    destination: String,
    startDate: Date = .now,
    endDate: Date = .distantFuture,
    location: Location? = nil
  ) {
    self.name = name
    self.destination = destination
    self.startDate = startDate
    self.endDate = endDate
    self.location = location
  }

  var color: Color {
    return .yellow
  }
}

@available(iOS 26, *)
@Model
class PersonalTrip: Trip {

  enum Reason: String, CaseIterable, Codable, Identifiable {
    case family
    case reunion
    case wellness
    case unknown

    var id: Self { self }
  }
  var reason: Reason

  init(
    name: String,
    destination: String,
    startDate: Date = .now,
    endDate: Date = .distantFuture,
    reason: Reason,
    location: Location? = nil
  ) {
    self.reason = reason
    super.init(
      name: name,
      destination: destination,
      startDate: startDate,
      endDate: endDate,
      location: location
    )
  }

  override var color: Color {
    return .blue
  }
}

@available(iOS 26, *)
@Model
class BusinessTrip: Trip {
  var perdiem: Double = 0.0
  init(
    name: String,
    destination: String,
    startDate: Date = .now,
    endDate: Date = .distantFuture,
    perdiem: Double?,
    location: Location? = nil
  ) {
    if let givenPerdiem = perdiem {
      self.perdiem = givenPerdiem
    }
    super.init(
      name: name,
      destination: destination,
      startDate: startDate,
      endDate: endDate,
      location: location
    )
  }

  override var color: Color {
    return .green
  }
}

extension Trip {
  var displayName: String {
    name.isEmpty ? "Untitled Trip" : name
  }

  var displayDestination: String {
    destination.isEmpty ? "Untitled Destination" : destination
  }

  static var preview: Trip {
    Trip(
      name: "Trip Name",
      destination: "Trip destination",
      startDate: .now,
      endDate: .now.addingTimeInterval(4 * 3600)
    )
  }

  private static func date(
    calendar: Calendar = Calendar(identifier: .gregorian),
    timeZone: TimeZone = TimeZone.current,
    year: Int,
    month: Int,
    day: Int
  ) -> Date {
    let dateComponent = DateComponents(
      calendar: calendar,
      timeZone: timeZone,
      year: year,
      month: month,
      day: day
    )
    let date = Calendar.current.date(from: dateComponent)
    return date ?? Date.now
  }

  static var previewTrips: [Trip] {
    [
      BusinessTrip(
        name: "WWDC2026",
        destination: "Cupertino",
        startDate: date(year: 2025, month: 6, day: 9),
        endDate: date(year: 2025, month: 6, day: 13),
        perdiem: 123.45,
        location: Location(latitude: 37.3349, longitude: -122.0090)
      ),
      PersonalTrip(
        name: "Camping!",
        destination: "Yosemite",
        startDate: date(year: 2025, month: 6, day: 27),
        endDate: date(year: 2025, month: 7, day: 1),
        reason: .family,
        location: Location(latitude: 37.8651, longitude: -119.5383)
      ),
      PersonalTrip(
        name: "Bridalveil Falls",
        destination: "Yosemite",
        startDate: date(year: 2025, month: 6, day: 28),
        endDate: date(year: 2025, month: 6, day: 28),
        reason: .family,
        location: Location(latitude: 37.7166, longitude: -119.6465)
      ),
      Trip(
        name: "City Hall",
        destination: "San Francisco",
        startDate: date(year: 2025, month: 7, day: 2),
        endDate: date(year: 2025, month: 7, day: 7),
        location: Location(latitude: 37.7793, longitude: -122.4193)
      ),
    ]
  }
}
