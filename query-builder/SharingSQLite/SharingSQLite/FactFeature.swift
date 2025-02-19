import Combine
import Dependencies
import GRDB
import IssueReporting
import Sharing
import SharingGRDB
import StructuredQueries
import SwiftUI

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

  @ObservationIgnored @SharedReader(.fetchOne(sql: #"SELECT count(*) FROM "facts" WHERE "isArchived""#, animation: .default))
  var archivedFactsCount = 0

  @ObservationIgnored @SharedReader(value: []) var favoriteFacts: [Fact]

  @ObservationIgnored @SharedReader(.fetchOne(sql: #"SELECT count(*) FROM "facts" WHERE NOT "isArchived""#, animation: .default))
  var unarchivedFactsCount = 0

  @ObservationIgnored @Shared(.count) var count
  @ObservationIgnored @Shared(.ordering) var ordering

  @ObservationIgnored @Dependency(FactClient.self) var factClient
  @ObservationIgnored @Dependency(\.defaultDatabase) var database
  @ObservationIgnored @Dependency(\.date.now) var now
  @ObservationIgnored @Dependency(\.uuid) var uuid

  var cancellables: Set<AnyCancellable> = []

  init() {
    $ordering.publisher.sink { [weak self] ordering in
      guard let self else { return }
      Task {
        try await $favoriteFacts.load(.fetch(Facts(ordering: ordering), animation: .default))
      }
    }
    .store(in: &cancellables)

    _ = Fact.archived
    _ = Fact.archived.count()
    _ = Fact.unarchived.count()
    _ = Fact.unarchived.order {
      switch ordering {
      case .number: ($0.number, $0.savedAt.descending())
      case .savedAt: $0.savedAt.descending()
      }
    }

    print("===")
    let query1 = Attendee.withSyncUp
      .where { attendees, _ in attendees.name.collate(.nocase).contains("blob") }
    print(query1.queryFragment)
    print("---")
    let query2 = SyncUp.withAttendeeCount
      .where { syncUps, _ in syncUps.title.collate(.nocase).contains("morning") }
    print(query2.queryFragment)
  }

  @Table
  struct SyncUp {
    static let withAttendeeCount = group(by: \.id)
      .join(Attendee.all()) { $0.id == $1.syncUpID }
      .select {
        SyncUpWithAttendeeCount.Columns(
          attendeeCount: $1.id.count(),
          syncUp: $0
        )
      }

    let id: Int
    var duration: Int
    var title: String
  }

  @Table
  struct Attendee {
    static let withSyncUp = join(SyncUp.all()) { $0.syncUpID == $1.id }
      .select(AttendeeAndSyncUp.Columns.init)

    let id: Int
    var name: String
    var syncUpID: Int
  }

  @Selection
  struct AttendeeAndSyncUp {
    let attendee: FactFeatureModel.Attendee
    let syncUp: FactFeatureModel.SyncUp
  }

  @Selection
  struct SyncUpWithAttendeeCount {
    let attendeeCount: Int
    let syncUp: FactFeatureModel.SyncUp
  }

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

  struct Facts: FetchKeyRequest {
    let ordering: Ordering
    func fetch(_ db: Database) throws -> [Fact] {
      let query = Fact
        .filter(!Column("isArchived"))
        .order(ordering.orderingTerm)
      return try query.fetchAll(db)
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
