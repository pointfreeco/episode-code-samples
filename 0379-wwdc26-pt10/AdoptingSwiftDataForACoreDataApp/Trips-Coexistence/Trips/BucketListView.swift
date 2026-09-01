/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI view that shows the bucket list.
*/

import SwiftUI
import CoreData

struct BucketListView: View {
    var trip: CDTrip
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest private var bucketList: FetchedResults<CDBucketListItem>
    
    @State private var showAddItem = false
    @State private var searchText = ""
    
    init(trip: CDTrip) {
        self.trip = trip
        self._bucketList = FetchRequest<CDBucketListItem>(sortDescriptors: [SortDescriptor(\.title)],
                                                          predicate: NSPredicate(format: "trip.name = %@", trip.name ?? ""))
    }
    
    var body: some View {
        TripForm {
            ForEach(bucketList) { item in
                TripGroupBox {
                    NavigationLink {
                        BucketListItemView(item: item)
                    } label: {
                        HStack {
                            Text(item.title ?? "Untitled Bucket List Item")
                            Spacer()
                            BucketListItemToggle(item: item)
                            #if os(macOS)
                            Image(systemName: "chevron.right").font(Font.system(.footnote).weight(.semibold))
                            #endif
                        }
                    }
                }
            }
            .onDelete(perform: deleteItems(at:))
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { oldValue, newValue in
            bucketList.nsPredicate = newValue.isEmpty ? nil : searchPredicate
        }
        .navigationTitle("Bucket List")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
                    .disabled(bucketList.isEmpty)
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                    showAddItem.toggle()
                } label: {
                    Label("Add", systemImage: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $showAddItem) {
            NavigationStack {
                AddBucketListItemView(trip: trip)
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
    var searchPredicate: NSPredicate {
        let bucketListPredicate = NSPredicate(format: "ANY title CONTAINS[c] %@", searchText)
        let tripPredicate = NSPredicate(format: "trip.name = %@", trip.name ?? "")
        let compoundPredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [bucketListPredicate, tripPredicate])
        return compoundPredicate
    }
    
    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            offsets.map { bucketList[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError)")
        }
    }
}

struct BucketListItemToggle: View {
    var item: CDBucketListItem
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isOn: Bool = false
    
    var body: some View {
        Toggle("Bucket list item is in plan", isOn: $isOn)
            .labelsHidden()
            .onAppear { isOn = item.isInPlan }
            .onChange(of: isOn) { oldValue, newValue in
                item.isInPlan = newValue
                saveContext()
            }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError)")
        }
    }
}

#Preview {
    BucketListView(trip: .preview)
        .environment(\.managedObjectContext,
                      PersistenceController.preview.container.viewContext)
}
