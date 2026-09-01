/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The model class of bucket list items.
*/

import SwiftData

@Model
final class BucketListItem {
    var details: String
    var hasReservation: Bool
    var isInPlan: Bool
    var title: String
    var trip: Trip?
    
    init(title: String, details: String, hasReservation: Bool, isInPlan: Bool) {
        self.title = title
        self.details = details
        self.hasReservation = hasReservation
        self.isInPlan = isInPlan
    }
}

extension BucketListItem {
    static var preview: BucketListItem {
        let item = BucketListItem(
            title: "A bucket list item title",
            details: "Details of my bucket list item",
            hasReservation: true, isInPlan: true)
        item.trip = .preview
        return item
    }
}
