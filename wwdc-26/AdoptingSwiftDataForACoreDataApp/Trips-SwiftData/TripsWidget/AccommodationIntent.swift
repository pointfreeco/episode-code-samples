/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The app intent for confirming trip accommodations from the widget.
*/

import AppIntents
import SwiftData

struct AccommodationIntent: AppIntent {
    static var title: LocalizedStringResource {
        return "Trip accommodation"
    }
    static var description: IntentDescription {
        return IntentDescription("Confirm trip accommodation.")
    }
    
    @Parameter(title: "Trip name")
    var tripName: String
    
    @Parameter(title: "Trip start date")
    var startDate: Date

    @Parameter(title: "Trip end date")
    var endDate: Date

    init(tripName: String, startDate: Date, endDate: Date) {
        self.tripName = tripName
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init() {
    }

    func perform() async throws -> some IntentResult {
        let modelContext = ModelContext(DataModel.shared.modelContainer)
        modelContext.author = DataModel.TransactionAuthor.widget //"widget"
        
        let fetchDescripor = FetchDescriptor(predicate: #Predicate<Trip> {
            ($0.name == tripName) && ($0.startDate == startDate) && ($0.endDate == endDate)
        })
        guard let trip = try? modelContext.fetch(fetchDescripor).first,
              let livingAccomodation = trip.livingAccommodation else {
            return .result()
        }
        livingAccomodation.isConfirmed = !livingAccomodation.isConfirmed
        do {
            try modelContext.save()
        } catch {
            print("Failed to save model context: \(error)")
        }
        return .result()
    }
}
