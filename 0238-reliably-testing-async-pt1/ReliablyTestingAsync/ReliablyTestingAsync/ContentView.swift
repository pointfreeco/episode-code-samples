import Dependencies
import SwiftUI

struct NumberFactClient {
  var fact: @Sendable (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
  static let liveValue = Self { number in
    try await Task.sleep(for: .seconds(1))
    return try await String(
      decoding: URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)")!).0,
      as: UTF8.self
    )
  }
}

extension DependencyValues {
  var numberFact: NumberFactClient {
    get { self[NumberFactClient.self] }
    set { self[NumberFactClient.self] = newValue }
  }
}

@MainActor
class NumberFactModel: ObservableObject {
  @Dependency(\.numberFact) var numberFact

  @Published var count = 0
  @Published var fact: String?
  @Published var isLoading = false

  func incrementButtonTapped() {
    self.fact = nil
    self.count += 1
  }
  func decrementButtonTapped() {
    self.fact = nil
    self.count -= 1
  }
  func getFactButtonTapped() async {
    self.isLoading = true
    defer { self.isLoading = false }

    self.fact = nil
    do {
      self.fact = try await self.numberFact.fact(self.count)
    } catch {
      // TODO: handle error
    }
  }
}

struct ContentView: View {
  @ObservedObject var model: NumberFactModel

  var body: some View {
    Form {
      Section {
        HStack {
          Button("-") { self.model.decrementButtonTapped() }
          Text("\(self.model.count)")
          Button("+") { self.model.incrementButtonTapped() }
        }
      }
      .buttonStyle(.plain)

      HStack {
        Button("Get fact") {
          Task { await self.model.getFactButtonTapped() }
        }
        if self.model.isLoading {
          Spacer()
          ProgressView()
        }
      }

      if let fact = self.model.fact {
        Text(fact)
      }
    }
  }
}

struct ContentPreviews: PreviewProvider {
  static var previews: some View {
    ContentView(model: NumberFactModel())
  }
}
