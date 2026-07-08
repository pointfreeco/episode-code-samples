/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI view that adds an item to the bucket list.
*/

import SwiftUI
import SwiftData

struct AddBucketListItemView: View {
    @Environment(\.modelContext) private var modelContext
    var trip: Trip
    
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var hasReservations = false
    @State private var isInPlan = false

    var body: some View {
        NavigationStack {
            TripForm {
                Section {
                    TripGroupBox {
                        TextField("Enter title here…", text: $title)
                    }
                } header: {
                    Text("Bucket List Item Title")
                }

                Section {
                    VStack(alignment: .leading) {
                        TripGroupBox {
                            TextField("Enter details here…", text: $details)
                        }
                        TripGroupBox {
                            Toggle("Is this activity in the plan?", isOn: $isInPlan)
                            Toggle("Are reservations made?", isOn: $hasReservations)
                        }
                    }
                } header: {
                    Text("Bucket List Item Details")
                }
            }
            .navigationTitle("Add Bucket List Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        addItem()
                        dismiss()
                    }
                }
            }
        }
        .frame(idealWidth: LayoutConstants.sheetIdealWidth,
               idealHeight: LayoutConstants.sheetIdealHeight)
    }

    private func addItem() {
        withAnimation {
            let newItem = BucketListItem(title: title, details: details, hasReservation: hasReservations, isInPlan: isInPlan)
            modelContext.insert(newItem)
            newItem.trip = trip
            trip.bucketList.append(newItem)
        }
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query var trips: [Trip]
    AddBucketListItemView(trip: trips.first!)
}
