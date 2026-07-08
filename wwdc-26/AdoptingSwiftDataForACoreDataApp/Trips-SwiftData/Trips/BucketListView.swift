/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A SwiftUI view that shows the bucket list.
*/

import SwiftData
import SwiftUI

struct BucketListView: View {
  var trip: Trip

  @Environment(\.modelContext) private var modelContext

  @State private var showAddItem = false
  @State private var searchText = ""
  @State private var newItemTitle = ""

  var body: some View {
    TripForm {
      ForEach(filteredBucketList, id: \.self) { item in
        TripGroupBox {
          NavigationLink {
            BucketListItemView(item: item)
          } label: {
            HStack {
              Text(item.title)
              Spacer()
              BucketListItemToggle(item: item)
              #if os(macOS)
                Image(systemName: "chevron.right")
                  .font(.system(.footnote).weight(.semibold))
              #endif
            }
          }
        }
      }
      .onDelete(perform: deleteItems(at:))

      Section {
        TripGroupBox {
          TextField("New item…", text: $newItemTitle)
            .onSubmit {
              addInlineItem()
            }
        }
      } header: {
        Text("Add New Item")
      }
    }
    .searchable(text: $searchText)
    .navigationTitle("Bucket List")
    .toolbar {
      ToolbarItemGroup {
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

  var filteredBucketList: [BucketListItem] {
    if searchText.isEmpty {
      return trip.bucketList
    }

    var descriptor = FetchDescriptor<BucketListItem>()
    let tripName = trip.name
    descriptor.predicate = #Predicate { item in
      item.title.contains(searchText) && tripName == item.trip?.name
    }
    let filteredList = try? modelContext.fetch(descriptor)

    return filteredList ?? []
  }

  private func deleteItems(at offsets: IndexSet) {
    withAnimation {
      offsets.forEach {
        let item = trip.bucketList[$0]
        modelContext.delete(item)
      }
    }
  }

  private func addInlineItem() {
    guard !newItemTitle.isEmpty else { return }
    withAnimation {
      let newItem = BucketListItem(
        title: newItemTitle,
        details: "",
        hasReservation: false,
        isInPlan: false
      )
      modelContext.insert(newItem)
      newItem.trip = trip
      trip.bucketList.append(newItem)
      newItemTitle = ""
    }
  }
}

struct BucketListItemToggle: View {
  @Bindable var item: BucketListItem

  var body: some View {
    Toggle("Bucket list item is in plan", isOn: $item.isInPlan)
      .labelsHidden()
  }
}

#Preview(traits: .sampleData) {
  @Previewable @Query var trips: [Trip]
  NavigationStack {
    BucketListView(trip: trips.first!)
  }
}
