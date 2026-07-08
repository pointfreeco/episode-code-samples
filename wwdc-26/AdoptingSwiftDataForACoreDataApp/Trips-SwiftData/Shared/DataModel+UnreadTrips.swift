/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
An exention of DataModel that provides supports for unread trips.
*/

import SwiftUI
import SwiftData

extension DataModel {
    struct UserDefaultsKey {
        static let unreadTripIdentifiers = "unreadTripIdentifiers"
        static let historyToken = "historyToken"
    }
    /**
     Getter and setter of the unread trip identifiers in the standard `UserDefaults`. This makes the identifiers avaiable for the next launch session.
     DataModel is isolated, and `setUnreadTripIdentifiersInUserDefaults` provides a way to set the value using `await`.
     */
    var unreadTripIdentifiersInUserDefaults: [PersistentIdentifier] {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.unreadTripIdentifiers) else {
            return []
        }
        let tripIdentifers = try? JSONDecoder().decode([PersistentIdentifier].self, from: data)
        return tripIdentifers ?? []
    }
    
    func setUnreadTripIdentifiersInUserDefaults(_ newValue: [PersistentIdentifier]) {
        let data = try? JSONEncoder().encode(newValue)
        UserDefaults.standard.set(data, forKey: UserDefaultsKey.unreadTripIdentifiers)
    }
    
    /**
     Find the unread trip identifiers by parsing the history.
     */
    func findUnreadTripIdentifiers() -> [PersistentIdentifier] {
        let unreadTrips = findUnreadTrips()
        return Array(unreadTrips).map { $0.persistentModelID }
    }
    
    private func findUnreadTrips() -> Set<Trip> {
        let tokenData = UserDefaults.standard.data(forKey: UserDefaultsKey.historyToken)
        
        var historyToken: DefaultHistoryToken? = nil
        if let data = tokenData {
            historyToken = try? JSONDecoder().decode(DefaultHistoryToken.self, from: data)
        }
        let transactions = findTransactions(after: historyToken, author: TransactionAuthor.widget)
        let (unreadTrips, newToken) = findTrips(in: transactions)
        
        if let token = newToken {
            let newTokenData = try? JSONEncoder().encode(token)
            UserDefaults.standard.set(newTokenData, forKey: UserDefaultsKey.historyToken)
        }
        return unreadTrips
    }
    
    private func findTransactions(after historyToken: DefaultHistoryToken?, author: String) -> [DefaultHistoryTransaction] {
        var historyDescriptor = HistoryDescriptor<DefaultHistoryTransaction>()
        if let token = historyToken {
            historyDescriptor.predicate = #Predicate { transaction in
                (transaction.token > token) && (transaction.author == author)
            }
        }
        var transactions: [DefaultHistoryTransaction] = []
        let taskContext = ModelContext(modelContainer)
        do {
            transactions = try taskContext.fetchHistory(historyDescriptor)
        } catch let error {
            print(error)
        }
        return transactions
    }
    
    private func findTrips(in transactions: [DefaultHistoryTransaction]) -> (Set<Trip>, DefaultHistoryToken?) {
        let taskContext = ModelContext(modelContainer)
        var resultTrips: Set<Trip> = []
        
        for transaction in transactions {
            for change in transaction.changes where isLivingAccommodationChange(change: change) {
                /**
                 Fetch the trip using the model ID of the changed living accommodation.
                 */
                let modelID = change.changedPersistentIdentifier
                let fetchDescriptor = FetchDescriptor<Trip>(predicate: #Predicate {
                    $0.livingAccommodation?.persistentModelID == modelID
                })
                if let matchedTrip = try? taskContext.fetch(fetchDescriptor).first {
                    switch change {
                    case .insert:
                        resultTrips.insert(matchedTrip)
                    case .update:
                        resultTrips.update(with: matchedTrip)
                    case .delete:
                        resultTrips.remove(matchedTrip)
                    default:
                        break
                    }
                }
            }
        }
        return (resultTrips, transactions.last?.token)
    }
    
    private func isLivingAccommodationChange(change: HistoryChange) -> Bool {
        switch change {
        case .insert(let historyInsert):
            if historyInsert is any HistoryInsert<LivingAccommodation> {
                return true
            }
        case .update(let historyUpdate):
            if historyUpdate is any HistoryUpdate<LivingAccommodation> {
                return true
            }
        case .delete(let historyDelete):
            if historyDelete is any HistoryDelete<LivingAccommodation> {
                return true
            }
        default:
            break
        }
        return false
    }
}
