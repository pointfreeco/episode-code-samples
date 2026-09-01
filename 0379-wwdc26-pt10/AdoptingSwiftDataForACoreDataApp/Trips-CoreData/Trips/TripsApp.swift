/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The SwiftUI app.
*/

import SwiftUI

@main
struct TripsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                              persistenceController.container.viewContext)
        }
    }
}
