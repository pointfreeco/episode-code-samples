/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The model class of trips.
*/

import Foundation
import SwiftData
import Observation

@Model
final class Trip {
    var destination: String
    var endDate: Date
    var name: String
    var startDate: Date
    
    @Relationship(deleteRule: .cascade, inverse: \BucketListItem.trip)
    var bucketList: [BucketListItem]
    
    @Relationship(deleteRule: .cascade, inverse: \LivingAccommodation.trip)
    var livingAccommodation: LivingAccommodation?
    
    init(name: String, destination: String, startDate: Date = .now, endDate: Date = .distantFuture) {
        self.name = name
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.bucketList = []
    }
}

extension Trip {
    static var preview: Trip {
        Trip(name: "Trip Name", destination: "Trip destination",
             startDate: .now, endDate: .now.addingTimeInterval(4 * 3600))
    }
}
