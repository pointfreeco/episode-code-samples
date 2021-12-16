import ConcurrencyExtensions
import CoreLocation

extension LocationClient {
  public static var authorizedWhenInUse: Self {
    let (continuation, stream) = AsyncStream<DelegateEvent>.passthrough()

    return Self(
      authorizationStatus: { .authorizedWhenInUse },
      requestWhenInUseAuthorization: { },
      requestLocation: {
        continuation.yield(.didUpdateLocations([CLLocation()]))
      },
      delegate: stream
    )
  }

  public static var notDetermined: Self {
    var status = CLAuthorizationStatus.notDetermined
    let (continuation, stream) = AsyncStream<DelegateEvent>.passthrough()

    return Self(
      authorizationStatus: { status },
      requestWhenInUseAuthorization: {
        status = .authorizedWhenInUse
        continuation.yield(.didChangeAuthorization(status))
      },
      requestLocation: {
        continuation.yield(.didUpdateLocations([CLLocation()]))
      },
      delegate: stream
    )
  }
}
