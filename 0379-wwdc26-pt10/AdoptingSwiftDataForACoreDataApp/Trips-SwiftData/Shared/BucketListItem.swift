/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The model class of bucket list items.
*/

import Foundation
import SwiftData

@Model class BucketListItem {
  var title: String
  var details: String
  var hasReservation: Bool
  var isInPlan: Bool
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
      hasReservation: true,
      isInPlan: true
    )
    item.trip = .preview
    return item
  }

  static var previewBLTs: [BucketListItem] {
    [
      BucketListItem(
        title: "See Half Dome",
        details: "try to climb Half Dome",
        hasReservation: true,
        isInPlan: false
      ),
      BucketListItem(
        title: "Picture at the falls",
        details: "get a lot of them!",
        hasReservation: true,
        isInPlan: false
      ),
    ]
  }
}
