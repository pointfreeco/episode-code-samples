/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The model class of a bucket list item.
*/

import Foundation

extension CDBucketListItem {
    var displayTitle: String {
        guard let title, !title.isEmpty
        else { return "Untitled bucket list item" }
        return title
    }
    
    var displayDetails: String {
        guard let details, !details.isEmpty
        else { return "No details" }
        return details
    }
    
    static var preview: CDBucketListItem {
        let result = PersistenceController.preview
        let viewContext = result.container.viewContext
        let item = CDBucketListItem(context: viewContext)
        item.title = "A bucket list item title"
        item.details = "Details of my bucket list item"
        item.hasReservation = true
        item.isInPlan = true
        return item
    }
}
