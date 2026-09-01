/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
An actor that provides a SwiftData model container for the whole app and widget,
 and implements actor-isolated tasks like SwiftData history processing.
*/

import SwiftData
import SwiftUI

actor DataModel {
  struct TransactionAuthor {
    static let widget = "widget"
  }

  static let shared = DataModel()

  private static let container: ModelContainer = {
    let modelContainer: ModelContainer
    do {
      modelContainer = try ModelContainer(
        for: Trip.self,
        PersonalTrip.self,
        BusinessTrip.self
      )
    } catch {
      fatalError("Failed to create the model container: \(error)")
    }
    return modelContainer
  }()

  nonisolated var modelContainer: ModelContainer {
    Self.container
  }
}
