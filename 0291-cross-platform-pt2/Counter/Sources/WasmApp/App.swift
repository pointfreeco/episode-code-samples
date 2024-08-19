import Counter
import JavaScriptEventLoop
import JavaScriptKit
import SwiftNavigation

@main
@MainActor
struct App {
  static var tokens: Set<ObservationToken> = []

  static func main() {
    JavaScriptEventLoop.installGlobalExecutor()

    let model = CounterModel()

    let document = JSObject.global.document

    var countLabel = document.createElement("span")
    _ = document.body.appendChild(countLabel)

    var decrementButton = document.createElement("button")
    decrementButton.innerText = "-"
    decrementButton.onclick = .object(
      JSClosure { _ in
        model.decrementButtonTapped()
        return .undefined
      }
    )
    _ = document.body.appendChild(decrementButton)

    var incrementButton = document.createElement("button")
    incrementButton.innerText = "+"
    incrementButton.onclick = .object(
      JSClosure { _ in
        model.incrementButtonTapped()
        return .undefined
      }
    )
    _ = document.body.appendChild(incrementButton)

    observe {
      countLabel.innerText = .string("Count: \(model.count)")
    }
    .store(in: &tokens)
  }
}
