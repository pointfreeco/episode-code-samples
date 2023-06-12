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
  @Published var factTask: Task<String, Error>?
  var isLoading: Bool { self.factTask != nil }

  func incrementButtonTapped() {
    self.fact = nil
    self.factTask?.cancel()
    self.factTask = nil
    self.count += 1
  }
  func decrementButtonTapped() {
    self.fact = nil
    self.factTask?.cancel()
    self.factTask = nil
    self.count -= 1
  }
  func getFactButtonTapped() async {
    self.factTask?.cancel()

    self.fact = nil
    self.factTask = Task {
      try await self.numberFact.fact(self.count)
    }
    defer { self.factTask = nil }
    do {
      self.fact = try await self.factTask?.value
    } catch {
      // TODO: handle error
    }
  }
  func cancelButtonTapped() {
    self.factTask?.cancel()
    self.factTask = nil
  }
  func onTask() async {
    for await _ in NotificationCenter.default.notifications(named: UIApplication.userDidTakeScreenshotNotification) {
      self.count += 1
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

      Section {
        if self.model.isLoading {
          HStack(spacing: 4) {
            Button("Cancel") {
              self.model.cancelButtonTapped()
            }
            Spacer()
            ProgressView()
              .id(UUID())
          }
        } else {
          Button("Get fact") {
            Task { await self.model.getFactButtonTapped() }
          }
        }
      }
      
      if let fact = self.model.fact {
        Text(fact)
      }
    }
    .task { await self.model.onTask() }
  }
}

struct ContentPreviews: PreviewProvider {
  static var previews: some View {
    ContentView(model: NumberFactModel())
  }
}
