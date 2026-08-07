import SwiftUI
import SQLiteData

struct BucketListItemsView: View {
  @FetchAll(
    BucketListItem
      .order(by: \.title)
      .join(Trip.all) { $0.tripID.eq($1.id) }
      .select { item, _ in item },
    sectionBy: { _, trip in trip.name }
  )
  var items

  var body: some View {
    List {
      ForEach($items.sections) { section in
        Section {
          ForEach(section) { item in
            VStack(alignment: .leading) {
              Text(item.title)
                .font(.headline)
              if !item.details.isEmpty {
                Text(item.details)
                  .font(.subheadline)
                  .foregroundStyle(.secondary)
              }
              HStack {
                if item.hasReservation {
                  Label("Reserved", systemImage: "checkmark.seal")
                }
                if item.isInPlan {
                  Label("In Plan", systemImage: "calendar")
                }
              }
              .font(.caption)
              .foregroundStyle(.tint)
            }
          }
        } header: {
          Text(section.name)
        }
      }
    }
    .navigationTitle("Bucket List")
  }
}

#Preview {
  let _ = prepareDependencies {
    try! $0.bootstrapDatabase()
    try! $0.seedDatabaseForPreviews()
  }
  NavigationStack {
    BucketListItemsView()
  }
}
