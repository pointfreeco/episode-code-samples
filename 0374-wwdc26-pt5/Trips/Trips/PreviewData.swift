import Dependencies
import Foundation
@preconcurrency import MapKit
import SQLiteData

extension DependencyValues {
  func seedDatabaseForPreviews() throws {
    try defaultDatabase.write { db in
      try db.seed {
        Trip.Draft(
          id: UUID(1),
          name: "Cherry Blossom Week",
          destination: "Tokyo, Japan",
          location: Location(latitude: 35.6764, longitude: 139.6500),
          startDate: previewDate(2026, 3, 28),
          endDate: previewDate(2026, 4, 6),
          purpose: .personal(.init(reason: .family)),
          mapItemIdentifier: MKMapItem.Identifier(rawValue: "I63802885C8189B2B")
        )
        BucketListItem.Draft(
          title: "Hanami picnic at Shinjuku Gyoen",
          details: "Arrive early to claim a spot under the somei yoshino trees.",
          isInPlan: true,
          tripID: UUID(1)
        )
        BucketListItem.Draft(
          title: "Sushi counter in Tsukiji",
          details: "Omakase seating for two.",
          hasReservation: true,
          isInPlan: true,
          tripID: UUID(1)
        )
        BucketListItem.Draft(
          title: "Night walk along Meguro River",
          details: "Lanterns line the canal for the full week of the bloom.",
          tripID: UUID(1)
        )
        Trip.Draft(
          name: "Tokyo Client Summit",
          destination: "Tokyo, Japan",
          location: Location(latitude: 35.6764, longitude: 139.6500),
          startDate: previewDate(2026, 9, 14),
          endDate: previewDate(2026, 9, 18),
          purpose: .business(.init(perdiem: 120)),
          mapItemIdentifier: MKMapItem.Identifier(rawValue: "I8A1F03D4E5B6C7D8")
        )
        Trip.Draft(
          id: UUID(2),
          name: "Sabbatical in Paris",
          destination: "Paris, France",
          location: Location(latitude: 48.8566, longitude: 2.3522),
          startDate: previewDate(2026, 4, 1),
          endDate: previewDate(2026, 5, 30),
          purpose: .personal(.init(reason: .wellness)),
          mapItemIdentifier: MKMapItem.Identifier(rawValue: "I1B2C3D4E5F60718")
        )
        BucketListItem.Draft(
          title: "Cooking class in the Marais",
          details: "Three hours, ends with lunch.",
          hasReservation: true,
          isInPlan: true,
          tripID: UUID(2)
        )
        BucketListItem.Draft(
          title: "Day trip to Giverny",
          details: "Monet's gardens are best mid-morning on a weekday.",
          isInPlan: true,
          tripID: UUID(2)
        )
        BucketListItem.Draft(
          title: "Read a book at Shakespeare and Company",
          tripID: UUID(2)
        )
        BucketListItem.Draft(
          title: "Bike the Canal Saint-Martin",
          details: "Rent for the afternoon and follow the water north.",
          tripID: UUID(2)
        )
        Trip.Draft(
          name: "Paris Design Expo",
          destination: "Paris, France",
          location: Location(latitude: 48.8566, longitude: 2.3522),
          startDate: previewDate(2026, 11, 2),
          endDate: previewDate(2026, 11, 6),
          purpose: .business(.init(perdiem: 95)),
          mapItemIdentifier: MKMapItem.Identifier(rawValue: "I29384756ABCDEF01")
        )
        Trip.Draft(
          id: UUID(3),
          name: "Family Reunion Weekend",
          destination: "New York, NY",
          location: Location(latitude: 40.7128, longitude: -74.0060),
          startDate: previewDate(2026, 4, 20),
          endDate: previewDate(2026, 4, 25),
          purpose: .personal(.init(reason: .reunion)),
          mapItemIdentifier: MKMapItem.Identifier(rawValue: "I7C250D2CDCB364A0")
        )
        BucketListItem.Draft(
          title: "Group dinner in Little Italy",
          details: "Table for twelve, needs to be booked well in advance.",
          hasReservation: true,
          isInPlan: true,
          tripID: UUID(3)
        )
        BucketListItem.Draft(
          title: "Ferry to Ellis Island",
          details: "Grandpa wants to look up the family records.",
          isInPlan: true,
          tripID: UUID(3)
        )
        BucketListItem.Draft(
          title: "Cousins' softball game in Central Park",
          tripID: UUID(3)
        )
        Trip.Draft(
          name: "Broadway Pitch Meetings",
          destination: "New York, NY",
          location: Location(latitude: 40.7128, longitude: -74.0060),
          startDate: previewDate(2026, 2, 9),
          endDate: previewDate(2026, 2, 11),
          purpose: .business(.init(perdiem: 80)),
          mapItemIdentifier: MKMapItem.Identifier(rawValue: "I0F1E2D3C4B5A6978")
        )
        Trip.Draft(
          name: "Barclays concert",
          destination: "Brooklyn, NY",
          location: Location(latitude: 40.682732, longitude: -73.975876),
          startDate: previewDate(2026, 2, 9),
          endDate: previewDate(2026, 2, 11),
          purpose: .business(.init(perdiem: 80)),
          mapItemIdentifier: MKMapItem.Identifier(rawValue: "I0F1E2D3C4B5A6978")
        )
      }
    }
  }
}

private func previewDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
  Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
}
