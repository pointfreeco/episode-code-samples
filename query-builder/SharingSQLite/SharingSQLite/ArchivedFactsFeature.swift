import Dependencies
import Sharing
import SharingGRDB
import SwiftUI

struct ArchivedFactsView: View {
  @SharedReader(.fetchAll(sql: #"SELECT * FROM "facts" WHERE "isArchived""#, animation: .default))
  var archivedFacts: [Fact]
  @Dependency(\.defaultDatabase) var database

  var body: some View {
    Form {
      ForEach(archivedFacts) { fact in
        Text(fact.value)
          .swipeActions {
            Button("Unarchive") {
              do {
                try database.write { db in
                  var fact = fact
                  fact.isArchived = false
                  try fact.update(db)
                }
              } catch {
                reportIssue(error)
              }
            }
            .tint(.blue)
            Button("Delete", role: .destructive) {
              do {
                _ = try database.write { db in
                  try fact.delete(db)
                }
              } catch {
                reportIssue(error)
              }
            }
          }
      }
    }
    .navigationTitle("Archived facts")
  }
}

#Preview("Archived facts") {
  let _ = prepareDependencies {
    $0.defaultDatabase = .appDatabase
    let _ = try! $0.defaultDatabase.write { db in
      for index in 1...10 {
        _ = try Fact(
          isArchived: index.isMultiple(of: 2),
          number: index,
          savedAt: Date(),
          value: "\(index) was a good number."
        )
        .inserted(db)
      }
    }
  }

  NavigationStack {
    ArchivedFactsView()
  }
}
