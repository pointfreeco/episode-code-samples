import FactClient
import Dependencies

#if canImport(JavaScriptKit)
  @preconcurrency import JavaScriptKit
#endif
#if canImport(JavaScriptEventLoop)
  import JavaScriptEventLoop
#endif

extension FactClient: DependencyKey {
  public static let liveValue = FactClient { number in
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
