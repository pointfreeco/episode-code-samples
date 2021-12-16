import Combine
import CoreLocation
import LocationClient
import PathMonitorClient
@testable import WeatherClient
import XCTest
@testable import WeatherFeature

extension WeatherResponse {
  static let moderateWeather = WeatherResponse(
    consolidatedWeather: [
      .init(
        applicableDate: Date(timeIntervalSinceReferenceDate: 0),
        id: 1,
        maxTemp: 30,
        minTemp: 20,
        theTemp: 25
      ),
    ]
  )
}

extension Location {
  static let brooklyn = Location(title: "Brooklyn", woeid: 1)
}

//extension AnyPublisher {
//  init(_ value: Output) {
//    self = Just(value).setFailureType(to: Failure.self).eraseToAnyPublisher()
//  }
//}

extension WeatherClient {
  static let unimplemented = Self(
    weather: { _ in fatalError() },
    searchLocations: { _ in fatalError() }
  )
}

@MainActor
class WeatherFeatureTests: XCTestCase {
  func testBasics() async {
    let viewModel = AppViewModel(
      locationClient: .authorizedWhenInUse,
      pathMonitorClient: .satisfied,
      weatherClient: WeatherClient(
        weather: { _ in .moderateWeather },
        searchLocations: { _ in [.brooklyn] }
      )
    )
    Task { await viewModel.task() }
    await Task.yield()

    XCTAssertEqual(viewModel.currentLocation, .brooklyn)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, WeatherResponse.moderateWeather.consolidatedWeather)
  }
  
  func testDisconnected() async {
    let viewModel = AppViewModel(
      locationClient: .authorizedWhenInUse,
      pathMonitorClient: .unsatisfied,
      weatherClient: .unimplemented
    )
    Task { await viewModel.task() }
    await Task.yield()

    XCTAssertEqual(viewModel.currentLocation, nil)
    XCTAssertEqual(viewModel.isConnected, false)
    XCTAssertEqual(viewModel.weatherResults, [])
  }
  
  func testPathUpdates() async {
    let pathUpdates = AsyncStream<NetworkPath>.passthrough()
    let viewModel = AppViewModel(
      locationClient: .authorizedWhenInUse,
      pathMonitorClient: PathMonitorClient(networkPathUpdates: pathUpdates.stream),
      weatherClient: WeatherClient(
        weather: { _ in .moderateWeather },
        searchLocations: { _ in [.brooklyn] }
      )
    )
    Task { await viewModel.task() }
    pathUpdates.continuation.yield(.init(status: .satisfied))
    await Task.yield()

    XCTAssertEqual(viewModel.currentLocation, .brooklyn)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, WeatherResponse.moderateWeather.consolidatedWeather)
    
    pathUpdates.continuation.yield(.init(status: .unsatisfied))
    await Task.yield()

    XCTAssertEqual(viewModel.currentLocation, .brooklyn)
    XCTAssertEqual(viewModel.isConnected, false)
    XCTAssertEqual(viewModel.weatherResults, [])
    
    pathUpdates.continuation.yield(.init(status: .satisfied))
    await Task.yield()

    XCTAssertEqual(viewModel.currentLocation, .brooklyn)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, WeatherResponse.moderateWeather.consolidatedWeather)
  }

  func testLocationAuthorization() async {
    var authorizationStatus = CLAuthorizationStatus.notDetermined
    let locationDelegate = AsyncStream<LocationClient.DelegateEvent>.passthrough()

    let viewModel = AppViewModel(
      locationClient: LocationClient(
        authorizationStatus: { authorizationStatus },
        requestWhenInUseAuthorization: {
          authorizationStatus = .authorizedWhenInUse
          locationDelegate.continuation.yield(.didChangeAuthorization(authorizationStatus))
        },
        requestLocation: {
          locationDelegate.continuation.yield(.didUpdateLocations([CLLocation()]))
        },
        delegate: locationDelegate.stream
      ),
      pathMonitorClient: .satisfied,
      weatherClient: WeatherClient(
        weather: { _ in .moderateWeather },
        searchLocations: { _ in [.brooklyn] }
      )
    )
    Task { await viewModel.task() }
    await Task.yield()

    XCTAssertEqual(viewModel.currentLocation, nil)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, [])

    viewModel.locationButtonTapped()
    await Task.yield()

    XCTAssertEqual(viewModel.currentLocation, .brooklyn)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, WeatherResponse.moderateWeather.consolidatedWeather)
  }

  func testLocationAuthorizationDenied() {
    var authorizationStatus = CLAuthorizationStatus.notDetermined
    let locationDelegate = AsyncStream<LocationClient.DelegateEvent>.passthrough()

    let viewModel = AppViewModel(
      locationClient: LocationClient(
        authorizationStatus: { authorizationStatus },
        requestWhenInUseAuthorization: {
          authorizationStatus = .denied
          locationDelegate.continuation.yield(.didChangeAuthorization(authorizationStatus))
        },
        requestLocation: { fatalError() },
        delegate: locationDelegate.stream
      ),
      pathMonitorClient: .satisfied,
      weatherClient: WeatherClient(
        weather: { _ in .moderateWeather },
        searchLocations: { _ in [.brooklyn] }
      )
    )

    XCTAssertEqual(viewModel.currentLocation, nil)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, [])
    //XCTAssertEqual(viewModel.authorizationAlert, nil)

    viewModel.locationButtonTapped()

    XCTAssertEqual(viewModel.currentLocation, nil)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, [])
    //XCTAssertEqual(viewModel.authorizationAlert, "Please give us location access.")
  }
}
