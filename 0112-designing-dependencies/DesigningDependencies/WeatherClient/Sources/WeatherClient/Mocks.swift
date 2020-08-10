import Combine
import Foundation

extension WeatherClient {
  public static let empty = Self(
    weather: {
      Just(WeatherResponse(consolidatedWeather: []))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
  },
    searchLocations: { _ in
      Just([]).setFailureType(to: Error.self)
        .eraseToAnyPublisher()
  })

  public static let happyPath = Self(
    weather: {
      Just(
        WeatherResponse(
          consolidatedWeather: [
            .init(applicableDate: Date(), id: 1, maxTemp: 30, minTemp: 10, theTemp: 20),
            .init(applicableDate: Date().addingTimeInterval(86400), id: 2, maxTemp: -10, minTemp: -30, theTemp: -20)
          ]
        )
      )
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
    }, searchLocations: { _ in
      Just([])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    })

  public static let failed = Self(
    weather: {
      Fail(error: NSError(domain: "", code: 1))
        .eraseToAnyPublisher()
    }, searchLocations: { _ in
      Just([])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    })
}

