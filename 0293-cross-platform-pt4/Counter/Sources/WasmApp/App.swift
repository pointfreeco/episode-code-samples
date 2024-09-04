import Counter
import IssueReporting
import JavaScriptEventLoop
import JavaScriptKit
import SwiftNavigation

@main
@MainActor
struct App {
  static var tokens: Set<ObservationToken> = []

  static func main() {
    IssueReporters.current = [JavaScriptConsoleWarning()]
    JavaScriptEventLoop.installGlobalExecutor()

    @UIBindable var model = CounterModel()

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

    var factButton = document.createElement("button")
    factButton.innerText = "Get fact"
    factButton.onclick = .object(
      JSClosure { _ in
        Task { await model.factButtonTapped() }
        return .undefined
      }
    )
    _ = document.body.appendChild(factButton)

    var factLabel = document.createElement("div")
    _ = document.body.appendChild(factLabel)

    observe {
      countLabel.innerText = .string("Count: \(model.count)")

      if model.factIsLoading {
        factLabel.innerText = "Fact is loading..."
      } else {
        factLabel.innerText = ""
      }
    }
    .store(in: &tokens)

//    alertDialog(item: $model.fact) { _ in
//      "Fact"
//    } message: { fact in
//      fact.value
//    }
//    .store(in: &tokens)

    alertDialog($model.alert)
      .store(in: &tokens)
  }
}

struct JavaScriptConsoleWarning: IssueReporter {
  func reportIssue(
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    #if DEBUG
    _ = JSObject.global.console.warn("""
      \(fileID):\(line) - \(message() ?? "")
      """)
    #endif
  }
}
