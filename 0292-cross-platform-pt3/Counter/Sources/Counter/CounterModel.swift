import Dependencies
import Foundation
import Perception
import SwiftNavigation

@MainActor
@Perceptible
public class CounterModel: HashableObject {
  @PerceptionIgnored
  @Dependency(FactClient.self) var factClient

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

      var count = count
      fact = Fact(value: try await factClient.fetch(count))
    } catch {
      // TODO: error handling
    }
  }
}
