import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacroExpansion

extension Array where Element == Diagnostic {
  func underlineHighlights(
    lineNumber: Int,
    column: Int,
    context: BasicMacroExpansionContext
  ) -> String? {
    let (highlightColumns, highlightLineLength) = self.reduce(
      into: (highlightColumns: Set<Int>(), highlightLineLength: column + 1)
    ) { partialResult, diag in
      for highlight in diag.highlights {
        let highlight = highlight.trimmed
        let startLocation = context.location(
          for: highlight.position, anchoredAt: diag.node, fileName: ""
        )
        let endLocation = context.location(
          for: highlight.endPosition, anchoredAt: diag.node, fileName: ""
        )
        guard startLocation.line == lineNumber, startLocation.line == endLocation.line
        else { continue }
        partialResult.highlightColumns.formUnion(startLocation.column..<endLocation.column)
        partialResult.highlightLineLength = Swift.max(
          partialResult.highlightLineLength, endLocation.column
        )
      }
    }
    guard !highlightColumns.isEmpty else { return nil }
    return String(
      (0..<highlightLineLength).map {
        $0 == column
          ? "┬"
          : highlightColumns.contains($0)
            ? "─"
            : " "
      }
    )
  }
}
