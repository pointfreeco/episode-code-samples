import Foundation
import FactClient
import Dependencies

#if os(WASI)
  @preconcurrency import JavaScriptKit
  import JavaScriptEventLoop
#endif

extension FactClient: DependencyKey {
  public static let liveValue = FactClient { number in
#if os(WASI)
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
