import JavaScriptKit
import SwiftNavigation

func alert<Item>(
  item: UIBinding<Item?>,
  message: @escaping @Sendable (Item) -> String
) -> ObservationToken {
  observe {
    if let unwrappedItem = item.wrappedValue {
      _ = JSObject.global.window.alert(message(unwrappedItem))
      item.wrappedValue = nil
    }
  }
}

@MainActor
func alertDialog<Item>(
  item: UIBinding<Item?>,
  title titleFromItem: @escaping @Sendable (Item) -> String,
  message messageFromItem: @escaping @Sendable (Item) -> String
) -> ObservationToken {
  let document = JSObject.global.document

  var dialog = document.createElement("dialog")
  var title = document.createElement("h1")
  _ = dialog.appendChild(title)
  var message = document.createElement("p")
  _ = dialog.appendChild(message)
  var closeButton = document.createElement("button")
  closeButton.innerText = "Close"
  closeButton.onclick = .object(
    JSClosure { _ in
      item.wrappedValue = nil
      return .undefined
    }
  )
  dialog.oncancel = .object(
    JSClosure { _ in
      item.wrappedValue = nil
      return .undefined
    }
  )
  _ = dialog.appendChild(closeButton)
  _ = document.body.appendChild(dialog)

  return observe {
    if let unwrappedItem = item.wrappedValue {
      title.innerText = .string(titleFromItem(unwrappedItem))
      message.innerText = .string(messageFromItem(unwrappedItem))
      _ = dialog.showModal()
    } else {
      _ = dialog.close()
    }
  }
}

@MainActor
func alertDialog(
  _ state: UIBinding<AlertState<Never>?>
) -> ObservationToken {
  alertDialog(state) { _ in }
}

@MainActor
func alertDialog<Action: Sendable>(
  _ state: UIBinding<AlertState<Action>?>,
  action handler: @escaping @Sendable (Action) -> Void
) -> ObservationToken {
  let document = JSObject.global.document

  var dialog = document.createElement("dialog")
  var title = document.createElement("h1")
  _ = dialog.appendChild(title)
  var message = document.createElement("p")
  _ = dialog.appendChild(message)
  dialog.oncancel = .object(
    JSClosure { _ in
      state.wrappedValue = nil
      return .undefined
    }
  )
  _ = document.body.appendChild(dialog)

  return observe {
    if let alertState = state.wrappedValue {
      title.innerText = .string(String(state: alertState.title))
      message.innerText = .string(alertState.message.map { String(state: $0) } ?? "")
      message.hidden = .boolean(alertState.message == nil)
      _ = dialog.querySelectorAll("button").forEach(JSClosure { arguments in
        arguments.first!.remove()
      })
      if alertState.buttons.isEmpty {
        var closeButton = document.createElement("button")
        closeButton.innerText = "OK"
        closeButton.onclick = .object(
          JSClosure { _ in
            state.wrappedValue = nil
            return .undefined
          }
        )
        _ = dialog.appendChild(closeButton)
      }
      for buttonState in alertState.buttons {
        var button = document.createElement("button")
        button.innerText = .string(String(state: buttonState.label))
        button.onclick = .object(
          JSClosure { _ in
            buttonState.withAction { action in
              guard let action else { return }
              handler(action)
            }
            state.wrappedValue = nil
            return .undefined
          }
        )
        _ = dialog.appendChild(button)
      }
      _ = dialog.showModal()
    } else {
      _ = dialog.close()
    }
  }
}

//    counter.bind($model.count, to: \.value, event: \.onchange)

import IssueReporting

extension JSValue {
  @MainActor
  func bind<Value: JSValueCompatible>(
    _ binding: UIBinding<Value>,
    to keyPath: ReferenceWritableKeyPath<JSObject, JSValue>,
    event: ReferenceWritableKeyPath<JSObject, JSValue>,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
  ) -> ObservationToken {
    guard let object
    else {
      reportIssue(
        "'bind' only works on objects.",
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
      return ObservationToken()
    }

    object[keyPath: event] = .object(
      JSClosure { arguments in
        let jsValue = object[keyPath: keyPath]
        guard let value = Value.construct(from: jsValue)
        else {
          reportIssue(
            "Could not convert \(jsValueDescription(jsValue)) to \(Value.self).",
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column
          )
          return .undefined
        }
        binding.wrappedValue = value
        return .undefined
      }
    )

    return observe {
      object[keyPath: keyPath] = binding.wrappedValue.jsValue
    }
  }

  @MainActor
  func bind(
    focus binding: UIBinding<Bool>,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
  ) -> ObservationToken {
    guard let object
    else {
      reportIssue(
        "'bind' only works on objects.",
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
      return ObservationToken()
    }
    object.onfocus = .object(
      JSClosure { _ in
        binding.wrappedValue = true
        return .undefined
      }
    )
    object.onblur = .object(
      JSClosure { _ in
        binding.wrappedValue = false
        return .undefined
      }
    )
    return observe {
      if binding.wrappedValue {
        _ = object.focus?()
      } else {
        _ = object.blur?()
      }
    }
  }
}

func jsValueDescription(_ value: JSValue) -> String {
  switch value {
  case .boolean(let value):
    return "JSValue.boolean(\(value))"
  case .string(let value):
    return "JSValue.string(\"\(value)\")"
  case .number(let value):
    return "JSValue.number(\(value))"
  case .object(let value):
    return "JSValue.object(\(value))"
  case .null:
    return "JSValue.null"
  case .undefined:
    return "JSValue.undefined"
  case .function(let value):
    return "JSValue.function(\(value))"
  case .symbol(let value):
    return "JSValue.symbol(\(value))"
  case .bigInt(let value):
    return "JSValue.bigInt(\(value))"
  }
}
