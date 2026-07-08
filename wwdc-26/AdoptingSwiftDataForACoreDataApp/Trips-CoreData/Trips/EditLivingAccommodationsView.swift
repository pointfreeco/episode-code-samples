/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI view that edits living place.
*/

import SwiftUI

struct EditLivingAccommodationsView: View {
    var trip: Trip

    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var placeName = ""
    @State private var address = ""
    
    var body: some View {
        TripForm {
            Section(header: Text("Name of Living Accommodation")) {
                TripGroupBox {
                    TextField(namePlaceholder, text: $placeName)
                }
            }
            
            Section(header: Text("Address of Living Accommodation")) {
                TripGroupBox {
                    TextField(addressPlaceholder, text: $address)
                }
            }
        }
        .background(Color.tripGray)
        .navigationTitle("Edit Living Accommodations")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {
                    addLiving()
                    dismiss()
                }
                .disabled(placeName.isEmpty || address.isEmpty)
            }
        }
        .onAppear {
            placeName = trip.livingAccommodation?.placeName ?? ""
            address = trip.livingAccommodation?.address ?? ""
        }
    }
    
    var namePlaceholder: String {
        trip.livingAccommodation?.placeName ?? "Enter place name here…"
    }
    
    var addressPlaceholder: String {
        trip.livingAccommodation?.address ?? "Enter address here…"
    }
    
    private func addLiving() {
        withAnimation {
            if let livingAccommodation = trip.livingAccommodation {
                livingAccommodation.address = address
                livingAccommodation.placeName = placeName
            } else {
                let newLivingAccommodation = LivingAccommodation(context: viewContext)
                newLivingAccommodation.address = address
                newLivingAccommodation.placeName = placeName
                newLivingAccommodation.trip = trip
            }
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
    EditLivingAccommodationsView(trip: .preview)
        .environment(\.managedObjectContext,
                      PersistenceController.preview.container.viewContext)
}
