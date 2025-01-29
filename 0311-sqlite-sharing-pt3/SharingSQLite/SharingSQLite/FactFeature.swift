import Combine
import Dependencies
import GRDB
import IssueReporting
import Sharing
import SwiftUI

struct LegacyFact: Codable, Equatable, Identifiable {
  let id: UUID
  var number: Int
  var savedAt: Date
  var value: String
}

enum Ordering: String, CaseIterable {
  case number = "Number", savedAt = "Saved at"

  var orderingTerm: any SQLOrderingTerm {
    switch self {
    case .number:
      Column("number")
    case .savedAt:
      Column("savedAt").desc
    }
  }
}

@Observable
@MainActor
class FactFeatureModel {
  var fact: String?
  var isArchivedFactsPresented = false

  @ObservationIgnored @SharedReader(.fetchOne(#"SELECT count(*) FROM "facts" WHERE "isArchived""#))
  var archivedFactsCount = 0

  @ObservationIgnored @SharedReader(.fetchAll(#"SELECT * FROM "facts" WHERE NOT "isArchived" LIMIT 1"#))
  var favoriteFacts: [Fact]

  @ObservationIgnored @SharedReader(.fetchOne(#"SELECT count(*) FROM "facts" WHERE NOT "isArchived""#))
  var unarchivedFactsCount = 0

  // @Shared(.favoriteFacts) var favoriteFacts
  // @Shared(.fileStorage(.documentsDirectory.appending(path: "favorite-facts.json"))) var favoriteFacts: [Fact] = []

  // @SharedReader(.fetchAll(#"SELECT * FROM "facts""#)) var favoriteFacts: [Fact] = []
  // @Shared(.fetchAll(sort: \Fact.number, order: .reverse, limit: 3, offset: 3)) var favoritesFacts
  // @Query(sort: \.number, order: .reverse) var favoriteFacts

  @ObservationIgnored @Shared(.count) var count
  @ObservationIgnored @Shared(.ordering) var ordering

  @ObservationIgnored @Dependency(FactClient.self) var factClient
  @ObservationIgnored @Dependency(\.defaultDatabase) var database
  @ObservationIgnored @Dependency(\.date.now) var now
  @ObservationIgnored @Dependency(\.uuid) var uuid

  func incrementButtonTapped() {
    $count.withLock { $0 += 1 }
    fact = nil
  }

  func decrementButtonTapped() {
    $count.withLock { $0 -= 1 }
    fact = nil
  }

  func getFactButtonTapped() async {
    do {
      let fact = try await factClient.fetch(count)
      withAnimation {
        self.fact = fact
      }
    } catch {
      reportIssue(error)
    }
  }

  func favoriteFactButtonTapped() {
    guard let fact else { return }
    withAnimation {
      self.fact = nil
      do {
        try database.write { db in
          _ = try Fact(number: count, savedAt: now, value: fact)
            .inserted(db)
        }
      } catch {
        reportIssue(error)
      }
    }
  }

  func archive(fact: Fact) {
    do {
      try database.write { db in
        var fact = fact
        fact.isArchived = true
        try fact.update(db)
      }
    } catch {
      reportIssue(error)
    }
  }

  func delete(fact: Fact) {
    do {
      try database.write { db in
        _ = try fact.delete(db)
      }
    } catch {
      reportIssue(error)
    }
  }
}

struct FactFeatureView: View {
  @Bindable var model: FactFeatureModel

  var body: some View {
    Form {
      Section {
        Text("\(model.count)")
        Button("Decrement") { model.decrementButtonTapped() }
        Button("Increment") { model.incrementButtonTapped() }
      }
      Section {
        Button("Get fact") {
          Task {
            await model.getFactButtonTapped()
          }
        }
        if let fact = model.fact {
          HStack {
            Text(fact)
            Button {
              model.favoriteFactButtonTapped()
            } label: {
              Image(systemName: "star")
            }
          }
        }
      }
      if !model.favoriteFacts.isEmpty {
        Section {
          ForEach(model.favoriteFacts) { fact in
            Text(fact.value)
              .swipeActions {
                Button("Archive") {
                  model.archive(fact: fact)
                }
                .tint(.blue)
                Button("Delete", role: .destructive) {
                  model.delete(fact: fact)
                }
              }
          }
        } header: {
          HStack {
            Text("Favorites (\(model.unarchivedFactsCount))")
            Spacer()
            Picker("Sort", selection: Binding(model.$ordering)) {
              Section {
                ForEach(Ordering.allCases, id: \.self) { ordering in
                  Text(ordering.rawValue)
                }
              } header: {
                Text("Sort by:")
              }
            }
            .textCase(nil)
          }
        }
      }
    }
    .toolbar {
      if model.archivedFactsCount > 0 {
        ToolbarItem {
          Button("Archived facts (\(model.archivedFactsCount))") {
            model.isArchivedFactsPresented = true
          }
        }
      }
    }
    .sheet(isPresented: $model.isArchivedFactsPresented) {
      NavigationStack {
        ArchivedFactsView()
      }
      .presentationDetents([.fraction(0.4), .fraction(0.9)])
    }
  }
}

extension SharedKey where Self == AppStorageKey<Int>.Default {
  static var count: Self {
    Self[.appStorage("count"), default: 0]
  }
}

extension SharedKey where Self == FileStorageKey<[LegacyFact]>.Default {
  static var favoriteFacts: Self {
    Self[.fileStorage(.documentsDirectory.appending(component: "favorite-facts.json")), default: []]
  }
}

extension SharedKey where Self == AppStorageKey<Ordering>.Default {
  static var ordering: Self {
    Self[.appStorage("ordering"), default: .number]
  }
}

#Preview {
  let _ = prepareDependencies {
    $0.defaultDatabase = .appDatabase
  }
  FactFeatureView(model: FactFeatureModel())
}
