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

extension AnyPublisher {
  init(_ value: Output) {
    self = Just(value).setFailureType(to: Failure.self).eraseToAnyPublisher()
  }
}

extension WeatherClient {
  static let unimplemented = Self(
    weather: { _ in fatalError() },
    searchLocations: { _ in fatalError() }
  )
}

class WeatherFeatureTests: XCTestCase {
  let mainQueue = DispatchQueue.testScheduler

  func testBasics() {
    let viewModel = AppViewModel(
      locationClient: .authorizedWhenInUse,
      pathMonitorClient: .satisfied,
      weatherClient: WeatherClient(
        weather: { _ in .init(.moderateWeather) },
        searchLocations: { _ in .init([.brooklyn]) }
      ),
      mainQueue: .immediate
        //ImmediateScheduler.shared.eraseToAnyScheduler()
        //mainQueue.eraseToAnyScheduler()
    )
    
//    ImmediateScheduler
    
//    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)

//    mainQueue.advance()

    XCTAssertEqual(viewModel.currentLocation, .brooklyn)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, WeatherResponse.moderateWeather.consolidatedWeather)
  }

  func testCancellation() {
    let viewModel = AppViewModel(
      locationClient: .authorizedWhenInUse,
      pathMonitorClient: .satisfied,
      weatherClient: WeatherClient(
        weather: { _ in .init(.moderateWeather) },
        searchLocations: { _ in .init([.brooklyn]) }
      ),
      mainQueue: mainQueue.eraseToAnyScheduler()
        // .immediate
        //ImmediateScheduler.shared.eraseToAnyScheduler()
        //mainQueue.eraseToAnyScheduler()
    )

    viewModel.cancelButtonTapped()
    self.mainQueue.run()

    XCTAssertEqual(viewModel.currentLocation, nil)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, [])
  }
  
  func testDisconnected() {
    let viewModel = AppViewModel(
      locationClient: .authorizedWhenInUse,
      pathMonitorClient: .unsatisfied,
      weatherClient: .unimplemented,
      mainQueue: .failing
    )

    XCTAssertEqual(viewModel.currentLocation, nil)
    XCTAssertEqual(viewModel.isConnected, false)
    XCTAssertEqual(viewModel.weatherResults, [])
  }

  func testPathUpdates() {
    let pathUpdateSubject = PassthroughSubject<NetworkPath, Never>()
    let viewModel = AppViewModel(
      locationClient: .authorizedWhenInUse,
      pathMonitorClient: PathMonitorClient(
        networkPathPublisher: pathUpdateSubject
          .eraseToAnyPublisher()
      ),
      weatherClient: WeatherClient(
        weather: { _ in .init(.moderateWeather) },
        searchLocations: { _ in .init([.brooklyn]) }
      ),
      mainQueue: .immediate // self.mainQueue.eraseToAnyScheduler()
    )
    pathUpdateSubject.send(.init(status: .satisfied))
//    self.mainQueue.advance()

    XCTAssertEqual(viewModel.currentLocation, .brooklyn)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, WeatherResponse.moderateWeather.consolidatedWeather)

    pathUpdateSubject.send(.init(status: .unsatisfied))

    XCTAssertEqual(viewModel.currentLocation, .brooklyn)
    XCTAssertEqual(viewModel.isConnected, false)
    XCTAssertEqual(viewModel.weatherResults, [])

    pathUpdateSubject.send(.init(status: .satisfied))
//    self.mainQueue.advance()

    XCTAssertEqual(viewModel.currentLocation, .brooklyn)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, WeatherResponse.moderateWeather.consolidatedWeather)
  }

  func testLocationAuthorization() {
    var authorizationStatus = CLAuthorizationStatus.notDetermined
    let locationDelegateSubject = PassthroughSubject<LocationClient.DelegateEvent, Never>()

    let viewModel = AppViewModel(
      locationClient: LocationClient(
        authorizationStatus: { authorizationStatus },
        requestWhenInUseAuthorization: {
          authorizationStatus = .authorizedWhenInUse
          locationDelegateSubject.send(.didChangeAuthorization(authorizationStatus))
        },
        requestLocation: {
          locationDelegateSubject.send(.didUpdateLocations([CLLocation()]))
        },
        delegate: locationDelegateSubject.eraseToAnyPublisher()
      ),
      pathMonitorClient: .satisfied,
      weatherClient: WeatherClient(
        weather: { _ in .init(.moderateWeather) },
        searchLocations: { _ in .init([.brooklyn]) }
      ),
      mainQueue: .immediate //self.mainQueue.eraseToAnyScheduler()
    )

    XCTAssertEqual(viewModel.currentLocation, nil)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, [])

    viewModel.locationButtonTapped()
//    self.mainQueue.advance()

    XCTAssertEqual(viewModel.currentLocation, .brooklyn)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, WeatherResponse.moderateWeather.consolidatedWeather)
  }

  func testLocationAuthorizationDenied() {
    var authorizationStatus = CLAuthorizationStatus.notDetermined
    let locationDelegateSubject = PassthroughSubject<LocationClient.DelegateEvent, Never>()

    let viewModel = AppViewModel(
      locationClient: LocationClient(
        authorizationStatus: { authorizationStatus },
        requestWhenInUseAuthorization: {
          authorizationStatus = .denied
          locationDelegateSubject.send(.didChangeAuthorization(authorizationStatus))
        },
        requestLocation: { fatalError() },
        delegate: locationDelegateSubject.eraseToAnyPublisher()
      ),
      pathMonitorClient: .satisfied,
      weatherClient: WeatherClient(
        weather: { _ in .init(.moderateWeather) },
        searchLocations: { _ in .init([.brooklyn]) }
      ),
      mainQueue: .failing
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
