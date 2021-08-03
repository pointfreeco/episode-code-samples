import Combine
import ComposableArchitecture
import MapKit
import XCTest
@testable import Search

class SearchTests: XCTestCase {
  func testExample() throws {
    let completions = PassthroughSubject<Result<[LocalSearchCompletion], Error>, Never>()

    let store = TestStore(
      initialState: .init(),
      reducer: appReducer,
      environment: .init(
        localSearch: .failing,
        localSearchCompleter: .failing,
        mainQueue: .immediate
      )
    )

    store.environment.localSearchCompleter.completions = {
      completions.eraseToEffect()
    }
    let completion = LocalSearchCompletion(
      subtitle: "Search Nearby",
      title: "Apple Store"
    )
    store.environment.localSearchCompleter.search = { query in
      .fireAndForget {
        completions.send(.success([completion]))
      }
    }
    let response = LocalSearchClient.Response(
      boundingRegion: .init(
        center: .init(latitude: 0, longitude: 0),
        span: .init(latitudeDelta: 1, longitudeDelta: 1)
      ),
      mapItems: [MKMapItem()]
    )
    store.environment.localSearch.search = { _ in
      .init(value: response)
    }
    defer { completions.send(completion: .finished) }

    store.send(.onAppear)

    store.send(.queryChanged("Apple")) {
      $0.query = "Apple"
    }

    store.receive(.completionsUpdated(.success([completion]))) {
      $0.completions = [completion]
    }

    store.send(.tappedCompletion(completion)) {
      $0.query = "Apple Store"
    }

    store.receive(.searchResponse(.success(response))) {
      $0.region = response.boundingRegion
      $0.mapItems = response.mapItems
    }
  }
}

extension LocalSearchClient {
  static let failing = Self(
    search: { _ in .failing("LocalSearchClient.search is unimplemented") }
  )
}

extension LocalSearchCompleter {
  static let failing = Self(
    completions: {
      .failing("LocalSearchCompleter.completions is unimplemented")
    },
    search: { _ in
        .failing("LocalSearchCompleter.search is unimplemented")
    }
  )
}
