import Dependencies
import Sharing
import SharingGRDB
import StructuredQueries
import SwiftUI

struct ArchivedFactsView: View {
  @SharedReader(.fetchAll(Fact.archived, animation: .default))
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

