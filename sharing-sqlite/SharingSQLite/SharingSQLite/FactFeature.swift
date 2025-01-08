import Combine
import Dependencies
import IssueReporting
import Sharing
import SwiftUI

struct Fact: Codable, Equatable, Identifiable {
  let id: UUID
  var number: Int
  var savedAt: Date
  var value: String
}

enum Ordering: String, CaseIterable {
  case number = "Number", savedAt = "Saved at"
}

@Observable
@MainActor
class FactFeatureModel {
  var fact: String?

  @ObservationIgnored @Shared(.count) var count
  @ObservationIgnored @Shared(.favoriteFacts) var favoriteFacts
  @ObservationIgnored @Shared(.ordering) var ordering

  @ObservationIgnored @Dependency(FactClient.self) var factClient
  @ObservationIgnored @Dependency(\.date.now) var now
  @ObservationIgnored @Dependency(\.uuid) var uuid

//  var cancellables: Set<AnyCancellable> = []

  init() {
//    $ordering.publisher.sink { [weak self] ordering in
//      self?.sortFavorites(ordering: ordering)
//    }
//    .store(in: &cancellables)
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
      $favoriteFacts.withLock {
        $0.insert(Fact(id: uuid(), number: count, savedAt: now, value: fact), at: 0)
      }
      //sortFavorites(ordering: ordering)
    }
  }

  func deleteFacts(indexSet: IndexSet) {
    $favoriteFacts.withLock {
      $0.remove(atOffsets: indexSet)
    }
  }

//  private func sortFavorites(ordering: Ordering) {
//    switch ordering {
//    case .number:
//      $favoriteFacts.withLock { $0.sort(by: { $0.number < $1.number })}
//    case .savedAt:
//      $favoriteFacts.withLock { $0.sort(by: { $0.savedAt > $1.savedAt })}
//    }
//  }

  var sortedFavorites: [Fact] {
    switch ordering {
    case .number:
      favoriteFacts.sorted(by: { $0.number < $1.number })
    case .savedAt:
      favoriteFacts.sorted(by: { $0.savedAt > $1.savedAt })
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
      if !model.sortedFavorites.isEmpty {
        Section {
          ForEach(model.sortedFavorites) { fact in
            Text(fact.value)
          }
          .onDelete { indexSet in
            model.deleteFacts(indexSet: indexSet)
          }
        } header: {
          HStack {
            Text("Favorites (\(model.sortedFavorites.count))")
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
  }
}

extension SharedKey where Self == AppStorageKey<Int>.Default {
  static var count: Self {
    Self[.appStorage("count"), default: 0]
  }
}

extension SharedKey where Self == FileStorageKey<[Fact]>.Default {
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
  FactFeatureView(model: FactFeatureModel())
}
