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
  var favoriteFacts: [Fact] = []

  @ObservationIgnored @Shared(.count) var count
  @ObservationIgnored @Shared(.ordering) var ordering

  let database: DatabaseQueue

  @ObservationIgnored @Dependency(FactClient.self) var factClient
  @ObservationIgnored @Dependency(\.date.now) var now
  @ObservationIgnored @Dependency(\.uuid) var uuid

  init(database: DatabaseQueue) {
    self.database = database
  }

  func onTask() async {
    let sequence = ValueObservation.tracking { [ordering] db in
      try Fact
        .all()
        .order(ordering.orderingTerm)
        .fetchAll(db)
    }
    .values(in: database)
    do {
      for try await facts in sequence {
        favoriteFacts = facts
      }
    } catch {
      reportIssue(error)
    }
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

  func deleteFacts(indexSet: IndexSet) {
    do {
      try database.write { db in
        _ = try Fact.deleteAll(db, ids: indexSet.map { favoriteFacts[$0].id })
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
          }
          .onDelete { indexSet in
            model.deleteFacts(indexSet: indexSet)
          }
        } header: {
          HStack {
            Text("Favorites (\(model.favoriteFacts.count))")
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
    .task(id: model.ordering) {
      await model.onTask()
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
  FactFeatureView(model: FactFeatureModel(database: .appDatabase))
}
