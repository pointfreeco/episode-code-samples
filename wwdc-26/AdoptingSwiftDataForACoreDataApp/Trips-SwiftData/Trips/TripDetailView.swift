/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI view that shows the details of a trip.
*/

import SwiftUI
import SwiftData
import MapKit

struct TripDetailView: View {
    @Bindable var trip: Trip
    @Environment(\.modelContext) private var modelContext
    @State private var newBucketListItemTitle = ""
    @State private var mapItem: MKMapItem?
    
    var body: some View {
        List {
            #if os(macOS)
            tripInfoViewForMac
                .navigationTitle(Text("Trip Details"))
                .listRowBackground(Color.clear)
            #else
            tripInfoViewForiOS
                .navigationTitle(Text("Trip Details"))
            #endif
        }
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
                TextField("Trip Name", text: $trip.name)
                LocationSearchView(destination: $trip.destination, mapItem: $mapItem)
                    .onChange(of: mapItem) { _, newItem in
                        guard let newItem else { return }
                        trip.location = Location(
                            latitude: newItem.location.coordinate.latitude,
                            longitude: newItem.location.coordinate.longitude
                        )
                        trip.mapItemIdentifier = newItem.identifier
                    }
            }
            TripGroupBox {
                TripDatesPicker(trip: trip)
            }
        } header: {
            Text(trip.displayName)
                .font(.title)
        }
    }

    @ViewBuilder
    private var livingAccommodationsSectionForMac: some View {
        Section("Living Accommodations") {
            TripGroupBox {
                TextField("Place name", text: livingAccommodationPlaceName)
                TextField("Address", text: livingAccommodationAddress)
                Toggle("Confirmed", isOn: livingAccommodationConfirmed)
            }
        }
    }

    @ViewBuilder
    private var bucketListSectionForMac: some View {
        Section("Bucket List") {
            ForEach(trip.bucketList, id: \.self) { item in
                TripGroupBox {
                    HStack {
                        Text(item.title)
                        Spacer()
                        BucketListItemToggle(item: item)
                    }
                }
            }
            TripGroupBox {
                TextField("Add new item…", text: $newBucketListItemTitle)
                    .onSubmit {
                        guard !newBucketListItemTitle.isEmpty else { return }
                        withAnimation {
                            let newItem = BucketListItem(
                                title: newBucketListItemTitle,
                                details: "",
                                hasReservation: false,
                                isInPlan: false)
                            modelContext.insert(newItem)
                            newItem.trip = trip
                            trip.bucketList.append(newItem)
                            newBucketListItemTitle = ""
                        }
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
                livingAccommodationInfoView
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

    @ViewBuilder
    private var livingAccommodationInfoView: some View {
        if let livingAccommodation = trip.livingAccommodation {
            Text(livingAccommodation.displayPlaceName)
            Text(livingAccommodation.displayAddress)
            Divider()
            HStack {
                Text("Confirmation")
                Spacer()
                Image(systemName: livingAccommodation.isConfirmed ? "checkmark.circle" : "circle")
            }
        } else {
            Text("<No Living Accommodations>")
        }
    }

    private var livingAccommodationPlaceName: Binding<String> {
        Binding(
            get: { trip.livingAccommodation?.placeName ?? "" },
            set: { newValue in
                ensureLivingAccommodation()
                trip.livingAccommodation?.placeName = newValue
            }
        )
    }

    private var livingAccommodationAddress: Binding<String> {
        Binding(
            get: { trip.livingAccommodation?.address ?? "" },
            set: { newValue in
                ensureLivingAccommodation()
                trip.livingAccommodation?.address = newValue
            }
        )
    }

    private var livingAccommodationConfirmed: Binding<Bool> {
        Binding(
            get: { trip.livingAccommodation?.isConfirmed ?? false },
            set: { newValue in
                ensureLivingAccommodation()
                trip.livingAccommodation?.isConfirmed = newValue
            }
        )
    }

    private func ensureLivingAccommodation() {
        if trip.livingAccommodation == nil {
            let accommodation = LivingAccommodation(address: "", placeName: "", isConfirmed: false)
            accommodation.trip = trip
        }
    }
}
