import Dependencies
import Foundation

struct FactClient: DependencyKey {
  var fetch: @Sendable (Int) async throws -> String

  static let liveValue = FactClient { number in
    try await String(decoding: URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)")!).0, as: UTF8.self)
  }
}
