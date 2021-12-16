import Combine
import CoreLocation
import Foundation

/// A client for accessing weather data for locations.
public struct WeatherClient {
  public var weather: (Int) async throws -> WeatherResponse
  public var searchLocations: (CLLocationCoordinate2D) async throws -> [Location]

  public init(
    weather: @escaping (Int) async throws -> WeatherResponse,
    searchLocations: @escaping (CLLocationCoordinate2D) async throws -> [Location]
  ) {
    self.weather = weather
    self.searchLocations = searchLocations
  }
}

public struct WeatherResponse: Decodable, Equatable {
  public var consolidatedWeather: [ConsolidatedWeather]

  public struct ConsolidatedWeather: Decodable, Equatable {
    public var applicableDate: Date
    public var id: Int
    public var maxTemp: Double
    public var minTemp: Double
    public var theTemp: Double
  }
}

public struct Location: Decodable, Equatable {
  public var title: String
  public var woeid: Int
}
