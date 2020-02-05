import Combine
import ComposableArchitecture
import Foundation

public struct PrimeAlert: Equatable, Identifiable {
  public let n: Int
  public let prime: Int

  public var id: Int {
    self.n
  }

  public init(
    n: Int,
    prime: Int
  ) {
    self.n = n
    self.prime = prime
  }
}

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

public func offlineNthPrime(_ n: Int) -> Effect<Int?> {
  return Future { callback in
//    sleep(2)
    var primeCount = 0
    var index = 1
    while primeCount < n {
      index += 1
      if isPrime(index) {
        primeCount += 1
      }
    }
    callback(.success(index))
  }
//  .subscribe(on: DispatchQueue.global())
//  .receive(on: DispatchQueue.main)
  .eraseToEffect()
}

public func isPrime(_ p: Int) -> Bool {
  if p <= 1 { return false }
  if p <= 3 { return true }
  for i in 2...Int(sqrtf(Float(p))) {
    if p % i == 0 { return false }
  }
  return true
}
