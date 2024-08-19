import Foundation
import Perception
import SwiftNavigation

@MainActor
@Perceptible
public class CounterModel: HashableObject {
  public var count = 0 {
    didSet {
      isTextFocused = !count.isMultiple(of: 3)
    }
  }
  public var fact: Fact?
  public var factIsLoading = false
  public var isTextFocused = false
  public var text = ""

  public struct Fact: Identifiable {
    public var value: String
    public var id: String { value }
  }

  public init() {}

  public func incrementButtonTapped() {
    count += 1
    fact = nil
  }

  public func decrementButtonTapped() {
    count -= 1
    fact = nil
  }

  public func factButtonTapped() async {
    fact = nil
    factIsLoading = true
    defer { factIsLoading = false }

    do {
      try await Task.sleep(for: .seconds(1))
//      let loadedFact = try await String(
//        decoding: URLSession.shared
//          .data(
//            from: URL(string: "http://www.numberapi.com/\(count)")!
//          ).0,
//        as: UTF8.self
//      )
//      fact = Fact(value: loadedFact)
    } catch {
      // TODO: error handling
    }
  }
}
