import SwiftSyntax
import SwiftSyntaxMacros

/// Implementation of the `#fontLiteral` macro, which is similar in spirit
/// to the built-in expressions `#colorLiteral`, `#imageLiteral`, etc., but in
/// a small macro.
public struct FontLiteralMacro: ExpressionMacro {
  public static func expansion(
    of macro: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) -> ExprSyntax {
    let argList = replaceFirstLabel(
      of: macro.argumentList,
      with: "fontLiteralName"
    )
    return ".init(\(argList))"
  }
}

/// Replace the label of the first element in the tuple with the given
/// new label.
private func replaceFirstLabel(
  of tuple: LabeledExprListSyntax,
  with newLabel: String
) -> LabeledExprListSyntax {
  guard let firstElement = tuple.first else {
    return tuple
  }

  var tuple = tuple
  tuple[tuple.startIndex] = firstElement.with(\.label, .identifier(newLabel))
  return tuple
}
