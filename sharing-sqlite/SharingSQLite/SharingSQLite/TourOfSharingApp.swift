import Dependencies
import GRDB
import SwiftUI

@main
struct SharingSQLiteApp: App {
  static let model = FactFeatureModel()

  init() {
    prepareDependencies {
      $0.defaultDatabase = .appDatabase

      let query = Fact
        .filter(!Column("isArchived"))
        .order(Ordering.number.orderingTerm)

      print("---")
      try! $0.defaultDatabase.read { db in
        print(
          "👉",
          try query.makePreparedRequest(db).statement.description
        )
      }
      print("---")
    }
  }

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        FactFeatureView(model: Self.model)
      }
    }
  }
}
