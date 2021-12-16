import Combine
import Foundation

extension WeatherClient {
  public static let empty = Self(
    weather: { _ in WeatherResponse(consolidatedWeather: []) },
    searchLocations: { _ in [] }
  )

  public static let happyPath = Self(
    weather: { _ in
      WeatherResponse(
        consolidatedWeather: [
          .init(applicableDate: Date(), id: 1, maxTemp: 30, minTemp: 10, theTemp: 20),
          .init(applicableDate: Date().addingTimeInterval(86400), id: 2, maxTemp: -10, minTemp: -30, theTemp: -20)
        ]
      )
    },
    searchLocations: { _ in
      [Location(title: "New York", woeid: 1)]
    }
  )

  public static let failed = Self(
    weather: { _ in throw NSError(domain: "", code: 1) },
    searchLocations: { _ in [] }
  )
}

