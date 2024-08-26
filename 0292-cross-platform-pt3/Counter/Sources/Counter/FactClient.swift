import Dependencies
import DependenciesMacros
#if canImport(JavaScriptKit)
  @preconcurrency import JavaScriptKit
#endif
#if canImport(JavaScriptEventLoop)
  import JavaScriptEventLoop
#endif

@DependencyClient
struct FactClient: Sendable {
  var fetch: @Sendable (Int) async throws -> String
}

extension FactClient: TestDependencyKey {
  static let testValue = FactClient()
}

extension FactClient: DependencyKey {
  static let liveValue = FactClient { number in
#if canImport(JavaScriptKit) && canImport(JavaScriptEventLoop)
    let response = try await JSPromise(
      JSObject.global.fetch!("http://www.numberapi.com/\(number)").object!
    )!.value
    return try await JSPromise(response.text().object!)!.value.string!
#else
    return try await String(
      decoding: URLSession.shared
        .data(
          from: URL(string: "http://www.numberapi.com/\(number)")!
        ).0,
      as: UTF8.self
    )
#endif
  }
}
