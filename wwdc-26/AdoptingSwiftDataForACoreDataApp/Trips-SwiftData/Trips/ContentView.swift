/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI view that shows the main UI.
*/

import SwiftUI
import SwiftData
import MapKit

// MARK: - ContentView

struct ContentView: View {
    enum Segment: String, CaseIterable {
        case all = "All"
        case personal = "Personal"
        case business = "Business"

        var predicate: Predicate<Trip>? {
            switch self {
            case .all: return nil
            case .personal: return #Predicate { $0 is PersonalTrip }
            case .business: return #Predicate { $0 is BusinessTrip }
            }
        }
    }

    enum SortOption: String, CaseIterable {
        case startDate = "Start Date"
        case endDate = "End Date"
        case name = "Name"

        var sortDescriptor: SortDescriptor<Trip> {
            switch self {
            case .startDate: SortDescriptor(\.startDate)
            case .endDate: SortDescriptor(\.endDate)
            case .name: SortDescriptor(\.name)
            }
        }
    }

    enum GroupOption: String, CaseIterable {
        case none = "None"
        case destination = "Destination"

        var sectionKeyPath: KeyPath<Trip, String>? {
            switch self {
            case .none: nil
            case .destination: \.destination
            }
        }
    }

    @State private var selection: Trip?
    @State private var searchText: String = ""
    @State private var selectedSegment: Segment = .all
    @State private var sortOption: SortOption = .startDate
    @State private var groupOption: GroupOption = .none
    @Environment(\.scenePhase) private var scenePhase
    @State private var showAddTrip = false
    @State private var newTripSegment: Segment = .personal
    @State private var tripCount = 0
    @State private var showInspector = false
    @State private var unreadTripIdentifiers: [PersistentIdentifier] = []

    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        if horizontalSizeClass == .compact {
            compactLayout
        } else {
            regularLayout
        }
    }

    private var tripList: some View {
        TripListView(
            selection: $selection,
            segment: $selectedSegment,
            tripCount: $tripCount,
            unreadTripIdentifiers: $unreadTripIdentifiers,
            searchText: searchText,
            sectionBy: groupOption.sectionKeyPath,
            sortDescriptor: sortOption.sortDescriptor
        )
    }

    // MARK: - iPhone (Compact) Layout

    private var compactLayout: some View {
        TabView {
            Tab("Trips", systemImage: "list.bullet") {
                NavigationStack {
                    tripList
                        .navigationDestination(item: $selection) { trip in
                            TripDetailView(trip: trip)
                        }
                        .searchable(text: $searchText)
                        .toolbar {
                            toolbarItems
                        }
                }
            }
            Tab("Map", systemImage: "map") {
                NavigationStack {
                    TripMap(selection: $selection)
                        .toolbar {
                            mapToolbarItems
                        }
                }
            }
        }
        .sheet(isPresented: $showAddTrip) {
            NavigationStack {
                AddTripView(newTripSegment: $newTripSegment)
            }
        }
    }

    // MARK: - iPad / Mac (Regular) Layout

    private var regularLayout: some View {
        NavigationSplitView {
            tripList
            .searchable(text: $searchText)
            .toolbar {
                toolbarItems
            }
            .navigationSplitViewColumnWidth(min: 280, ideal: 350)
        } detail: {
            TripMap(selection: $selection)
                .inspector(isPresented: $showInspector) {
                    if let selection {
                        TripDetailView(trip: selection)
                            .scrollContentBackground(.hidden)
                    }
                }
        }
        .onChange(of: selection) { _, newValue in
            showInspector = newValue != nil
        }
        .sheet(isPresented: $showAddTrip) {
            NavigationStack {
                AddTripView(newTripSegment: $newTripSegment)
            }
        }
        .onChange(of: scenePhase) { _, newValue in
            Task {
                if newValue == .active {
                    unreadTripIdentifiers += await DataModel.shared.findUnreadTripIdentifiers()
                } else {
                    // Persist the unread trip identifiers for the next launch session.
                    let tripIdentifiers = unreadTripIdentifiers
                    await DataModel.shared.setUnreadTripIdentifiersInUserDefaults(tripIdentifiers)
                }
            }
        }
        #if os(macOS)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            Task {
                unreadTripIdentifiers += await DataModel.shared.findUnreadTripIdentifiers()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)) { _ in
            Task {
                let tripIdentifiers = unreadTripIdentifiers
                await DataModel.shared.setUnreadTripIdentifiersInUserDefaults(tripIdentifiers)
            }
        }
        #endif
    }
}

// MARK: - Toolbar

extension ContentView {
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            filterMenu
            if selectedSegment == .all {
                addTripMenu
            } else {
                addTripButton
            }
        }
    }

    @ToolbarContentBuilder
    private var mapToolbarItems: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            segmentFilterMenu
            if selectedSegment == .all {
                addTripMenu
            } else {
                addTripButton
            }
        }
    }

    private var segmentFilterMenu: some View {
        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
            ForEach(Segment.allCases, id: \.self) { segment in
                Button {
                    selectedSegment = segment
                } label: {
                    if segment == selectedSegment {
                        Label(segment.rawValue, systemImage: "checkmark")
                    } else {
                        Text(segment.rawValue)
                    }
                }
            }
        }
    }

    private var filterMenu: some View {
        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
            Section {
                ForEach(Segment.allCases, id: \.self) { segment in
                    Button {
                        selectedSegment = segment
                    } label: {
                        if segment == selectedSegment {
                            Label(segment.rawValue, systemImage: "checkmark")
                        } else {
                            Text(segment.rawValue)
                        }
                    }
                }
            }
            Section("Sort By") {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button {
                        sortOption = option
                    } label: {
                        if option == sortOption {
                            Label(option.rawValue, systemImage: "checkmark")
                        } else {
                            Text(option.rawValue)
                        }
                    }
                }
            }
            Section("Group By") {
                ForEach(GroupOption.allCases, id: \.self) { option in
                    Button {
                        groupOption = option
                    } label: {
                        if option == groupOption {
                            Label(option.rawValue, systemImage: "checkmark")
                        } else {
                            Text(option.rawValue)
                        }
                    }
                }
            }
        }
    }

    private var addTripMenu: some View {
        Menu("Add Trip", systemImage: "plus") {
            let segments = Segment.allCases.filter { $0 != .all }
            ForEach(segments, id: \.self) { segment in
                Button(segment.rawValue) {
                    newTripSegment = segment
                    showAddTrip = true
                }
            }
        }
    }

    private var addTripButton: some View {
        Button {
            newTripSegment = selectedSegment
            showAddTrip = true
        } label: {
            Label("Add trip", systemImage: "plus")
        }
    }
}

#Preview(traits: .sampleData) {
    ContentView()
}

