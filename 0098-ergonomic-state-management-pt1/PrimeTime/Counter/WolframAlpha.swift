import Combine
import ComposableArchitecture
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

public func nthPrime(_ n: Int) -> Effect<Int?> {
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

public func offlineNthPrime(_ n: Int) -> Effect<Int?> {
  Future { callback in
    var nthPrime = 1
    var count = 0
    while count < n {
      nthPrime += 1
      if isPrime(nthPrime) {
        count += 1
      }
    }
    callback(.success(nthPrime))
  }
  .eraseToEffect()
}

func isPrime(_ p: Int) -> Bool {
  if p <= 1 { return false }
  if p <= 3 { return true }
  for i in 2...Int(sqrtf(Float(p))) {
    if p % i == 0 { return false }
  }
  return true
}


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
}

//return [Effect { callback in
//  nthPrime(count) { prime in
//    DispatchQueue.main.async {
//      callback(.nthPrimeResponse(prime))
//    }
//  }
//}]

extension Publisher {
  public var hush: Publishers.ReplaceError<Publishers.Map<Self, Optional<Self.Output>>> {
    return self.map(Optional.some).replaceError(with: nil)
  }
}
