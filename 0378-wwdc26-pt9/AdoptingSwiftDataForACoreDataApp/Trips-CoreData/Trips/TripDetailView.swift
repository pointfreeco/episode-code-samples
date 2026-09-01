/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI view that shows the details of a trip.
*/

import SwiftUI
import CoreData

struct TripDetailView: View {
    var trip: Trip
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [.init(\.startDate)])
    private var trips: FetchedResults<Trip>

    @FetchRequest
    private var livingAccommodations: FetchedResults<LivingAccommodation>
    
    @FetchRequest(sortDescriptors: [.init(\.title)])
    private var bucketList: FetchedResults<BucketListItem>
    
    init(trip: Trip) {
        self.trip = trip
        _livingAccommodations = FetchRequest<LivingAccommodation>(
            sortDescriptors: [.init(\.placeName)],
            predicate: NSPredicate(format: "(trip = %@)", trip))
    }
    
    var body: some View {
        List {
            #if os(macOS)
            tripInfoViewForMac
            #else
            tripInfoViewForiOS
            #endif
        }
        .navigationTitle(Text("Trip Details"))
    }

    @ViewBuilder
    private var tripInfoViewForMac: some View {
        tripDetailsSectionForMac
        livingAccommodationsSectionForMac
        bucketListSectionForMac
    }

    @ViewBuilder
    private var tripDetailsSectionForMac: some View {
        Section {
            TripGroupBox {
                HStack {
                    VStack(alignment: .leading) {
                        Text(trip.displayDestination)
                        if case let (start?, end?) = (trip.startDate, trip.endDate) {
                            HStack {
                                Text(start, style: .date)
                                Image(systemName: "arrow.right")
                                Text(end, style: .date)
                            }
                        }
                    }
                    Spacer()
                }
            }
        } header: {
            HStack {
                Text(trip.displayName)
                    .font(.title)
                Spacer()
                NavigationLink {
                    UpdateTripView(trip: trip)
                } label: {
                    Label("Edit", systemImage: "chevron.right").labelStyle(.iconOnly)
                }
            }
        }
    }

    @ViewBuilder
    private var livingAccommodationsSectionForMac: some View {
        Section {
            TripGroupBox {
                HStack {
                    VStack(alignment: .leading) {
                        if let livingAccommodations = livingAccommodations.first(where: { $0.trip == trip }) {
                            Text(livingAccommodations.placeName ?? "No Place")
                            Text(livingAccommodations.address ?? "No Address")
                        } else {
                            Text("<No Living Accommodations>")
                        }
                    }
                    Spacer()
                }
            }
        } header: {
            HStack {
                Text("Living Accommodations").font(.headline)
                Spacer()
                NavigationLink {
                    EditLivingAccommodationsView(trip: trip)
                } label: {
                    Label("Edit", systemImage: "chevron.right").labelStyle(.iconOnly)
                }
            }
        }
    }

    @ViewBuilder
    private var bucketListSectionForMac: some View {
        Section {
        } header: {
            HStack {
                Text("Bucket List").font(.headline)
                Spacer()
                NavigationLink {
                    BucketListView(trip: trip)
                } label: {
                    Label("View", systemImage: "chevron.right").labelStyle(.iconOnly)
                }
            }
        }
    }

    @ViewBuilder
    private var tripInfoViewForiOS: some View {
        VStack(alignment: .leading) {
            Text(trip.displayName)
                .font(.title)
                .bold()
            Text(trip.displayDestination)

            if case let (start?, end?) = (trip.startDate, trip.endDate) {
                HStack {
                    Text(start, style: .date)
                    Image(systemName: "arrow.right")
                    Text(end, style: .date)
                }
            }
        }
        NavigationLink {
            UpdateTripView(trip: trip)
        } label: {
            Text("Change Trip Details")
        }

        Section {
            VStack(alignment: .leading) {
                if let livingAccommodations = livingAccommodations.first(where: { $0.trip == trip }) {
                    Text(livingAccommodations.placeName ?? "No Place")
                    Text(livingAccommodations.address ?? "No Address")
                } else {
                    Text("<No Living Accommodations>")
                }
            }
            NavigationLink {
                EditLivingAccommodationsView(trip: trip)
            } label: {
                Text("Change Living Accommodations")
            }
        } header: {
            Text("Living Accommodations")
        }

        Section {
            NavigationLink {
                BucketListView(trip: trip)
            } label: {
                Text("View Bucket List")
            }
        } header: {
            Text("Bucket List")
        }
    }
}

#Preview {
    TripDetailView(trip: .preview)
        .environment(\.managedObjectContext,
                      PersistenceController.preview.container.viewContext)
}
