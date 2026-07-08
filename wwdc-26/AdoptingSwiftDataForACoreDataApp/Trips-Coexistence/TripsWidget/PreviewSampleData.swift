/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The preview sample data actor which provides an in-memory model container.
*/

import SwiftData
import SwiftUI

/**
 Preview sample data.
 */
actor PreviewSampleData {
    @MainActor
    static var container: ModelContainer = {
        let schema = Schema([Trip.self, BucketListItem.self, LivingAccommodation.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let sampleData: [any PersistentModel] = [
            Trip.preview, BucketListItem.preview, LivingAccommodation.preview
        ]
        sampleData.forEach {
            container.mainContext.insert($0)
        }
        return container
    }()
}
