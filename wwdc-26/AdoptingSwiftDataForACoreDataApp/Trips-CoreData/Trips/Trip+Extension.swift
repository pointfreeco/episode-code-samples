/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The model class of trips.
*/

import SwiftUI

extension Trip {
    var color: Color {
        let seed = UInt64(bitPattern: Int64(name?.hashValue ?? 8))
        return Color(
            red: Double(seed & 0xFF) / 255,
            green: Double((seed >> 8) & 0xFF) / 255,
            blue: Double((seed >> 16) & 0xFF) / 255
        )
    }

    var displayName: String {
        guard let name, !name.isEmpty
        else { return "Untitled Trip" }
        return name
    }

    var displayDestination: String {
        guard let destination, !destination.isEmpty
        else { return "Untitled Destination" }
        return destination
    }

    static var preview: Trip {
        let result = PersistenceController.preview
        let viewContext = result.container.viewContext
        let trip = Trip(context: viewContext)
        trip.name = "Trip Name"
        trip.destination = "Trip destination"
        trip.startDate = .now
        trip.endDate = .now.addingTimeInterval(4 * 3600)
        return trip
    }
}
