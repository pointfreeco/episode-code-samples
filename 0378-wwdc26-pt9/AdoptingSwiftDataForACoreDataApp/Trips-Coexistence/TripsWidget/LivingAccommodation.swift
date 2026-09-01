/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The model class of a living accommodation.
*/

import SwiftData

@Model
final class LivingAccommodation {
    var address: String
    var placeName: String
    var trip: Trip?

    init(address: String, placeName: String) {
        self.address = address
        self.placeName = placeName
    }
}

extension LivingAccommodation {
    static var preview: LivingAccommodation {
        LivingAccommodation(address: "Yosemite National Park, CA 95389", placeName: "Yosemite National Park")
    }
}
