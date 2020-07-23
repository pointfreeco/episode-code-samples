import Combine
import CoreLocation

public struct LocationClient {
  public var authorizationStatus: () -> CLAuthorizationStatus
  public var requestWhenInUseAuthorization: () -> Void
  public var requestLocation: () -> Void
  public var delegate: AnyPublisher<DelegateEvent, Never>
  
  public init(
    authorizationStatus: @escaping () -> CLAuthorizationStatus,
    requestWhenInUseAuthorization: @escaping () -> Void,
    requestLocation: @escaping () -> Void,
    delegate: AnyPublisher<DelegateEvent, Never>
  ) {
    self.authorizationStatus = authorizationStatus
    self.requestWhenInUseAuthorization = requestWhenInUseAuthorization
    self.requestLocation = requestLocation
    self.delegate = delegate
  }
  
  public enum DelegateEvent {
    case didChangeAuthorization(CLAuthorizationStatus)
    case didUpdateLocations([CLLocation])
    case didFailWithError(Error)
  }
}
