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
}

import ComposableArchitecture

func wolframAlpha(query: String) -> Effect<WolframAlphaResult?> {
  var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
  components.queryItems = [
    URLQueryItem(name: "input", value: query),
    URLQueryItem(name: "format", value: "plaintext"),
    URLQueryItem(name: "output", value: "JSON"),
    URLQueryItem(name: "appid", value: wolframAlphaApiKey),
  ]

    return Effect<Data?>.init { observer, lifetime in
        let task = URLSession.shared.dataTask(with: components.url!) { data, _, _ in
            observer.send(value: data)
            observer.sendCompleted()
        }
        task.resume()
    }
    .skipNil()
    .filterMap { try? JSONDecoder.init().decode(WolframAlphaResult.self, from: $0) }
}
