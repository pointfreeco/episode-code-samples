/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI view that picks the start and end dates for a trip.
*/
import SwiftUI

struct TripDatesPicker: View {
    @Environment(\.calendar) private var calendar
    @Environment(\.timeZone) private var timeZone
    @Bindable var trip: Trip
    
    private var dateRange: ClosedRange<Date> {
        let start = Date.now
        let components = DateComponents(calendar: calendar,
                                        timeZone: timeZone, year: 1)
        let end = calendar.date(byAdding: components, to: start)!
        return start ... end
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Start Date:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                DatePicker(selection: $trip.startDate,
                           in: dateRange, displayedComponents: .date) {
                    Label("Start Date", systemImage: "calendar")
                }
                .labelsHidden()
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("End Date:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                DatePicker(selection: $trip.endDate,
                           in: dateRange, displayedComponents: .date) {
                    Label("End Date", systemImage: "calendar")
                }
                .labelsHidden()
            }
        }
    }
}
