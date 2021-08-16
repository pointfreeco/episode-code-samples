import ComposableArchitecture
import MapKit

struct LocalSearchClient {
  var search: (LocalSearchCompletion) -> Effect<Response, Error>

  struct Response: Equatable {
    var boundingRegion = CoordinateRegion()
    var mapItems: [MKMapItem] = []
  }
}

extension LocalSearchClient.Response {
  init(rawValue: MKLocalSearch.Response) {
    self.boundingRegion = .init(rawValue: rawValue.boundingRegion)
    self.mapItems = rawValue.mapItems
  }
}

extension LocalSearchClient {
  static let live = Self(
    search: { completion in
        .task {
          .init(
            rawValue:
              try await MKLocalSearch(request: .init(completion: completion.rawValue!))
              .start()
          )
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
