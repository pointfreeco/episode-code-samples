import Foundation

private let wolframAlphaApiKey = "6H69Q3-828TKQJ4EP"

struct WolframAlphaResult: Decodable {
  let queryresult: QueryResult

  struct QueryResult: Decodable {
    let pods: [Pod]

    struct Pod: Decodable {
      let primary: Bool?
      let subpods: [SubPod]

      struct SubPod: Decodable {
        let plaintext: String
      }
    }
  }
}

func nthPrime(_ n: Int) -> Effect<Int?> {
  return wolframAlpha(query: "prime \(n)").map { result in
    result
      .flatMap {
        $0.queryresult
          .pods
          .first(where: { $0.primary == .some(true) })?
          .subpods
          .first?
          .plaintext
    }
    .flatMap(Int.init)
  }
  .eraseToEffect()
}

import ComposableArchitecture
import Combine

func wolframAlpha(query: String) -> Effect<WolframAlphaResult?> {
  var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
  components.queryItems = [
    URLQueryItem(name: "input", value: query),
    URLQueryItem(name: "format", value: "plaintext"),
    URLQueryItem(name: "output", value: "JSON"),
    URLQueryItem(name: "appid", value: wolframAlphaApiKey),
  ]

  return URLSession.shared
    .dataTaskPublisher(for: components.url(relativeTo: nil)!)
    .map { data, _ in data }
    .decode(type: WolframAlphaResult?.self, decoder: JSONDecoder())
    .replaceError(with: nil)
    .eraseToEffect()


//  return dataTask(with: components.url(relativeTo: nil)!)
//    .decode(as: WolframAlphaResult.self)
}
