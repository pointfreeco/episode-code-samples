import Foundation
import Perception
import SwiftNavigation

@MainActor
@Perceptible
class CounterModel: HashableObject {
  var count = 0 {
    didSet {
      isTextFocused = !count.isMultiple(of: 3)
    }
  }
  var fact: Fact?
  var factIsLoading = false
  var isTextFocused = false
  var text = ""

  struct Fact: Identifiable {
    var value: String
    var id: String { value }
  }

  func incrementButtonTapped() {
    count += 1
    fact = nil
  }

  func decrementButtonTapped() {
    count -= 1
    fact = nil
  }

  func factButtonTapped() async {
    fact = nil
    factIsLoading = true
    defer { factIsLoading = false }

    do {
      try await Task.sleep(for: .seconds(1))
      let loadedFact = try await String(
        decoding: URLSession.shared
          .data(
            from: URL(string: "http://www.numberapi.com/\(count)")!
          ).0,
        as: UTF8.self
      )
      fact = Fact(value: loadedFact)
    } catch {
      // TODO: error handling
    }
  }
}
