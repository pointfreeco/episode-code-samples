import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

/// Implementation of the `myWarning` macro, which mimics the behavior of the
/// built-in `#warning`.
public struct WarningMacro: ExpressionMacro {
  public static func expansion(
    of macro: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> ExprSyntax {
    guard let firstElement = macro.argumentList.first,
          let stringLiteral = firstElement.expression
      .as(StringLiteralExprSyntax.self),
          stringLiteral.segments.count == 1,
          case let .stringSegment(messageString)? = stringLiteral.segments.first
    else {
      throw CustomError.message("#myWarning macro requires a string literal")
    }

    context.diagnose(
      Diagnostic(
        node: Syntax(macro),
        message: SimpleDiagnosticMessage(
          message: messageString.content.description,
          diagnosticID: MessageID(domain: "test", id: "error"),
          severity: .warning
        )
      )
    )

    return "()"
  }
}
