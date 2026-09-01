/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A class that sets up the Core Data stack.
*/

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let newTrip = Trip(context: viewContext)
        newTrip.name = "Trip Name"
        newTrip.destination = "Trip destination"
        newTrip.startDate = .now
        newTrip.endDate = .now.addingTimeInterval(4 * 3600)
        
        let newBucketListItem = BucketListItem(context: viewContext)
        newBucketListItem.title = "A bucket list item title"
        newBucketListItem.details = "Details of my bucket list item"
        newBucketListItem.hasReservation = true
        newBucketListItem.isInPlan = true
        newBucketListItem.trip = newTrip
        
        let livingAccommodations = LivingAccommodation(context: viewContext)
        livingAccommodations.address = "A new address"
        livingAccommodations.placeName = "A place name"
        livingAccommodations.trip = newTrip
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Trips")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions.first!.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
