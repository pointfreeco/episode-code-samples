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

@Observable
@MainActor
class FactFeatureModel {
  @ObservationIgnored
  @Shared(.count) var count

  var fact: String?

  @ObservationIgnored
  @Shared(.favoriteFacts) var favoriteFacts

  @ObservationIgnored
  @Dependency(FactClient.self) var factClient

  @ObservationIgnored
  @Dependency(\.date.now) var now

  @ObservationIgnored
  @Dependency(\.uuid) var uuid

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
    }
  }

  func deleteFacts(indexSet: IndexSet) {
    $favoriteFacts.withLock {
      $0.remove(atOffsets: indexSet)
    }
  }
}

struct FactFeatureView: View {
  @State var model = FactFeatureModel()

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
          Text("Favorites")
        }
      }
    }
  }
}

extension SharedKey where Self == FileStorageKey<[Fact]>.Default {
  static var favoriteFacts: Self {
    Self[.fileStorage(dump(.documentsDirectory.appending(component: "favorite-facts.json"))), default: []]
  }
}

#Preview {
  @Shared(.count) var count = 101
  @Shared(.favoriteFacts) var favoriteFacts = (1...100).map { index in
    Fact(id: UUID(), number: index, savedAt: Date(), value: "\(index) is a really good number!")
  }
  FactFeatureView()
}

#Preview {
  FactFeatureView()
}

#Preview(
  "Live",
  traits: .dependency(\.context, .live)
) {
  FactFeatureView()
}
