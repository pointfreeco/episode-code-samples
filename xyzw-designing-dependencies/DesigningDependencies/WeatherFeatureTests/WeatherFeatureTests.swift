import Combine
import LocationClient
import PathMonitorClient
@testable import WeatherClient
import XCTest
@testable import WeatherFeature

class WeatherFeatureTests: XCTestCase {

  func testBasics() {
    let moderateWeather = WeatherResponse(
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
    let brooklyn = Location(title: "Brooklyn", woeid: 1)

    let viewModel = AppViewModel(
      locationClient: .authorizedWhenInUse,
      pathMonitorClient: .satisfied,
      weatherClient: WeatherClient(
        weather: { _ in
          Just(moderateWeather)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        },
        searchLocations: { _ in
          Just([brooklyn])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
      )
    )

    XCTAssertEqual(viewModel.currentLocation, brooklyn)
    XCTAssertEqual(viewModel.isConnected, true)
    XCTAssertEqual(viewModel.weatherResults, moderateWeather.consolidatedWeather)
  }
}
