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

//    var countLabel = document.createElement("span")
//    _ = document.body.appendChild(countLabel)
//
//    var decrementButton = document.createElement("button")
//    decrementButton.innerText = "-"
//    decrementButton.onclick = .object(
//      JSClosure { _ in
//        model.decrementButtonTapped()
//        return .undefined
//      }
//    )
//    _ = document.body.appendChild(decrementButton)
//
//    var incrementButton = document.createElement("button")
//    incrementButton.innerText = "+"
//    incrementButton.onclick = .object(
//      JSClosure { _ in
//        model.incrementButtonTapped()
//        return .undefined
//      }
//    )
//    _ = document.body.appendChild(incrementButton)

    var counter = document.createElement("input")
    counter.type = "number"
    _ = document.body.appendChild(counter)
    counter
      .bind($model.count.toString, to: \.value, event: \.onchange)
      .store(in: &tokens)

    var toggleTimerButton = document.createElement("button")
    toggleTimerButton.onclick = .object(
      JSClosure { _ in
        model.toggleTimerButtonTapped()
        return .undefined
      }
    )
    _ = document.body.appendChild(toggleTimerButton)

    var textField = document.createElement("input")
    textField.type = "text"
    _ = document.body.appendChild(textField)
    textField.bind($model.text, to: \.value, event: \.onkeyup)
      .store(in: &tokens)

    textField.bind(focus: $model.isTextFocused)
      .store(in: &tokens)

//    enum Focus {
//      case counter
//      case textField
//    }
//    var focus: Focus?
//    counter.bind(focus: $model.focus, equals: .counter)
//    textField.bind(focus: $model.focus, equals: .textField)

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

    var factsHeader = document.createElement("h3")
    factsHeader.innerText = "Saved facts"
    _ = document.body.appendChild(factsHeader)

    var factsTable = document.createElement("table")
    _ = document.body.appendChild(factsTable)

    observe {
      //countLabel.innerText = .string("Count: \(model.count)")
      toggleTimerButton.innerText = model.isTimerRunning ? "Stop timer" : "Start timer"

      if model.factIsLoading {
        factLabel.innerText = "Fact is loading..."
      } else {
        factLabel.innerText = ""
      }
    }
    .store(in: &tokens)

    observe {
      factsHeader.hidden = .boolean(model.savedFacts.isEmpty)
      _ = factsTable.querySelectorAll("tr").forEach(JSClosure { arguments in
        _ = arguments.first?.remove()
        return .undefined
      })
      for fact in model.savedFacts {
        var row = document.createElement("tr")
        _ = factsTable.appendChild(row)

        var factColumn = document.createElement("td")
        _ = row.appendChild(factColumn)
        factColumn.innerText = .string(fact)

        var deleteColumn = document.createElement("td")
        _ = row.appendChild(deleteColumn)

        var deleteButton = document.createElement("button")
        deleteButton.innerText = "Delete"
        deleteButton.onclick = .object(
          JSClosure { _ in
            model.deleteFactButtonTapped(fact: fact)
            return .undefined
          }
        )
        _ = row.appendChild(deleteButton)
      }
    }
    .store(in: &tokens)

    alertDialog($model.alert) { action in
      model.handle(alertAction: action)
    }
    .store(in: &tokens)
  }
}

extension Int {
  fileprivate var toString: String {
    get {
      String(self)
    }
    set {
      self = Int(newValue) ?? 0
    }
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