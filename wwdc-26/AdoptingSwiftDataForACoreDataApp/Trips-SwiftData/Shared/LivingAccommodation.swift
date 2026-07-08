/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The model class of a living accommodation.
*/

import Foundation
import SwiftData

@Model class LivingAccommodation {
    var address: String
    var placeName: String
    var isConfirmed: Bool = false
    var trip: Trip?

    init(address: String, placeName: String, isConfirmed: Bool) {
        self.address = address
        self.placeName = placeName
        self.isConfirmed = isConfirmed
    }
}

extension LivingAccommodation {
    var displayAddress: String {
        address.isEmpty ? "No Address" : address
    }

    var displayPlaceName: String {
        placeName.isEmpty ? "No Place" : placeName
    }
    
    static var preview: [LivingAccommodation] {
        [.init(address: "Yosemite National Park, CA 95389", placeName: "Yosemite", isConfirmed: true)]
    }
}
