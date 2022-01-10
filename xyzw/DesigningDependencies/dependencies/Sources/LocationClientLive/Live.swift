import Combine
import CoreLocation
import LocationClient

extension LocationClient {
  public static var live: Self {
    final class Delegate: NSObject, CLLocationManagerDelegate, Sendable {
      let continuation: AsyncStream<DelegateEvent>.Continuation
      
      init(continuation: AsyncStream<DelegateEvent>.Continuation) {
        self.continuation = continuation
      }
      
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.continuation.yield(.didChangeAuthorization(status))
      }
      
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.continuation.yield(.didUpdateLocations(locations))
      }
      
      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.continuation.yield(.didFailWithError(error))
      }
    }

    let locationManager = CLLocationManager()
    return Self(
      authorizationStatus: { locationManager.authorizationStatus },
      requestWhenInUseAuthorization: locationManager.requestWhenInUseAuthorization,
      requestLocation: locationManager.requestLocation,
      delegate: .init { continuation in
        let delegate = Delegate(continuation: continuation)
        locationManager.delegate = delegate
        locationManager.requestLocation()
        continuation.onTermination = { @Sendable termination in
          _ = delegate
        }
      }
    )
  }
}
