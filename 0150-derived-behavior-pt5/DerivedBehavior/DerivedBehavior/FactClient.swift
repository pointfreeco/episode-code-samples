import ComposableArchitecture

struct FactClient {
  var fetch: (Int) -> Effect<String, Error>

  struct Error: Swift.Error, Equatable {}
}
extension FactClient {
  static let live = Self(
    fetch: { number in
      URLSession.shared.dataTaskPublisher(for: URL(string: "http://numbersapi.com/\(number)")!)
        .map { data, _ in String(decoding: data, as: UTF8.self) }
        .mapError { _ in Error() }
        .eraseToEffect()
    }
  )
}
