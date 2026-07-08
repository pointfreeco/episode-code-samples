/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The preview sample data actor which provides an in-memory model container.
*/

import SwiftData
import SwiftUI

/// Preview sample data.
struct SampleData: PreviewModifier {
  static func makeSharedContext() throws -> ModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(
      for: Trip.self,
      configurations: config
    )
    SampleData.createSampleData(into: container.mainContext)
    return container
  }

  func body(content: Content, context: ModelContainer) -> some View {
    content.modelContainer(context)
  }

  static func createSampleData(into modelContext: ModelContext) {
    Task { @MainActor in
      let sampleDataTrips: [Trip] = Trip.previewTrips
      let sampleDataLA: [LivingAccommodation] = LivingAccommodation.preview
      let sampleDataBLT: [BucketListItem] = BucketListItem.previewBLTs
      let sampleData: [any PersistentModel] =
        sampleDataTrips + sampleDataLA + sampleDataBLT
      sampleData.forEach {
        modelContext.insert($0)
      }

      if let firstTrip = sampleDataTrips.first,
        let firstLivingAccommodation = sampleDataLA.first,
        let firstBucketListItem = sampleDataBLT.first
      {
        firstTrip.livingAccommodation = firstLivingAccommodation
        firstTrip.bucketList.append(firstBucketListItem)
      }
      if let lastTrip = sampleDataTrips.last,
        let lastBucketListItem = sampleDataBLT.last
      {
        lastTrip.bucketList.append(lastBucketListItem)
      }
      try? modelContext.save()
    }
  }
}

@available(iOS 18.0, *)
extension PreviewTrait where T == Preview.ViewTraits {
  @MainActor static var sampleData: Self = .modifier(SampleData())
}
