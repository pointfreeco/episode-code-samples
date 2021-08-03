import ComposableArchitecture
import MapKit

struct LocalSearchClient {
  var search: (MKLocalSearchCompletion) -> Effect<MKLocalSearch.Response, Error>
}

extension LocalSearchClient {
  static let live = Self(
    search: { completion in
        .task {
          try await MKLocalSearch(request: .init(completion: completion))
            .start()
        }
    }
  )
}

extension Effect {
  static func task(
    priority: TaskPriority? = nil,
    operation: @escaping @Sendable () async throws -> Output
  ) -> Self
  where Failure == Error {

    .future { callback in
      Task(priority: priority) {
        do {
          callback(.success(try await operation()))
        } catch {
          callback(.failure(error))
        }
      }
    }
  }
}
