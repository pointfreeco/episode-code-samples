/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI list item view that shows trip metadata.
*/

import SwiftData
import SwiftUI

struct TripListItem: View {
  var trip: Trip
  let isUnread: Bool

  var body: some View {
    NavigationLink(value: trip) {
      HStack {
        RoundedRectangle(cornerRadius: 8)
          .fill(trip.color/* ?? .yellow*/)
          .frame(width: 64, height: 64)
          .overlay {
            Text(String(trip.displayName.first!))
              .font(.system(size: 48))
              .foregroundStyle(.background)
          }

        Circle()
          .fill(isUnread ? .blue : .clear)
          .frame(width: 8, height: 8)

        VStack(alignment: .leading) {
          Text(trip.displayName)
            .font(.headline)
          Text(trip.displayDestination)
            .font(.subheadline)

          if case (let start?, let end?) = (trip.startDate, trip.endDate) {
            Divider()
            HStack {
              Text(start, style: .date)
              Image(systemName: "arrow.right")
              Text(end, style: .date)
            }
            .font(.caption)
          }
        }
      }
    }
  }
}

#Preview(traits: .sampleData) {
  @Previewable @Query var trips: [Trip]
  List {
    TripListItem(trip: trips.first!, isUnread: true)
  }
}
