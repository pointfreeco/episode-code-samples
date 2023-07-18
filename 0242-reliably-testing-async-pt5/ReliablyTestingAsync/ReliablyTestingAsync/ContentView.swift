import Combine
import Dependencies
import SwiftUI

struct NumberFactClient {
  var fact: @Sendable (Int) async throws -> String
  var factPublisher: @Sendable (Int) -> AnyPublisher<String, Error>
}

extension NumberFactClient: DependencyKey {
  static let liveValue = Self { number in
    try await Task.sleep(for: .seconds(1))
    return try await String(
      decoding: URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)")!).0,
      as: UTF8.self
    )
  } factPublisher: { number in
    URLSession.shared.dataTaskPublisher(for: URL(string: "http://numbersapi.com/\(number)")!)
//      .delay(for: 1, scheduler: DispatchQueue.main)
      .map { data, _ in String(decoding: data, as: UTF8.self) }
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}

extension DependencyValues {
  var numberFact: NumberFactClient {
    get { self[NumberFactClient.self] }
    set { self[NumberFactClient.self] = newValue }
  }
}

@MainActor
class CombineNumberFactModel: ObservableObject {
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.numberFact) var numberFact

  @Published var count = 0
  @Published var fact: String?
  @Published var factCancellable: AnyCancellable?
  var isLoading: Bool { self.factCancellable != nil }

  func incrementButtonTapped() {
    self.fact = nil
    self.factCancellable?.cancel()
    self.factCancellable = nil
    self.count += 1
  }
  func decrementButtonTapped() {
    self.fact = nil
    self.factCancellable?.cancel()
    self.factCancellable = nil
    self.count -= 1
  }
  func getFactButtonTapped() {
    self.factCancellable?.cancel()

    self.fact = nil
    self.factCancellable = self.numberFact.factPublisher(self.count)
      .receive(on: self.mainQueue)
      .sink(
        receiveCompletion: { [weak self] _ in
          // TODO: Handle error
          self?.factCancellable = nil
        },
        receiveValue: { [weak self] fact in
          self?.fact = fact
        }
      )
  }
  func cancelButtonTapped() {
    self.factCancellable?.cancel()
    self.factCancellable = nil
  }
  var notificationCancellable: AnyCancellable?
  func onTask() {
    self.notificationCancellable = NotificationCenter.default.publisher(for:  UIApplication.userDidTakeScreenshotNotification)
      .sink { [weak self] _ in
        self?.count += 1
      }
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
  @ObservedObject var model: CombineNumberFactModel

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
    ContentView(model: CombineNumberFactModel())
  }
}
