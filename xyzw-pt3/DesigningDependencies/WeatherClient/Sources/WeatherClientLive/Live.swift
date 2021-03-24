import Combine
import Foundation
import WeatherClient

extension WeatherClient {
  public static let live = Self(
    weather: { id in
      URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.metaweather.com/api/location/\(id)")!)
        .map { data, _ in data }
        .decode(type: WeatherResponse.self, decoder: weatherJsonDecoder)
//        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
  },
    searchLocations: { coordinate in
      URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.metaweather.com/api/location/search?lattlong=\(coordinate.latitude),\(coordinate.longitude)")!)
        .map { data, _ in data }
        .decode(type: [Location].self, decoder: weatherJsonDecoder)
//        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
  })
}

private let weatherJsonDecoder: JSONDecoder = {
  let jsonDecoder = JSONDecoder()
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy-MM-dd"
  jsonDecoder.dateDecodingStrategy = .formatted(formatter)
  jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
  return jsonDecoder
}()


public let __tmp0 = 2 * 2 * 2 * 2.0 / 2 + 2
public let __tmp1 = 2 * 2 * 2 * 2.0 / 2 + 2
public let __tmp2 = 2 * 2 * 2 * 2.0 / 2 + 2
public let __tmp3 = 2 * 2 * 2 * 2.0 / 2 + 2
public let __tmp4 = 2 * 2 * 2 * 2.0 / 2 + 2
public let __tmp5 = 2 * 2 * 2 * 2.0 / 2 + 2
public let __tmp6 = 2 * 2 * 2 * 2.0 / 2 + 2
public let __tmp7 = 2 * 2 * 2 * 2.0 / 2 + 2
public let __tmp8 = 2 * 2 * 2 * 2.0 / 2 + 2
public let __tmp9 = 2 * 2 * 2 * 2.0 / 2 + 2
