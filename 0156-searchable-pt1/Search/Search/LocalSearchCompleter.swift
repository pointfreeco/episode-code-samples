import Combine
import ComposableArchitecture
import MapKit

struct LocalSearchCompleter {
  var completions: () -> Effect<Result<[MKLocalSearchCompletion], Error>, Never>
  var search: (String) -> Effect<Never, Never>
}

extension LocalSearchCompleter {
  static var live: Self {
    class Delegate: NSObject, MKLocalSearchCompleterDelegate {
      let subscriber: Effect<Result<[MKLocalSearchCompletion], Error>, Never>.Subscriber

      init(subscriber: Effect<Result<[MKLocalSearchCompletion], Error>, Never>.Subscriber) {
        self.subscriber = subscriber
      }

      func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.subscriber.send(.success(completer.results))
      }

      func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.subscriber.send(.failure(error))
      }
    }

    let completer = MKLocalSearchCompleter()

    return Self(
      completions: {
        Effect.run { subscriber in
          let delegate = Delegate(subscriber: subscriber)
          completer.delegate = delegate

          return AnyCancellable {
            _ = delegate
          }
        }
      },
      search: { queryFragment in
        .fireAndForget {
          completer.queryFragment = queryFragment
        }
      }
    )
  }
}
