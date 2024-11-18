import Dependencies
import IssueReporting
import Sharing
import SwiftUI

struct Fact: Codable, Identifiable {
  let id: UUID
  var number: Int
  var savedAt: Date
  var value: String
}

@Observable
class FactFeatureModel {
  @ObservationIgnored
  @Shared(.count) var count

  var fact: String?

  @ObservationIgnored
  @Shared(.favoriteFacts) var favoriteFacts

  @ObservationIgnored
  @Dependency(FactClient.self) var factClient

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
        $0.insert(Fact(id: UUID(), number: count, savedAt: Date(), value: fact), at: 0)
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
//  @AppStorage("favoriteFacts") var favoriteFacts: [String] = []

  var body: some View {
    Form {
      Section {
        Text(/*@START_MENU_TOKEN@*/"0"/*@END_MENU_TOKEN@*/)
        Button("Decrement") { }
        Button("Increment") { }
      }
      Section {
        Button("Get fact") { }
        if /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is fact loaded?@*/true/*@END_MENU_TOKEN@*/ {
          HStack {
            Text(/*@START_MENU_TOKEN@*/"0 is a good number!"/*@END_MENU_TOKEN@*/)
            Button {
            } label: {
              if /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is fact already saved?@*/false/*@END_MENU_TOKEN@*/ {
                Image(systemName: "star.fill")
              } else {
                Image(systemName: "star")
              }
            }
          }
        }
      }
      if /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Any saved facts?@*/true/*@END_MENU_TOKEN@*/ {
        Section {
          ForEach(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=facts@*/[1, 2, 3], id: \.self/*@END_MENU_TOKEN@*/) { fact in
            Text(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=fact@*/"\(fact) is a good number"/*@END_MENU_TOKEN@*/)
          }
          .onDelete { indexSet in
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
    Self[.fileStorage(.documentsDirectory.appending(component: "favorite-facts.json")), default: []]
  }
}

#Preview {
  FactFeatureView()
}
