/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI view that adds an item to the bucket list.
*/

import SwiftUI

struct AddBucketListItemView: View {
    var trip: Trip
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var hasReservations: Bool = false
    @State private var isInPlan: Bool = false
    
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
            let newItem = BucketListItem(context: viewContext)
            newItem.title = title
            newItem.details = details
            newItem.isInPlan = isInPlan
            newItem.hasReservation = hasReservations
            newItem.trip = trip
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            /**
             Real-world apps should consider better handling the error in a way that fits their UI.
            */
            let nsError = error as NSError
            fatalError("Failed to save Core Data changes: \(nsError)")
        }
    }
}

#Preview {
    AddBucketListItemView(trip: .preview)
        .environment(\.managedObjectContext,
                      PersistenceController.preview.container.viewContext)
}
